%rispetto a quello iniziale faccio due modifiche:
% - vettorizzo il for interno (l'operazione che sto facendo altro non è che
% una somma cumulativa opportunamente salvata)
% - rimuovo il finto append relativamente a wave, cioè la matrice con le
% coordinate del punto finale al variare del tempo (tanto questa matrice
% avrà tante righe i.e. coppie (x,y) quante sono le iterazioni del ciclo
% for sul tempo)

clear
close all
% Lettura file e conversione da R2 a C + plot in C del ritratto
fidx = fopen('x.txt','r');
fidy = fopen('y.txt','r');
x = fscanf(fidx,'%f',[1,inf])';
y = fscanf(fidy,'%f',[1,inf])';
fclose(fidx);
fclose(fidy);
z = complex(x,y);%equivalente a x+1i*y
plot(z)
title('Figura da riprodurre mediante FFT');
axis equal

% Calcolo FFT 
N = length(z);%è il numero di punti che compongono la figura ma anche di 
% armoniche e quindi cerchi a nostra disposizione (la FFT è una DFT)
Z = fft(z)/N;%trasformata normalizzata visto che fft non lo fa di default
raggi = abs(Z);%i moduli dei numeri complessi in Z rappresentano i raggi dei cerchi
fasi = angle(Z);%le fasi, invece, gli sfasamenti
freq = 0:N-1;%abbiamo N frequenze che vanno da 0 a N-1 
[raggi,indici] = sort(raggi,'descend');%nella figura i cerchi più piccoli e veloci sono gli ultimi
Z = Z(indici);%il secondo argomento di sort restituisce il vettore con cui effettuare l'indexing per ordinare anche gli altri
fasi = fasi(indici);
freq = freq(indici)'; %siccome sotto vettorizzo e in MATLAB gli array hanno sempre almeno 2 indici 
% i.e. tutti gli array sono sempre o riga o colonna anziché genericamente
% 1D mi conviene trasporre fin dall'inizio in modo che tutti i vettori qui
% sopra siano vettori colonna

h = figure;
handle = axes('Parent',h);
hold on
axis equal
n = 1;%numero di ripetizioni della figura
wave = zeros(N*n+1,2);%N*n+1 righe perché t va da 0 a N*n mappato in [0,2*pi*n],
% e il +1 corrisponde dunque allo 0 che deve essere incluso per avere i
% cos(0+fase) eccetera; 2 colonne perché sono [x,y]. Nota: questo è stato
% dedotto misurando la lunghezza del vettore 0:(2*pi/N):2*pi*n presente nel
% ciclo for; non sono sicuro a posteriori su come mai si usi questo vettore
% , ma probabilmente è una cosa presa dal tipo e basta senza troppe domande
% NOTA: evidentemente posso fare un append non vietato come descritto sotto
% (cosa appena scoperta), ma comunque penso sia meglio preallocare la
% memoria visto che so di cosa ho bisogno

axis([500 1400 -1100 0])%per non dover fare zoom
%j=1;%decommentare questo + alla fine per salvare
idx = 0; %non posso usare direttamente t per fare l'indexing di wave in quanto t parte da 0 e in ogni caso non è intero
% e ovviamente castare t a int non ha senso, si perde di significato

for t=0:(2*pi/N):2*pi*n
      idx = idx + 1;
%     il codice originale
%     x=0;
%     y=0;
%     for i=1:N
%         prevx=x;
%         prevy=y;
%         x=x+raggi(i)*cos(freq(i)*t+fasi(i));
%         y=y+raggi(i)*sin(freq(i)*t+fasi(i));
%         centri(i,:) = [prevx, prevy];%nota: in matlab posso definire così un array e assegnare subito nuove righe senza che questo dia out of bounds; evidentemente è simile ad append
%         segmenti(i,:) = [prevx, x, prevy, y];
%     end
%     wave = [wave; [x,y]];
    
    %parte nuova
    vx = cumsum([0;raggi.*cos(freq*t+fasi)]); %N+1 elementi perché sto aggiungendo lo 0
    vy = cumsum([0;raggi.*sin(freq*t+fasi)]); %questi due saranno vettori colonna perché lo sono tutti
    centri = [vx(1:end-1),vy(1:end-1)]; %così affianco direttamente due colonne
    segmenti = [vx(1:end-1),vx(2:end),vy(1:end-1),vy(2:end)];
    wave(idx,:) = [vx(end),vy(end)];
    
    %altre cose che c'erano già
    cla
    viscircles(handle, centri, raggi, 'Color', 0.5 * [1, 1, 1], 'LineWidth', 0.1);
    plot(handle, wave(:,1), wave(:,2), 'k', 'LineWidth', 2);
    plot(handle, segmenti(:,1:2), segmenti(:,3:4), 'Color', 0.1*[1 1 1], 'LineWidth', 0.1);
%     plot(handle, x, y, 'or', 'MarkerFaceColor', 'r'); %cosa del codice
%     originale
    plot(handle, vx(end), vy(end), 'or', 'MarkerFaceColor', 'r');
    %pause(0.025);
    %pause(0.05);
    drawnow limitrate
    
    %set(gcf, 'PaperPositionMode', 'auto')%da decommentare per salvare
    %print(gcf, ['fourier_ritratto' '_' num2str(j) '.png'], '-dpng', '-r150')
    %j=j+1;
   
end
drawnow