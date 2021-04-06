clear
clf
t=linspace(0,10,1000);%con 100 punti il risultato non è granché, già con 
%1000 è alquanto accurato nel riprodurre ampiezze (che sembrano essere le
%più difficili da azzeccare con pochi punti) e frequenze
x=2.*cos(2*pi*2.*t)+3.*cos(2*pi*3.*t)+4.*cos(2*pi*4.*t);
%x=2.*cos(2*pi*2.*t).*exp(-t);
plot(t,x);
title('Dominio del tempo');
xlabel('t (s)');
ylabel('x');
figure
[f,a]=spettroFrequenze(t,x);
plot(f,a);
title('Dominio delle frequenze');
xlabel('f (Hz)');
ylabel('a');
[picchi,indici]=findpeaks(a);
disp('Picchi di ampiezze:');
for i=1:length(picchi)
    disp(picchi(i));
end
disp('alle frequenze:');
for i=1:length(picchi)
    disp(f(indici(i)));
end