function [f,a,tf]=spettroFrequenze(t,x,varargin)
%SPETTROFREQUENZE Calcola lo spettro delle frequenze di un segnale mediante
%fft; sono richiesti almeno 2 input e 2 output.
%   [f,a]=SPETTROFREQUENZE(t,x) 
%   Se t � il vettore dei tempi e x il vettore dei segnali f sar� il
%   vettore delle frequenze e a delle ampiezze, in modo che a(i) sia
%   l'ampiezza associata alla frequenza f(i) (misurata in Hz).
%   Senza ulteriori argomenti la frequenza di campionamento viene stimata
%   a partire dal vettore dei tempi come mean(diff(t)); se il vettore t ha 
%   elementi uniformemente distanziati (ad esempio � stato generato 
%   mediante linspace) allora questa stima � esatta (in caso di segnali 
%   raccolti con distanze temporali non uniformi vedi 'resample' sotto).
%
%   [...]=SPETTROFREQUENZE(t,x,fs)
%   Specifica che la frequenza di campionamento � fs; in questo modo questa
%   non va calcolata a parte.
%
%   [f,a,tf]=SPETTROFREQUENZE(...)
%   Restituisce anche il vettore tf dato dalla fft di x utilizzato nel
%   calcolo di a; questo passaggio � opzionale, e permette di "estrarre" la
%   trasformata di Fourier complessa nel caso serva ad altro. 
%   Per gestire la normalizzazione di tf vedi qui sotto.
%
%   [f,a,tf]=SPETTROFREQUENZE(...,'normalizzazioneTF','S�')
%   oppure
%   [f,a,tf]=SPETTROFREQUENZE(...,'normalizzazioneTF','No')
%   Restituisce una tf normalizzata o meno a length(x); qualora non si
%   specifichi questo parametro la risposta di default � 'S�'. La
%   trasformata utilizzata per calcolare le ampiezze corrette nel vettore a
%   � fft(x)/length(x), e questo � indipendente dal valore di questo
%   parametro - che decide semplicemente quale sar� l'output tf.
%   Il parametro da specificare � case-insensitive.
%
%   Note:
%       Attenzione ai fattori 2*pi! SPETTROFREQUENZE restituisce le
%       frequenze, non le frequenze angolari...
%
%       Per avere un risultato numericamente accurato � importante avere
%       un numero elevato di punti (ad esempio sperimentalmente con una
%       sovrapposizione di due coseni con input fra 0 e 10 100 punti
%       talvolta davano risultati scorretti dell'ordine dell'unit� per le
%       ampiezze, mentre gi� con 1000 punti tutti i risultati erano
%       buoni e spesso con discrepanze oltre la terza cifra decimale); 
%       questo fatto � distinto dal principio di sovrapposizione e riguarda
%       solo il fatto che la fft � una trasformata discreta.
%       (L'unico svantaggio dell'aumentare il numero di punti � che siccome
%       la fft viene calcolata su pi� frequenze il plot dello spettro delle
%       frequenze pu� diventare meno leggibile a meno di ritocchi).
%
%       I vettori calcolati sono f=(fs/2)*linspace(0,1,N) e
%       a=2*abs(y(1:N/2)) - dove N=length(x), y=fft(x)/N e i fattori 2 sono
%       dovuti al fatto che se il segnale � reale la fft sar� formata da coppie
%       complesso-complesso coniugato.
%
%       I picchi visibili mediante plot(f,a) nel caso di un segnale
%       armonico (somma di sinusoidi) prodotto artificialmente sono
%       sono centrati sulle frequenze rilevanti, e sono tanto pi� stretti 
%       quanto maggiore � la durata del segnale per "principio di 
%       indeterminazione"; poich� il segnale non pu� avere durata infinita
%       le frequenze centrali dei picchi non saranno mai esattamente quelle
%       utilizzate e avendo i picchi una certa area finita le loro altezze 
%       non saranno mai esattamente quelle utilizzate, ma l'approssimazione
%       dovrebbe migliorare aumentando la durata del segnale (trascurando
%       l'errore numerico).
%
%       Per ottenere informazioni quantitative � utile il comando find; ad
%       esempio si pu� scrivere find(a>1), e le componenti di f con indice
%       ottenuto da find saranno quelle con ampiezza maggiore di 1.
%       
%       L'aspetto tecnico di questa funzione (argomenti opzionali,
%       parametri, ecc.) � stato realizzato seguendo <a
%       href="matlab:web('https://it.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html')">questo
%       </a>tutorial.
%
%   See also FFT,MEAN,DIFF,ABS,FIND,RESAMPLE.

%tutti i commenti sotto questa riga vuota dopo la sezione aiuto sono
%ignorati da help; si pu� notare infatti a sinistra che matlab distingue
%la fine di quella sezione mediante un segno tipo if end
p=inputParser;%p sar� la struttura con tutte cose; analizzer� gli argomenti 
%e li restituir� "filtrati" per l'utilizzo nella funzione utilizzando parse

narginchk(2,5);%controlla che gli argomenti siano da 2 a 5; in caso
%contrario d� errore.
if length(t)~=length(x)
    error('Le lunghezze dei vettori tempo e segnale non corrispondono.');
end

%https://it.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html
rispostaDefault='S�';
risposteValideNormalizzazioneTF={'S�','No'};%risposte valide al parametro che definir� dopo
controllaRisposta = @(x) any(validatestring(x,risposteValideNormalizzazioneTF));%funzione per controllare la correttezza del parametro
%scrivo una funzione a parte come nel link di cui sopra;validatestring
%confronta x con ciascuno dei rispostevalide... restituendo la stringa
%valida (cio� la stringa x che ha almeno un parziale riscontro con ciascuna
%delle risposte, ad esempio ignora maiuscole/minuscole); se almeno una
%stringa � valida any torna il logico 1 (cio� almeno un riscontro ha
%successo); altrimenti ci sono solo gli errori restituiti da validatestring
%Funzioni a parte possono essere isnumeric o ischar

addRequired(p,'tempo',@isnumeric);%aggiungo input obbligatorio e gli dico di filtrarlo mediante isnumeric
addRequired(p,'segnale',@isnumeric);
addOptional(p,'frequenzaCampionamento',@isnumeric);%input facoltativo
addParameter(p,'normalizzazioneTF',rispostaDefault,controllaRisposta);
%aggiungo un parametro facoltativo: specificando nell'input della funzione
%'NormalizzazioneTF','S�' oppure 'NormalizzazioneTF','No' avr� un parametro
%extra; in assenza di specifica assumer� che quello giusto sia
%rispostaDefault. Filtra l'input mediante la funzione anonima definita
%sopra. cfr comandi di matlab tipo fanimator con AnimationRange

parse(p,t,x,varargin{:})%questo serve ad "estrarre" le informazioni prodotte
%da inputParser

X=p.Results.segnale;

b=size(X);
if (b(1)~=1)&&(b(2)~=1)
    error('Quello del segnale deve essere un vettore, non una matrice.');
end%fft(matrice) � la matrice delle fft delle colonne, ma siccome qui dando al tutto una matrice lavora solo con la prima colonna meglio aggiungere questa condizione!
clear b;

N=length(X);
y=fft(X)/N;%fft normalizzata di x in modo che si possano ottenere le
%ampiezze giuste per ciacuna frequenza
switch nargin
    case 2
        fs=1/mean(diff(t));%se non conosco la sampling frequency la ricavo
        %cfr https://www.mathworks.com/matlabcentral/answers/386729-how-to-find-sampling-rate-from-a-signal-vector-and-a-time-vector
        f=(fs/2)*linspace(0,1,N/2);
        a=2*abs(y(1:N/2));%ripeto due volte lo stesso comando alla faccia di Marco Russo
    otherwise %siccome gli ultimi argomenti sono irrilevati ai fini del calcolo dello spettro delle frequenze non mi serve distinguere il case 3 dagli altri
        fs=p.Results.frequenzaCampionamento;%sampling frequency specificata dall'utente
        if fs<=0
            error('La frequenza di campionamento specificata � negativa.');
        end
        f=(fs/2)*linspace(0,1,N/2);%vettore delle frequenze, distanziate l'una dall'altra met� fs=1/dt hertz 
        %(met� perch� mi serve solo mezza tf, devo scalarne opportunamente l'argomento)
        a=2*abs(y(1:N/2));%vettore delle ampiezze di ciascuna frequenza; prendo met� tf perch� se il segnale
        %� reale la tf contiene solo coppie complesso-complesso coniugato e me ne basta una. Inoltre devo 
        %moltiplicare per 2 perch� sto prendendo solo le frequenze positive in modo da ottenere l'ampiezza corretta
        %in quanto in ciascuna delle coppie complesso-complesso coniugato 
        %ogni esponenziale "si prende" met� ampiezza
end


if nargout==3
    if p.Results.normalizzazioneTF == 'No'
        tf=y*N;
    else
        tf=y;
    end
end


end
