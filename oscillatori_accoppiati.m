clear%https://it.mathworks.com/matlabcentral/answers/398099-use-ode45-to-solve-a-system-of-two-coupled-second-order-odes di vitale importanza, ma comprensibile solo dopo aver studiato il pacchetto symbolic!
clf
%======PARAMETRI UNIVERSALI SU MODI NORMALI E REGISTRAZIONE VIDEO=========
modo_normale=3;%metti 1 per il pendulum mode, 2 per il breathing mode, 3 per i battimenti (vedi Morin)
animazione=0;%metti 0 per non riprodurre l'animazione, 1 per riprodurla
registra=0;%metti 1 per registrare, altri numeri per non farlo
%=========================================================================
syms x1(t) x2(t) k1 k k2 m1 m2 %dichiaro le variabili/funzioni simboliche
eq1=diff(x1,2)==-(k1/m1)*x1-(k/m1)*(x1-x2);%la prima equazione del moto
eq2=diff(x2,2)==-(k2/m2)*x2-(k/m2)*(x2-x1);%la seconda%x1 e x2 sono gli spostamenti di ciascuna massa dalla propria posizione a riposo - vedi Smith 140
equazioni=[eq1 eq2];%metto insieme le equazioni per poterle mettere in un colpo solo in odevectorfield
[V,S]=odeToVectorField(equazioni);%questo comando riduce ad un sistema del primo ordine; il vettore S conterrà le variabili sostituite (x1,Dx1,x2,Dx2) mentre V le trasformazioni (ad esempio Dx1 sarà uguale a una delle due equazioni del moto)
f=matlabFunction(V, 'vars', {'t','Y','k','k1','k2','m1','m2'});%V mediante questo comando viene convertito da funzione simbolica a funzione numerica (come se l'avessi scritta con funzioni numeriche, function handles con @, ecc.) in una forma che possa capire ode45 (già tutto al primo ordine grazie al comando precedente). Per qualche motivo se non metto 'Y' dà errore: Free variable 'Y' must be included in 'Vars' value. Penso sia legato al fatto che una o più delle "variabili libere" della funzione simbolica in input deve diventare variabile libera di quella numerica in output
k1=1;%devo specificare le variabili della funzione: ciò implica sia t e Y che saranno le due rilevanti nell'integrazione sia tutte le costanti che spuntano nelle espressioni sopra
k2=1;%V sono le equazioni con le variabili sostituite: non figurano x1.. ma le componenti del vettore Y, la cui struttura è riprodotta da S!
k=1;%vale a dire: il mio sistema del secondo ordine diventa un'equazione vettoriale del primo della forma S'=V!!
m1=5;
m2=5;%nelle C.I. FIDATI DI S!! Le C.I. vanno specificate nello stesso ordine di S; in questo modo effettivamente spunta fuori il modo normale b
tspan=[0,10];
if modo_normale==1
    cond_in=[1,0,1,0];%così per il pendulum normal mode; queste posizioni sono riferite alla posizione di equilibrio
end
if modo_normale==2
    cond_in=[1,0,-1,0];%così per il breathing normal mode %x2, Dx2, x1, Dx1 nell'ordine
end
if modo_normale==3
    cond_in=[1,0,0,0];
    m1=7;
    m2=7;
    k1=15;
    k2=15;
    k=0.5;%per avere battimenti deve essere k<<k1=k2
    tspan=[0,20];
end
%devo specificare che voglio una funzione di t e Y ricavata da f con tutti i parametri assegnati
%[t,Y]=ode45(@(t,Y) f(t,Y,k,k1,k2,m1,m2),tspan,cond_in);%prima le vere variabili e poi le costanti che comunque bisogna dare a f
%plot(t,Y(:,3));
%hold on;
%plot(t,Y(:,1));
%legend('x1','x2');
%xlabel('t');
%ylabel('x');
%figure;%riga seguente: do ad f i valori numerici appena assegnati alle
%corrispondenti variabili simboliche
Z=ode45(@(t,Y) f(t,Y,k,k1,k2,m1,m2),tspan,cond_in);%così ode45 mi dà la soluzione strutturata che mi serve per deval, con [t,y]=ode45 ottengo proprio la matrice non strutturata buona per fare un plot molto elementare

%===============================ANIMAZIONE=================================
if animazione==1
    %forse + e - sym(1) sono scambiati
    x_1 = @(t) deval(Z,t,4)-sym(1);%deval valuta la soluzione calcolata di una eq diff in un dato punto; adesso prendo x_1 e x_2 funzioni NUMERICHE di t (infatti ci metto il function handle)
    x_2 = @(t) deval(Z,t,2)+sym(1);%Y è la soluzione strutturata che esce da ode45 così come richiesto da deval, t è il punto a cui voglio valutare Y, 2 è la colonna di Y - che è l'equivalente di una matrice a 4 colonne(non proprio perché è strutturata, come si vede confrontando le Y che escono dai due modi di usare ode45), la quarta (come si vede da S) è x1
    y_1 = @(t) 0;%strutturata=struttura dati e non semplice matrice
    y_2 = @(t) 0;%metto banalmente y=0 perché il moto è 1D
    %x1 = @(t) x1+sym(1);%x1 e x2 sono le coordinate di ciascuna massa rispetto alla propria posizione a riposo; pertanto per graficare le masse utilizzando coordinate cartesiane "assolute" impongo che m1 a riposo non si trovi in x1=0 ma in x1=1 (idem m2 con -1); aggiungere una costante a una funzione oscillante non fa altro che traslarla senza modificarne la forma
    %x2 = @(t) x2-sym(1);%serve sym per rendere il numero 1 (double o quello che è) la variabile simbolica 1
    fanimator(@(t) plot(x_1(t),y_1(t),'ro','MarkerSize',10,'MarkerFaceColor','r'),'AnimationRange',tspan);
    axis equal;%m1*10 dopo markersize
    hold on;
    fanimator(@(t) plot([0 x_1(t)],[0 y_1(t)],'r-'));%m2*10 dopo markersize
    fanimator(@(t) plot(x_2(t),y_2(t),'go','MarkerSize',10,'MarkerFaceColor','g'),'AnimationRange',tspan);
    fanimator(@(t) plot([x_1(t) x_2(t)],[y_1(t) y_2(t)],'b-'),'AnimationRange',tspan);
    fanimator(@(t) text(-0.5,0.3,"Tempo trascorso: "+num2str(t,2)),'AnimationRange',tspan);

    %xa = -2; ya = 0; xb = 1; yb = 0; ne = 10; a = 1; ro = 0.1;%queste
    %funzioni sono fatte per usare variabili numeriche, non simboliche...
    %ovviamente dà errore!
    %[xs,ys] = spring(xa,ya,xb,yb,ne,a,ro);
    %fanimator(@(t) plot(xs,ys,'LineWidth',2));

    if modo_normale==1
        title('Modo normale p');
    end
    if modo_normale==2
        title('Modo normale b');
    end
    if modo_normale==3
        title('Battimenti');
    end

    hold off;
    playAnimation;
    if ((registra==1)&&(modo_normale==1))
        writeAnimation('p-mode.avi');
    end
    if ((registra==1)&&(modo_normale==2))
        writeAnimation('b-mode.avi');
    end
    if ((registra==1)&&(modo_normale==3))
        writeAnimation('battimenti.avi');
    end
end
%========================FINE ANIMAZIONE===================================

%========================PLOT COORDINATE RELATIVE==========================
figure;
hold on;
%X=linspace(0,10);
X=linspace(tspan(1),tspan(2));
g=deval(Z,X);
for i=1:4 
    %plot(Y.x,Y.y(i,:));
    plot(X,g(i,:));
end
%NOTA: osservando i grafici prodotti mediante g=deval si nota che
%evidentemente la struttura delle soluzioni prodotta da ode45 riproduce
%l'ordine iniziale delle variabili così come contenute in S!!
legend('x_2','dx_2/dt','x_1','dx_1/dt');
if modo_normale==1
    title('Modo normale p');
end
if modo_normale==2
    title('Modo normale b');
end
if modo_normale==3
    title('Battimenti');
end
%==========================================================================

%========================PLOT COORDINATE ASSOLUTE==========================
figure;
hold on;
x0=[1 0 -1 0];%quantità costanti di cui traslare le funzioni riferite alla posizione di equilibrio; evidentemente traslando le x di una costante le derivate non cambiano, quindi aggiungo 0 lì.
%x0=zeros(4);
%x0(1)=cond_in(1); le x0 non c'entrano con le condizioni iniziali, servono
%a rendere assolute le coordinate relative!
%x0(3)=cond_in(3);
for i=1:4 
    plot(X,g(i,:)+x0(i));
end
legend('x_2+x^0_2','dx_2/dt','x_1+x^0_1','dx_1/dt');
if modo_normale==1
    title('Modo normale p');
end     
if modo_normale==2
    title('Modo normale b');
end
if modo_normale==3
    title('Battimenti');
end