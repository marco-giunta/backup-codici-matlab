clear all 
close all
fid=fopen("deuterio.txt","r");
A=fscanf(fid,'%f',[2,inf])';
lambda=A(:,1);%lambda in nm
I=A(:,2);%intensità relativa
fclose(fid);
fid=fopen("deuterio_saturato.txt","r");
A=fscanf(fid,'%f',[2,inf])';
%lambda=A(:,1);%lambda in nm
I_s=A(:,2);%intensità relativa
fclose(fid);

plot(lambda,I)
%findpeaks(I)%metterlo sballa l'asse x nella rappresentazione
grid on
title("deuterio")
xlabel("$\lambda$ (nm)","interpreter","latex")
ylabel("I relativa (%)")

figure
plot(lambda,I_s)
%findpeaks(I_s)
grid on
xlabel("$\lambda$ (nm)","interpreter","latex")
ylabel("I relativa (%)")
title("deuterio saturato")