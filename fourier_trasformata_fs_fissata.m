%il contributo a 0 hz è una funzione costante che serve solo a traslare
%verticalmente il grafico della funzione, ed è dovuta al fatto che la
%nostra funzione è sempre positiva (vedi video di 3b1b)
%tutte le frequenze che danno contributo sono intere coerentemente col
%fatto che il segnale è periodico (serie di fourier, non necessariamente
%trasformata); siccome non è una sinusoide perfetta ci sono delle piccole
%armoniche a frequenze maggiori ma il grosso è a 100 hz come ci aspettiamo.
clear 
clf
file=input("Inserire il nome del file da aprire ", "s");
%file='a.txt';
fid = fopen(file);
A = fscanf(fid,'%f',[2,inf]);
fclose(fid);
A=A';%si può mettere anche subito dopo il fscanf
t=A(:,1);
x=A(:,2);
N=length(x);
%T=input("Per favore specifica la durata complessiva del segnale in unità arbitrarie ");
%T=5;
%fs=N/T; %sampling frequency
fs=1000;%quella a cui abbiamo campionato i dati con datastudio
%dt=1/fs;
disp("Ecco il grafico della funzione.")
plot(t,x)
xlabel("t")
ylabel("f")
title("Funzione");
y=fft(x)/N; %sarà un vettore complesso! Bisogna dividere per N perché la formula usata da matlab non lo fa di default

risposta = questdlg('Vuoi mostrare anche i valori assoluti delle frequenze negative?', ...
	'Simmetria della trasformata', ...
	'Sì','No','Stacca stacca','Stacca stacca');
% Handle response
switch risposta
    case 'Sì'
        fprintf([risposta '\nArriva la trasformata simmetrica!\n'])
        freqv = (fs)*linspace(0,1,N);
        figure;
        plot(freqv,2*abs(y(1:N))) %con N si ottiene la trasformata simmetrica - con i doppioni! Questa
        %informazione extra è dovuta al fatto che il modulo scarta informazione,
        %forse.
        z=2*abs(y(1:N));
        xlabel("freq Hz")
        ylabel("Ampiezza")
        title("Trasformata di Fourier");
    case 'No'
        fprintf([risposta '\nArriva la trasformata non simmetrica!\n'])
        freqv = (fs/2)*linspace(0,1,N/2); %genero il vettore delle frequenze. Penso ci serva solo met� y perch� � simmetrica
        figure;
        plot(freqv,2*abs(y(1:N/2))) %prendiamo solo metà y perch� � simmetrica: ad ogni omega corrisponde un -omega
        z=2*abs(y(1:N/2));
        xlabel("freq Hz")
        ylabel("Ampiezza")
        title("Trasformata di Fourier");
    case 'Stacca stacca'
        fprintf('\nCi stanno tracciando!\n')
end
%if(risposta=="Sì")%oppure con || che è or
%    [picchi,frequenze]=findpeaks(abs(y(1:N)),freqv);
%    disp("Le frequenze dominanti (Hz) sono: ")
%    disp(frequenze);
%    disp("Le frequenze angolari (Hz) sono: ")
%    omega=2*pi*frequenze;
%    disp(omega);
%    disp("Le ampiezze di queste frequenze sono:")
%    picchi=picchi';
%    disp(picchi);
%elseif(risposta=="No")
%    [picchi,frequenze]=findpeaks(2*abs(y(1:N/2)),freqv);
%    disp("Le frequenze dominanti (Hz) sono: ")
%    disp(frequenze);
%    disp("Le frequenze angolari (Hz) sono: ")
%    omega=2*pi*frequenze;
%    disp(omega);
%    disp("Le ampiezze di queste frequenze sono:")
%    picchi=picchi';
%    disp(picchi);
%end
disp("il vettore z contiene il modulo della trasformata in caso volessi fare analisi con find eccetera");