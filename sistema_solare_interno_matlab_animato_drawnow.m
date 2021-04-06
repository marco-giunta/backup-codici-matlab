%Solita pulizia.
clear all
close all
N=input('Quanti punti? '); %1000 vanno bene per evidenziare la precessione 
%notevole di Mercurio 

%N=1000;

%octave only
%per misurare il tempo di esecuzione utilizziamo la funzione yes_or_no, che 
%accetta come argomento l'input da finestra di comando e restituisce 1 se 
%l'utente dice di sì, 0 altrimenti. Salviamo questo valore in una variabile

%t=yes_or_no('Vuoi misurare il tempo di esecuzione del programma? ');
t=1;

%da provare
%t=questdlg('Vuoi misurare il tempo di esecuzione del programma? ');


%se l'utente ha scelto di misurare il tempo facciamo partire il cronometro 
%mediante la funzione tic. Per stabilire se fare partire o meno il cronometro
%usiamo un if e confrontiamo t con 1. Alla fine del codice useremo la funzione
%toc per fermare il cronometro con lo stesso if.
if t==1
  tic()
end
dt=0.01; %in caso si può specificare da input
n_p=4; %numero di pianeti
%Fissiamo le costanti e le masse. m(1) mercurio, m(2) venere, m(3) terra, 
%m(4) marte
G=6.67e-11;
m=[3.30e+23 4.87e+24 5.97e+24 6.42e+23];
m_s=1.99e+30; %massa del sole
%per rendere i numeri coinvolti nei calcoli più maneggevoli è opportuno 
%esprimere tempi in anni e spazi in unità astronomiche; a tal scopo introduciamo
%il fattore correttivo c per portare metri in UA e secondi in anni. Le masse 
%in chilogrammi vanno bene perché compensano la piccolezza di G in queste unità!
c=((86400*365.25)^2)/((1.496e+11)^3);%c=1 anno^2/1 UA^3
%ciclo for per i prodotti GM
for i=1:n_p
  GM(i)=G*m(i)*c;
end
GS=G*m_s*c;
%CONDIZIONI INIZIALI, PARTE 1:
%Il sole è ovviamente posto nell'origine degli assi cartesiani e supposto fermo!
%fissiamo le matrici della posizione orizzontale e verticale dei pianeti: per 
%rendere generale il programma è bene non avere matrici dedicate per ogni 
%pianeta ma averne una unica le cui righe e colonne sono variabili.
%Ogni riga della matrice è l'insieme delle posizioni di ogni pianeta, e ogni 
%colonna è l'insieme dei dati di ogni pianeta.
x=zeros(N, n_p); %colonne=pianeti
y=zeros(N, n_p); %righe=valori calcolati
%supponiamo inizialmente tutti i pianeti in punti di massima/minima distanza dal
%sole e che abbiano la stessa linea degli apsidi.
x(1, 1)=-0.459; %mercurio, afelio, x negativo=sinistra
x(1, 2)=0.718; %venere, perielio, x positivo=destra
x(1, 3)=-1.016; %terra, afelio, x negativo=sinistra
x(1, 4)=1.38; %marte, perielio, x positivo=destra

%le y sono già zero.

%CONDIZIONI INIZIALI, PARTE 2:
%siccome l'equazione differenziale è di secondo ordine servono due condizioni 
%iniziali per pianeta; usando solo il metodo di Verlet servirebbero i primi due 
%valori della posizione, ma la seconda posizione è "variabile" nel senso che 
%dipende da dt... è preferibile non fissarla a priori ma calcolarla in funzione 
%di dt evitando Verlet perché non si può usare! La soluzione migliore, quindi, 
%è probabilmente questa: è meglio procurarsi dei valori di velocità iniziali 
%fissi, usarli per calcolare le seconde posizioni con Eulero e poi far partire 
%Verlet. Si tratta di un metodo misto, insomma... 

%per calcolare la velocità in un punto qualunque di un'orbita ellittica si può 
%usare la vis viva equation, che si può ricavare dalla conservazione di E, di L
%e da un po' di geometria (vedi Wikipedia) o più rapidamente dal vettore di 
%Laplace-Runge-Lenz

%In questo modo le due condizioni iniziali per pianeta sono la posizione e il 
%semiasse maggiore; servono dunque i semiassi maggiori 
%(abbiamo già le distanze iniziali)
a=[0.387 0.723 1 1.52];%stesso ordine: mercurio, venere, terra, marte

for i=1:n_p %Eulero per il calcolo delle seconde posizioni per ogni pianeta.
  r=sqrt(x(1, i)^2+y(1, i)^2);%Pitagora per trovare la distanza sole-pianeta
  v=sqrt(GS*((2/r)-(1/a(i))));%vis viva equation
  %ogni pianeta parte da un punto di distanza 
  %massima/minima, dunque la velocità radiale è zero. Viste le condizioni 
  %iniziali, all'istante iniziale la velocità radiale coincide con vx
  %e quella tangenziale con vy
  y(2, i)=y(1, i)+dt*v;%per quanto sopra vy=v
  x(2, i)=x(1, i);%per quanto sopra vx=0
end

%h = animatedline;
hold on
axis equal
axis([-2 2 -2 2])%se no parte zoomato e poi si espande nella visuale

%pause(2)%per avere tempo di ingrandire la finestra dovendo registrare con
%obs o con print vari

%Adesso è possibile far partire Verlet.
%ogni iterazione del ciclo esterno (ciclo i) genera un nuovo valore della 
%posizione x e y di ogni pianeta.
for i=2:N %N punti nei vettori posizione
  %in ogni iterazione del ciclo esterno calcoliamo un nuovo valore della 
  %posizione di ogni pianeta prima di ripetere il ciclo i
  for j=1:n_p %ci sono n_p pianeti; calcoliamo l'accelerazione del pianeta j!
    %Per farlo innanzitutto troviamo il contributo del sole.
    r_s=sqrt(x(i, j)^2+y(i, j)^2);%distanza sole-pianeta j
    ax=-(GS/r_s^3)*x(i, j);%modulo dell'accelerazione di gravità lungo x 
    ay=-(GS/r_s^3)*y(i, j);%idem lungo y
    %Adesso bisogna calcolare l'attrazione su j degli altri pianeti. Per farlo
    %calcoliamo l'accelerazione di ognuno dei n_p-1 pianeti rimanenti avendo 
    %l'accortezza di non sommare su tutti gli indici: j non attrae se stesso!
    %Per escludere j usiamo un altro ciclo che includa anche un if!
    for k=1:n_p %sommiamo i contributi dovuto agli altri pianeti.
      if k~=j %il ciclo non calcola niente se k=j. Seguono le stesse equazioni 
        %di prima, solo generalizzate.
        r=sqrt((x(i, k)-x(i, j))^2+(y(i, k)-y(i, j))^2);
        %MODIFICATO PER MATLAB
        ax=ax-(GM(k)/r^3)*(x(i, j)-x(i, k));
        ay=ay-(GM(k)/r^3)*(y(i, j)-y(i, k));
      end
    end
    x(i+1, j)=2*x(i, j)-x(i-1, j)+ax*dt^2;
    y(i+1, j)=2*y(i, j)-y(i-1, j)+ay*dt^2;
  end
  %addpoints(h,x(i+1,:),y(i+1,:));
  %drawnow limitrate
  %drawnow
  %plot(x(i+1,:),y(i+1,:),'.');
  cla
  plot(x([1:i+1],:),y([1:i+1],:));%meglio senza il punto in modo da uniformare con il plot "finito" sotto, che a questo punto toglierei...
  scatter(x(i+1,:),y(i+1,:));%con drawnow limitrate va velocissimo, senza è più accettabile ma a volte scatta
  plot(0,0, 'r*')%il sole nell'origine!
  %pause(0.0001);%pause dà i risultati più soddisfacenti!
  drawnow
end
%drawnow


figure
hold on %sovrapponiamo i grafici
axis equal%con questo comando si impone che gli assi abbiano le stesse unità di misura

for i=1:n_p %tracciamo i grafici di tutti i pianeti. Stavolta i indica l'i-esimo
  %pianeta, dunque il ciclo for fa "scorrere" la colonna da graficare.
  plot(x(:,i), y(:,i));% ":" significa "tutta la colonna" - letteralmente
  %significa "tutte le righe corrispondenti alla colonna i"
end
plot(0,0, 'r*')%il sole nell'origine!
legend('Mercurio', 'Venere', 'Terra', 'Marte', 'Sole', 'Location', 'northwest');
%con lo stesso confronto fra t e 1 mediante if stabiliamo se l'utente ha
%selezionato o meno di misurare il tempo; in caso affermativo, mediante disp
%stampiamo il tempo passato.
if t==1
  tempo=toc();
  disp("L'esecuzione del codice ha richiesto il seguente tempo (s): "), disp(tempo)
end