clear all
close all
fid = fopen("tensione.txt","r");
A = fscanf(fid,'%f',[2,inf])';
t = A(:,1); %tempo
I = A(:,2); %intensità
fclose(fid);
plot(t,I);
title("Dominio dei tempi")
xlabel("tempo (s)")
ylabel("tensione (V)")
[f,a] = spettroFrequenze(t,I);
figure
plot(f,a);
title("Dominio delle frequenze");
xlabel("frequenza (Hz)")