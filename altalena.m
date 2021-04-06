%INTEGRAZIONE NUMERICA E PLOT SOLUZIONE
clear
%clf
riproduci_animazione=1;%metti 1 per riprodurla e 0 per no
close all
syms phi(t) theta(t) m s l R g h omega_0 theta_0
theta(t)=theta_0*cos(omega_0*t);%con il coseno si parte da theta_0 a t=0. NOTA: Mettendo questa riga dopo la prossima non funziona niente
eq = (l^2-2*l*s*cos(theta(t))+s^2+R^2)*diff(phi,2) == -g*l*sin(phi(t))+g*s*sin(phi(t)+theta(t))-l*s*sin(theta(t))*(diff(theta))^2+(l*s*cos(theta(t))-s^2-R^2)*diff(theta,2)-2*l*s*sin(theta(t))*diff(theta)*diff(phi);
[V,S]=odeToVectorField(eq);%così S=[phi, Dphi] e V è l'eq. ridotta al primo ordine
f=matlabFunction(V, 'vars', {'t','Y','m','s','l','R','g','omega_0','theta_0'});
l=2.5;
h=2;
R=h/sqrt(12);%valido per la sbarra rigida uniforme appesa per il punto medio
s=h/2;
m=1;
theta_0=0.5;
g=9.81;
%omega_0=sqrt(g/l);
omega_0=sqrt(g*(l-s)/(R^2+(l-s)^2));
cond_in=[0,0];%phi e phi'=0 inizialmente
tspan=[0,10];%l'intervallo cui apparterrà il tempo. %con 0,50 si evidenzia il comportamento "a battimenti" di phi giustificabile dal fatto che se la frequenza non cresce con l'ampiezza (come accade con la nostra scelta di theta) allora dopo un po' il pompaggio diventa tipo interferenza distruttiva
%tspan=[0,20];
Y=ode45(@(t,Y) f(t,Y,m,s,l,R,g,omega_0,theta_0),tspan,cond_in);%ad f devo dare adesso i valori numerici corrispondenti alle varie variabili simboliche
%T=linspace(0,10);%per usare plot a differenza di fplot serve il vettore di input
%numero_istanti_di_tempo=1000;
%T=linspace(tspan(1),tspan(2),numero_istanti_di_tempo);
T=linspace(tspan(1),tspan(2));
Phi=deval(Y,T);%estraggo dalla struttura Y il vettore dei punti soluzione; è necessario aver GIà specificato il vettore dei punti in corrispondenza dei quali si vuole valutare la soluzione
%plot(T,Phi(1,:),'b+:');
plot(T,Phi(1,:));
%con le maiuscole indico le controparti numeriche delle variabili simboliche; per farlo uso il comando double
hold on;
%plot(T,Phi(2,:),'go-.');%NOTA: deval restituisce una matrice con due righe e size(T) colonne
plot(T,Phi(2,:));
Theta_0=double(theta_0);
Omega_0=double(omega_0);%forse non è necessario perché comunque ho riutilizzato i nomi delle variabili per indicare non quelle simboliche ma i valori numerici che ho passato ad ode45, ma per non sbagliare converto in double la sym con il comando double (l'opposto è ovviamente sym)
Theta=Theta_0*cos(Omega_0*T);
%plot(T,Theta,'rx--');
plot(T,Theta);
xlabel('tempo (s)');
ylabel('ampiezza (rad)');
legend('\phi','d\phi/dt','\theta')
%[fi,fi_primo]=deval(Y,T);
%figure
%plot(T,fi);
%hold on;
%plot(T,fi_primo);
%legend('fi','fi primo');

%--------------plot diagramma di fase (con trucchetto?)--------------------
figure
hold on
%plot(complex(Phi(1,:),Phi(2,:)))%non serve il complex, è equivalente
%all'altra cosa scritta qua sotto
plot(Phi(1,:),Phi(2,:))

R2=(R^2+(l-s)^2);%(R')^2
F=omega_0^2*l*R^2*theta_0/((l-s)*R2);
phi_D=@(t) 0.5*F.*t/omega_0.*sin(omega_0*t);
Dphi_D=@(t) 0.5*F/omega_0.*(sin(omega_0*t)+omega_0+t.*cos(omega_0*t));
%fplot(@(t) complex(phi_D(t),Dphi_D(t)),tspan);%no no no
plot(phi_D(T),Dphi_D(T));

A=-omega_0^2*s*theta_0^2/(4*(l-s));
B=omega_0*l*s*theta_0^2/(R2);
C=-0.5*l*s*theta_0^2/R2;
lambda=-(A-omega_0*B-omega_0^2*C)/(4*omega_0); %così spunta positivo
phi_0_param=-10*pi/180;%metto 10 gradi tipo Roura ma converto in radianti. Inoltre prendo phi0 negativo tipo Case!!
radq2phi_0=sqrt(2)*phi_0_param;
phi_P=@(t) radq2phi_0.*exp(lambda*t).*cos(omega_0*t+pi/4);
Dphi_P=@(t) radq2phi_0*(lambda*exp(lambda*t).*cos(omega_0*t)-omega_0*exp(lambda*t).*sin(omega_0*t));
%fplot(@(t) complex(phi_P(t),Dphi_P(t)),tspan);%no no no
plot(phi_P(T),Dphi_P(T));

legend('Soluzione numerica','Soluzione driven','Soluzione parametric')
xlabel('$\varphi$', 'interpreter', 'latex')
%xlabel('\phi')
%ylabel('d\phi/dt')
ylabel('$\dot{\varphi}$', 'interpreter', 'latex')

%----------confronto con la soluzione driven e parametrica-----------------
figure
hold on 
plot(T,Phi(1,:));
fplot(phi_D,tspan);
fplot(phi_P,tspan);
legend('Soluzione numerica','Soluzione driven','Soluzione parametric');

%--------plot di phi_D e phi_P separatamente e confrontati con theta-------
figure
hold on
plot(T,Theta);
fplot(phi_D,tspan);
legend('$\theta(t)$','$\varphi_D(t)$','interpreter','latex')
figure
hold on
%plot(T,Theta);%mi serve la derivata di theta, non di phi...
%fplot(Dphi_D,tspan);
%legend('$\theta(t)$','$\mathrm{d}\varphi_D(t)/\mathrm{d}t$','interpreter','latex')
fplot(@(t) -omega_0*theta_0*sin(omega_0*t),tspan);
fplot(phi_D,tspan);
legend('$\mathrm{d}\theta(t)/\mathrm{d}t$','$\varphi_D(t)$','interpreter','latex')
figure
hold on
plot(T,Theta);
fplot(phi_P,tspan);
legend('$\theta(t)$','$\varphi_P(t)$','interpreter','latex')
figure
hold on
%plot(T,Theta);
%fplot(Dphi_P,tspan);
%legend('$\theta(t)$','$\mathrm{d}\varphi_P(t)/\mathrm{d}t$','interpreter','latex')
fplot(@(t) -omega_0*theta_0*sin(omega_0*t),tspan);
fplot(phi_P,tspan);
legend('$\mathrm{d}\theta(t)/\mathrm{d}t$','$\varphi_P(t)$','interpreter','latex')

%-----------------Gamma (analizzare meglio)--------------------------------
[estrel,~]=findpeaks(Phi(1,:));%non mi serve l'altro output, metto la tilde
% massimi=[];%so che i minimi di phi saranno tutti negativi, quindi mi basta aggiungere in coda al vettore vuoto massimi i valori positivi di estrel
% for i=1:length(estrel)
%     if estrel(i)>0
%         massimi=[massimi,estrel(i)]; %così non sto preallocando...
%     end
% end
ind=find(estrel>0);%indici lineari, siccome uso find con vettori e non matrici non c'è problema
massimi=estrel(ind);
gamma_n=diff(massimi);%il vettore delle differenze mi darà le variazioni di ampiezza per ciascun ciclo
gamma_d=pi*F/omega_0^2*ones(1,length(gamma_n));
%gamma_p=2*pi*lambda/omega_0.*massimi;
a=2*pi*lambda/omega_0;

%la media presente in Gamma_P non va calcolata dalla soluzione esatta ma da
%quella approssimata per l'oscillatore puramente parametrico!
[estrel,~]=findpeaks(phi_P(T));
ind=find(estrel>0);
massimi=estrel(ind);
gamma_p=a.*massimi(2:length(massimi));%gli levo il primo perché il vettore delle differenze ha un elemento in meno del vettore dei massimi; levo il primo perché mi interessa confrontare le coppie e il primo non ha precedente (penso)
figure%fissato un determinato ciclo il massimo rappresenta proprio l'ampiezza/la media quadratica (da cui gamma_p)
hold on
x_gamma=linspace(1,length(gamma_n),length(gamma_n));
plot(x_gamma,gamma_n,'o-');
plot(x_gamma,gamma_d,'o-');
plot(x_gamma,gamma_p,'o-');
legend('\Gamma_N','\Gamma_D','\Gamma_P');

%-----------------------------angolo critico-------------------------------
phi_c=@(x) 8*x*R^2/(theta_0*s*(R^2+(3*x-s)*(x-s)));
display_angolo_critico=0;
if display_angolo_critico==1
    disp('Angolo critico per l=');
    disp(l);
    disp(':');
    disp(phi_c(l));
end


%------------------------------ANIMAZIONE----------------------------------
%nel codice seguente relativo all'animazione (x0,y0) è la seduta 
%dell'altalena, (x1,y1) la "testa" e (x2,y2) i "piedi". (x0,y0)=origine
figure
%metto l'origine nel supporto fisso
x0 = @(t) l*sin(deval(Y,t,1));%basta specificare l'argomento dopo con il function handle @(t) perché matlab capisca!
y0 = @(t) -l*cos(deval(Y,t,1));%come argomento Phi(1,t) dà errore, forse perché Phi è "legato" a T; rifaccio deval come nel codice del pendolo doppio
%xo = @(t) 0;
%yo = @(t) 0;%non necessario, va bene mettere 0 negli intervalli sotto
x1 = @(t) l*sin(deval(Y,t,1))-s*sin(deval(Y,t,1)+theta_0*cos(omega_0*t));%l'angolo rispetto alla normale del segmento azzurro è phi+theta
y1 = @(t) -l*cos(deval(Y,t,1))+s*cos(deval(Y,t,1)+theta_0*cos(omega_0*t)); %non vuole che scriva x0(t)+..., forse per lo stesso motivo per cui non gli piace Phi
x2 = @(t) l*sin(deval(Y,t,1))+s*sin(deval(Y,t,1)+theta_0*cos(omega_0*t));
y2 = @(t) -l*cos(deval(Y,t,1))-s*cos(deval(Y,t,1)+theta_0*cos(omega_0*t));%di nuovo non gli piace theta(t), devo ricopiare a mano l'espressione esplicita. Penso che il motivo sia di nuovo quello!
axis equal;%per capire perché serva phi+theta "vacci da sopra": disegna la parallela alla retta di riferimento per phi  passante per la seduta e considera l'angolo formato da questa retta verso il punto di interesse. Il triangolo rettangolo desiderato si ottiene prendendo la perpendicolare alla retta di phi passante per il punto di interesse
hold on;%in alternativa penso vada bene direttamente usare fplot qui sotto
fanimator(@(t) plot(x0(t),y0(t),'bo','MarkerSize',m*10,'MarkerFaceColor','b'),'AnimationRange',tspan);
fanimator(@(t) plot(0,0,'bo','MarkerSize',m*10,'MarkerFaceColor','b'),'AnimationRange',tspan);
fanimator(@(t) plot([0 x0(t)],[0 y0(t)],'b-'),'AnimationRange',tspan);%per disegnare un segmento basta specificare le coordinate dei suoi due estremi in questo modo (a intervalli, tipo)
fanimator(@(t) plot(x1(t),y1(t),'co','MarkerSize',m*10,'MarkerFaceColor','c'),'AnimationRange',tspan);
fanimator(@(t) plot(x2(t),y2(t),'co','MarkerSize',m*10,'MarkerFaceColor','c'),'AnimationRange',tspan);
fanimator(@(t) plot([x1(t) x2(t)],[y1(t) y2(t)],'c-'),'AnimationRange',tspan);
fanimator(@(t) text(-0.6,0.3,"Tempo (s): "+num2str(t,2)),'AnimationRange',tspan);%il secondo argomento di num2str è il numero di cifre significative mostrate
hold off;
if riproduci_animazione==1
    playAnimation;
end
%playAnimation;
%writeAnimation('altalena.avi');
%NOTA IMPORTANTE: il programma test_coseno rende alquanto evidente che la
%struttura soluzione prodotta da ode45 contenga sia la soluzione che la sua
%derivata prima (e probabilmente conterrebbe ad esempio la seconda nel caso
%in cui l'equazione fosse stata del terzo ordine e così via; si potrebbe
%provare); questo fatto viene "preservato" da deval, che interpola i pochi
%punti prodotti da ode45 in modo da dare una soluzione che sia una funzione
%continua -
%infatti se grafichiamo direttamente la struttura dati soluzione offerta da ode 45
%(che ha come componente x l'input a cui viene valutata la soluzione e come
%componente y due righe: la prima evidentemente è y e la seconda y') spunta
%fuori una figura spigolosa perché ode45 calcola la soluzione "a campione"
%ogni tanto; invece deval contiene una funzione che fa una interpolazione
%in modo da produrre una funzione continua e pertanto una curva liscia -
%ecco perché conviene usarlo!
% - ed ecco spiegato perché Phi che voglio graficare contenga due righe
% anziché una sola: una è phi, l'altra phi'