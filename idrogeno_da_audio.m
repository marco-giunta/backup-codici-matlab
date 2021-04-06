clear
close all
[y,fs]=audioread('idrogeno.mp3');
%sound(y,fs);
dt=length(y)/fs;
t=linspace(0,dt,dt*fs);
x=y(:,1);
plot(t,x);
[f,a]=spettroFrequenze(t,x);
figure
plot(f,a);
z=zeros(1,length(t));
for i=1:length(f)
    b=a(i).*sin(2*pi*f(i).*t);
    z=z+b;
end%forse il for è inefficiente, forse varrebbe la pena fare (sin(2pi t_c*f_r))*a_c (c colonna, r riga) ma la matrice è troppo grande così
disp("riproduco audio ricostruito dalla trasformata di Fourier");
sound(z,fs);
figure
plot(t,z);