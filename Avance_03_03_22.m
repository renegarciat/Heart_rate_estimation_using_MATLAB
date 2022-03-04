clear
clc
%%Importando el video
v = VideoReader('FINGER_PULSE_TRIMMED.mp4');
i=1;
while hasFrame(v)
    RGBframes = readFrame(v);
    GRAYframes = rgb2gray(RGBframes);
    BWvideo(:,:,i)=GRAYframes;
%     imshow(GRAYframes);
%     title(sprintf('Current Time = %.3f sec', v.CurrentTime));
%     pause(2/v.FrameRate);
    i=i+1;
end

%%%%% Obtener grafica del brillo de cada frame.
%%%%% Este brillo se calcula con un promedio del brillo de todos los pixeles)
for i=1:v.NumFrames
    means(i)=mean2(BWvideo(:,:,i)); %mean of every frame 
end
t=linspace(0,v.Duration,v.NumFrames);
means=-means;

%Con la intención de no obtener una componente de DC muy alta en la FFT, se busca eliminar ese offset.
DC_component=mean(means(:));
means=means-DC_component;
figure
plot(t,means)
%Obtenemos la FFT de la señal y observamos las componentes de frecuencia que son más altas. 
Ts=1/30; %time increment for every second
fs=1/Ts;
L=length(means);
y=fft(means);
P2=abs(y/L);
P1=P2(1:L/2+1);
P1(2:end-1)=2*P1(2:end-1);
f=fs*(0:(L/2))/L;
figure
plot(f,P1)
title('FFT del vector de promedios')
xlabel('Hz')
ylabel('|F(f)|')
