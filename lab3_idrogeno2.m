%qui faccio a parte il fit lorentziano dell'idrogeno non saturato
clear all 
close all
fid=fopen("idrogeno.txt","r");
A=fscanf(fid,'%f',[2,inf])';
lambda=A(:,1);%lambda in nm
I=A(:,2);%intensità relativa
fclose(fid);

a=652;
b=680;%a occhio trovo gli indici buoni per isolare la riga dominante
x=lambda(a:b)*1e-9;
y=I(a:b);
c=299792458;%vel luce SI
omega=flip(2*pi*c./x);%passo alle frequenze; devo invertire l'asse x se no è decrescente e di conseguenza pure y
y_omega=flip(y);%se no non c'è più corrispondenza di ogni punto con la sua coordinata orizzontale

plot(omega,y_omega)

f=@(p,omega) ((1/(2*pi))*p(1)/((omega-p(2)).^2+(p(1)/2)^2))';
p0=[3e13,2.89e15];%gamma e omega0. Stimo gamma con delta omega, che in realtà lo maggiora
[pfit,R,J,CovB] = nlinfit(omega,y_omega,f,p0);
gamma=pfit(1);
disp("gamma fit (Hz):")
disp(gamma)
disp("delta omega a occhio (Hz): 8.4e13")

omega0=pfit(2);
disp("omega0 fit (Hz):")
disp(omega0)

lambda0=1e9*2*pi*c/omega0;
disp("lambda0 fit (nm):")
disp(lambda0)
t=rydberg(3,2);
disp("valore teorico per la transizione 3->2 (nm):")
disp(t)
dperc=100*abs(t-lambda0)/t;
disp("discrepanza percentuale:")
disp(dperc)