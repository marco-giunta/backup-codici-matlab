clf
clear all
%X=[48 81 83 46];
%Y=[168 167 179 178];
tic
n=100;%numero di elementi fra 0 e 50
a=linspace(0,50,n);
b=zeros(1,n);
c=50*ones(1,n);
d=flip(a);
X=[a c d b];
Y=[b a c d];
%plot(x,y)
z=X+1i*Y;
plot(z)
axis equal
N=length(z);
Z=fft(z)/N;
t=linspace(0,N-1,N);
%fs=1/mean(diff(t));
%f=2*pi*fs*linspace(0,1,N);
raggi=abs(Z);
fasi=angle(Z);
figure
hold on
title('ft');
for i=1:N%ciclo sul tempo
    x=0;
    y=0;
    for j=1:N%ciclo sulle frequenze
        %x=x+raggi(j)*cos(f(j)*i+fasi(j));
        %y=y+raggi(j)*sin(f(j)*i+fasi(j));
        x=x+raggi(j)*cos((j-1)*i+fasi(j));
        y=y+raggi(j)*sin((j-1)*i+fasi(j));
    end
    scatter(x,y);
    %pause(0.1);
end
T=toc;
disp(T)