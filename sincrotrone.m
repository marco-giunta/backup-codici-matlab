%% Cerchio
clear
close all
gamma = 1.2;
c = 299792458;
beta = sqrt(1 - 1/gamma^2);
v = beta*c;

r = 1e-3;%valore scelto dal tipo per qualche motivo

omega = v/r;
T = 2*pi/omega;
t = linspace(0,2*T, 200);%scelto dal tipo: 3*T, 300
x = r*cos(omega*t);
y = r*sin(omega*t);
vx = -omega*y;%inutile ricalcolare il seno ecc.
vy = omega*x;
ax = -omega*vy;%se non parte con v=0 e a=0 non ottengo la bolla! voglio passare da un contesto statico a uno dinamico
ay = omega*vx;

% dt=(t(end)-t(1))/length(t);
% vx=[0,diff(x)/dt];
% vy=[0,diff(y)/dt];
% ax=[0,diff(vx)/dt];
% ay=[0,diff(vy)/dt];
vx(end)=0;%forse facoltativo
vy(end)=0;
ax(end)=0;
vy(end)=0;
vx(1)=0;%necessario
vy(1)=0;
ax(1)=0;
vy(1)=0;

%graficaRadiazione(x,y,vx,vy,ax,ay,t,5*r,0,'cerchio',10,35)%faccio fuori la
%saveflag, inutile controllare lo stesso if centinaia di volte, appesantisce
%il ciclo e basta
graficaRadiazione(x,y,vx,vy,ax,ay,t,5*r,'cerchio',10,35)

%% Dipolo

clear
close all
c = 299792458; 

gamma = 10;%valori del tipo
r = 1e-3;
omega = (c/r)*sqrt(1 - 1/gamma^2);
T = 2*pi/omega;
t = linspace(0,20*T, 200);
y = r*sin(omega*t);
x = zeros(size(t));%perché se no devi scrivere esplicitamente 1,length(t)
vx = x;
ax = x;
vy = omega*r*cos(omega*t);
ay = -(omega^2)*y;
vx(end)=0;%forse facoltativo
vy(end)=0;
ax(end)=0;
vy(end)=0;
vx(1)=0;%necessario
vy(1)=0;
ax(1)=0;
vy(1)=0;

rad = 50*r;%boh
%saveFlag = 0;
%graficaRadiazione(x,y,vx,vy,ax,ay,t,rad,saveFlag,'dipolo',10,30)
graficaRadiazione(x,y,vx,vy,ax,ay,t,rad,'dipolo',10,30)

%% funzione

%penso si possa semplificare il codice del tipo in quanto non penso sia
%indispensabile avere una funzione get... così generale: mi basta
%specificare prima velocità e accelerazione così non le devo calcolare
%ogni volta nella funzione. Inoltre il min(abs(.)) serve veramente solo per
%il tempo ritardato, per l'altro si può sicuramente evitare risparmiando
%risorse (credo)
function graficaRadiazione(x,y,vx,vy,ax,ay,t,lato_m,nomeFile,clo,chi)
    c = 299792458; 
    %clo = 10;
    %chi = 35;%low and high
    %penso si possa fare a meno di vettori tret e tobs visto che comunque t
    %rappresenta il vettore di tutti i possibili valori di tempo che ci
    %interessano (credo), quindi di volta in volta il punto è decidere
    %quali componenti di t siano il tret e il tobs correnti
    Nq = 200;%numero di quadrati in cui suddividere la nostra regione
    xq = linspace(-lato_m, lato_m, Nq);%lato_m=lato_mezzi
    %yq = linspace(-lato_m, lato_m, Nq);%vettori con le coordinate dei quadratini
    yq = xq;%tanto vale...
    %non penso servano grids!
    
    for n=1:length(t) %come variabile di ciclo meglio distinguere quella sul tempo da quelle sulla posizione
        toss=t(n);
        %toss è il tempo attuale per l'osservatore, trit il tempo passato
        %al quale è stata emessa la radiazione arrivata al tempo toss; mi
        %pare ovvio che ci interessano le posizioni della particella
        %valutate a questi due istanti. Siccome stiamo usando solo
        %l'orologio degli osservatori (sono solidali fra loro, direi) è
        %chiaro che la posizione attuale sia r(toss), cioè x(n) e y(n)
        %essendo che toss è l'elemento di t di posto n. Non penso serva la
        %stessa formula che invece andrà usata per il trit in quanto
        %min(abs(t-toss)) ovviamente restituisce come indice proprio n,
        %visto che nello slot n t(n) e toss sono uguali per definizione e
        %quindi solo lì il vettore differenza si annulla (credo)
        
        xa=x(n); %xa=x attuale della particella (cioè al tempo toss)
        ya=y(n); %dovrebbero bastare le posizioni (servono sicuramente per 
        %il plot; velocità e accelerazione servono solo nel calcolo, ma lì
        %mi servono quelle al tempo ritardato anziché attuale)
        
        
        %adesso devo ciclare sulle posizioni dei vari osservatori; associo
        %i alla x e j alla y. Arbitrariamente fisso una x e mi scorro tutte
        %le y-->costruisco colonna per colonna la matrice delle componenti
        %dei campi all'istante toss
        
        for i=1:Nq
            for j=1:Nq
                xoss=xq(i);
                yoss=yq(j);
                %adesso per trovare il tempo trit devo valutare
                %separatamente entrambi i membri dell'equazione implicita e
                %trovare l'indice al quale si eguagliano
                %approssimativamente; per farlo ho dunque bisogno di
                %considerare tutte le possibili distanze fra l'osservatore
                %attuale e tutti i punti che occupa la particella nel corso
                %della sua traiettoria. Chiaramente questa strategia
                %funziona perché supponiamo nota in anticipo la traiettoria
                %della particella e che tale traiettoria sia "non libera",
                %cioè che possiamo ignorare rinculi vari. Praticamente
                %stiamo supponendo di avere messo su dei binari la nostra
                %particella
                
                R = sqrt((xoss - x).^2 + (yoss - y).^2);
                [~, ind] = min(abs(t + R/c - toss));%toss=tempo corrente per l'osservatore 
%                 %trit = t(ind);%probabilmente questo serve solo a fare il
%                 %tgrid come fa lui, provo a farne a meno
%                 %calcolare esplicitamente il trit penso non serva perché 
%                 %nel concreto teniamo traccia del tempo mediante gli indici
%                 %in modo da individuare le opportune componenti dei
%                 %vettori, non stiamo certo valutando delle funzioni

                %invece la formula cambia...
                trit=t(ind);
                tretgrid(j,i) = trit;
                [~, ind] = min(abs(t - trit));
                xrit=x(ind);
                yrit=y(ind);
                
                %spezziamo la formula calcolando a parte i vari valori in 
                %essa ricorrenti
                betaxrit = vx(ind)/c;
                betayrit = vy(ind)/c;
                gamma = 1/sqrt(1 - (betaxrit^2 + betayrit^2));
                
                %R = sqrt((xoss - xrit)^2 + (yoss - yrit)^2);%questa R
                %penso si possa recuperare dal vettore R di prima: le
                %formule di queste due R differiscono solo per il fatto che
                %anziché tutto x prendiamo solo xrit, ma è chiaro che
                %essendo xrit=x(ind) per def. la componente di posto ind
                %del vettore R è quella che cerchiamo in quanto per tale
                %valore dell'indice le due formule coincidono!
                
                R_oss=R(ind);
                nxrit = (xoss - xrit)/R_oss;
                nyrit = (yoss - yrit)/R_oss;
                %betaxdotrit = axrit/c;%inutile salvare come variabile
                %axrit anziché direttamente betaxdotri
                %betaydotrit = ayrit/c;
                betaxpuntorit = ax(ind)/c;
                betaypuntorit = ay(ind)/c;
                
                %formule copiate spudoratamente
                n_meno_betaxret = nxrit - betaxrit;
                n_meno_betayret = nyrit - betayrit;
                %i punti si possono levare se non uso vettori per gamma e
                %beta
            
                numeratore_x = nyrit.*(n_meno_betaxret.*betaypuntorit - n_meno_betayret.*betaxpuntorit);
                numeratore_y = -nxrit.*(n_meno_betaxret.*betaypuntorit - n_meno_betayret.*betaxpuntorit);
            
                betapuntonrit = betaxrit.*nxrit + betayrit.*nyrit;
            
                Ex(j,i) = n_meno_betaxret./( gamma.^2.*(1-betapuntonrit).^3.*R_oss.^2) + (1/c)*(numeratore_x./((1-betapuntonrit).^3.*R_oss));
                Ey(j,i) = n_meno_betayret./( gamma.^.2*(1-betapuntonrit).^3.*R_oss.^2) + (1/c)*(numeratore_y./((1-betapuntonrit).^3.*R_oss));
                Bz(j,i) = nxrit.*Ey(j,i) - nyrit.*Ex(j,i);%manca tipo il fattore e^2/4piepsilon0 ma va be'
                Sx(j,i) = Ey(j,i).*Bz(j,i);
                Sy(j,i) = -Ex(j,i).*Bz(j,i);  
                
            end
        end
        
        S_modulo = sqrt(Sx.^2 + Sy.^2);
        
        %figure(1)%passo da una matrice 2x2 a una 3x2, vediamo
        clf
        subplot(321)
        imagesc(xq, yq, log(abs(S_modulo)))
        colorbar
        title('$|\vec{S}|$','interpreter','latex')
        hold on
        scatter(xa, ya,100,'.','red')
        hold off
        axis image %axis IMAGE  is the same as axis EQUAL except that the plot box fits tightly around the data.
        %ticksOff
        caxis([clo chi])
      
        subplot(322)
        imagesc(xq, yq, log(abs(Ex)))
        colorbar
        title('$E_x$','interpreter','latex')
        hold on
        scatter(xa, ya,100,'.','red')
        hold off
        axis image
        %ticksOff
        caxis([clo/2 chi/2])
    
        subplot(323)
        imagesc(xq, yq, tretgrid)
        title('$t_{ret}$','interpreter','latex')
        hold on
        scatter(xa, ya,100,'.','red')
        hold off
        axis image
        %ticksOff
        colorbar
    
        subplot(324)
        imagesc(xq, yq, log(abs(Ey)))
        colorbar
        title('$E_y$','interpreter','latex')
        hold on
        scatter(xa, ya,100,'.','red')
        hold off
        axis image
        %ticksOff
        caxis([clo/2 chi/2])
    
%         figure(2)
%         clf
%         quiver(xq,yq,Ex,Ey)
%         title('$\vec{E}$','interpreter','latex')
%funziona ma l'avanti e indietro fra figure triggera il pc e non mi va a
%genio
 
        E_modulo = sqrt(Ex.^2+Ey.^2);
        subplot(325)
        imagesc(xq, yq, log(abs(E_modulo)))
        colorbar
        title('$|\vec{E}|$','interpreter','latex')
        hold on
        scatter(xa, ya,100,'.','red')
        hold off
        axis image
        %ticksOff
        caxis([clo/2 chi/2])
        
        subplot(326)
        imagesc(xq, yq, log(abs(Bz)))
        colorbar
        title('$B_z$','interpreter','latex')
        hold on
        scatter(xa, ya,100,'.','red')
        hold off
        axis image
        %ticksOff
        caxis([clo/2 chi/2])
        
        %subplot(326)
        %quiver(xq,yq,Ex,Ey,10)%devo trovare un modo per visualizzarlo
        %meglio
        %title('$\vec{E}$','interpreter','latex')
        
        drawnow limitrate
    
        set(gcf, 'PaperPositionMode', 'auto')
%         if(saveFlag)
%             print(gcf, [nomeFile '_' num2str(n) '.png'], '-dpng', '-r150')
%         end
        print(gcf, [nomeFile '_' num2str(n) '.png'], '-dpng', '-r0')%r0  la risoluzione dello schermo
        %tanto vale semplicemente commentare o meno la riga in questione
    end
    drawnow
end
