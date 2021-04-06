clear
%clf
close all
figure
registrazione=audiorecorder;%https://it.mathworks.com/help/matlab/import_export/record-and-play-audio.html
dt=5;%delta t
fprintf('Registro per %s secondi\n',num2str(dt));
recordblocking(registrazione,dt);
disp('Riproduco la registrazione');
play(registrazione);
x=getaudiodata(registrazione);
disp('Grafico lo spettro della registrazione nel dominio dei tempi e delle frequenze');
t=linspace(0,dt,(8000*dt));%matlab registra con frequenza di campionamento di 8000 Hz, 
%cioè campiona il suono 8000 volte al secondo (per vederlo digita il nome 
%dell'oggetto audiorecorder nel terminale); pertanto genero un vettore dei
%tempi che vada da 0 a delta_t e che contenga 8000 elementi per ogni
%secondo trascorso, cioè 8000*dt
plot(t,x);
title('Dominio dei tempi');
xlabel('t (s)');%riprodurre l'audio sullo stesso computer rovina i dati, infatti il plot viene sballato; registrando "esternamente" comandi tipo i seguenti sono inutili
%le frequenze ottenute sono giuste ma riproducendo la registrazione il
%risultato è scarso e il plot di x viene sicuramente inappropriato
%axis([0 dt -inf inf]);%https://it.mathworks.com/help/matlab/ref/axis.html
%set(gca,'xLim',[0 dt]);%vedi https://www.mathworks.com/matlabcentral/answers/404647-how-to-modify-the-axes-scale-when-we-plot-values-in-both-y-axis-with-same-x-axis-line ad esempio
[f,a]=spettroFrequenze(t,x);
figure;
plot(f,a);
title('Dominio delle frequenze');
xlabel('f (Hz)');
%ricorda: il range delle frequenze udibili dall'uomo è da 20 a 20000 Hz
%stando a wikipedia, quindi il grosso delle frequenze deve stare lì!
%[picchi,indici]=findpeaks(a);
%N=length(picchi);
%for i=1:N
%    fprintf('\nTrovato il picco %s',num2str(picchi(i)));
%    fprintf(' alla frequenza %s\n',num2str(f(indici(i))));
%end
[m,ind]=max(a);
fprintf('\nLa frequenza del picco massimo è %s\n',num2str(f(ind)));
