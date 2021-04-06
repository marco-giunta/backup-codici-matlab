clear all
close all
fid=fopen("incandescenza.txt","r");
A=fscanf(fid,'%f',[2,inf])';
lambda=A(:,1);%lambda in nm
I=A(:,2);%intensità relativa
fclose(fid);
plot(lambda,I)

c=299792458;%vel luce SI
ni=flip(c./(lambda*1e-9));
%y_ni=flip(I);%lavoro con le frequenze
y_ni=c*flip(I)./(ni.^2);%jacobiano trasformazione?
%devo invertire l'asse x se no è decrescente e di conseguenza pure y
%se no non c'è più corrispondenza di ogni punto con la sua coordinata orizzontale
h=6.626e-34;%cost planck SI
k=1.38e-23;%cost boltzmann SI
T=3000;

%p=[h c k T]
f=@(p,ni) (2*p(1).*ni.^3./((p(2)^2).*(exp(p(1)*ni./(p(3)*p(4)))-1)));
%p0=[6e-34,3e8,1e-23,1e3];
p0=[h,c,k,T];
[pfit,R,J,CovB] = nlinfit(ni,y_ni,f,p0);
hfit=pfit(1);
cfit=pfit(2);
kfit=pfit(3);
Tfit=pfit(4);
disp("h fit:")
disp(hfit)
disp("c fit:")
disp(cfit)
disp("k fit:")
disp(kfit)
disp("T fit:")
disp(Tfit)

figure
plot(ni,y_ni)
hold on
plot(ni,f(pfit,ni))
plot(ni,f(p0,ni))
%legend("Dati","planckiana da fit","planckiana esatta")
xlabel("$\nu$ (Hz)","interpreter","latex")

%riprovo fittando solo la temperatura e usando i valori esatti di h,c,k
F=@(P,ni) (P(2)*(2*h).*ni.^3./((c^2).*(exp(h*ni./(k*P(1)))-1)));
[pfit2,R2,J2,CovB2] = nlinfit(ni,y_ni,F,[2700,2e-3]);
Tfit2=pfit2(1);
Afit2=pfit2(2);
disp("T2 fit:")
disp(Tfit2)
disp("A fit:")
disp(Afit2)
figure
plot(ni,y_ni)
hold on
plot(ni,F(pfit2,ni))

%da fare perlopiù per visualizzare l'effetto della trasformazione jacobiana
figure
plot(ni,y_ni)
title("intensità trasformata")
xlabel("$\nu$ (Hz)","interpreter","latex")
ylabel("I aggiustata")