clear
close all
%dt=9.2354;%=dt_audio
dt=4;
%dt=1.5;
t=linspace(0,dt,8000*dt);
t=t';
x=zeros(length(t),1);
for n=2:10
    x=x+sin((1-1/n^2)*2*pi*440.*t)+sin((1/4-1/(n+1)^2)*2*pi*440.*t);
    %x=x+sin(2*pi*440*(2*n-1)/2.*t)./(2*n-1);
    %plot(t,x);
    %sound(x);
    %pause(0.5);
end
plot(t,x);
sound(x);
%y=zeros(length(t),1);
%for i=1:10
%    y=y+sin(2*pi*i.*t);
%end
%figure
%plot(t,y)

[y,fs]=audioread('idrogeno.mp3');
dt_audio=length(y)/fs;
t=linspace(0,dt_audio,dt_audio*fs);
z=y(:,1);
figure
plot(t,z);