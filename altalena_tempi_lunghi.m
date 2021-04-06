clear
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
omega_0=sqrt(g*(l-s)/(R^2+(l-s)^2));
N=1000;%se no linspace prende punti troppo distanti
delta_t=100;%TEMPO TOTALE
cond_in=[0,0];%phi e phi'=0 inizialmente
tspan=[0,delta_t];%l'intervallo cui apparterrà il tempo
%tspan=[0,20];
Y=ode45(@(t,Y) f(t,Y,m,s,l,R,g,omega_0,theta_0),tspan,cond_in);%ad f devo dare adesso i valori numerici corrispondenti alle varie variabili simboliche
%T=linspace(0,10);%per usare plot a differenza di fplot serve il vettore di input
T=linspace(tspan(1),tspan(2),N);
Phi=deval(Y,T);%estraggo dalla struttura Y il vettore dei punti soluzione; è necessario aver GIà specificato il vettore dei punti in corrispondenza dei quali si vuole valutare la soluzione
% plot(T,Phi(1,:),'b+:');
% %con le maiuscole indico le controparti numeriche delle variabili simboliche; per farlo uso il comando double
% hold on;
% plot(T,Phi(2,:),'go-.');%NOTA: deval restituisce una matrice con due righe e size(T) colonne
% Theta_0=double(theta_0);
% Omega_0=double(omega_0);%forse non è necessario perché comunque ho riutilizzato i nomi delle variabili per indicare non quelle simboliche ma i valori numerici che ho passato ad ode45, ma per non sbagliare converto in double la sym con il comando double (l'opposto è ovviamente sym)
% Theta=Theta_0*cos(Omega_0*T);
% plot(T,Theta,'rx--');
% xlabel('tempo (s)');
% ylabel('ampiezza (rad)');
% legend('\phi','d\phi/dt','\theta')

%--------------------------PLOT SOLUZIONI----------------------------------
R2=(R^2+(l-s)^2);%(R')^2
F=omega_0^2*l*R^2*theta_0/((l-s)*R2);
phi_D=@(t) 0.5*F.*t/omega_0.*sin(omega_0*t);
Dphi_D=@(t) 0.5*F/omega_0.*(sin(omega_0*t)+omega_0+t.*cos(omega_0*t));
A=-omega_0^2*s*theta_0^2/(4*(l-s));
B=omega_0*l*s*theta_0^2/(R2);
C=-0.5*l*s*theta_0^2/R2;
lambda=-(A-omega_0*B-omega_0^2*C)/(4*omega_0); %così spunta positivo
phi_0_param=10*pi/180;%metto 10 gradi tipo Roura ma converto in radianti
radq2phi_0=sqrt(2)*phi_0_param;
phi_P=@(t) radq2phi_0.*exp(lambda*t).*cos(omega_0*t+pi/4);
Dphi_P=@(t) radq2phi_0*(lambda*exp(lambda*t).*cos(omega_0*t)-omega_0*exp(lambda*t).*sin(omega_0*t));
figure
hold on 

t_plot=delta_t/2;
indice=find(ceil(T)==t_plot);%ceil e floor approssimano per eccesso e difetto rispettivamente; non mi cambia molto, qui
plot(T(1:indice),Phi(1:indice));
fplot(phi_D,[tspan(1),t_plot]);
fplot(phi_P,[tspan(1),t_plot]);
legend('Soluzione numerica','Soluzione driven','Soluzione parametric');

%---------------------------------GAMMA------------------------------------
[estrel,~]=findpeaks(Phi(1,:));%non mi serve l'altro output, metto la tilde
massimi=[];%so che i minimi di phi saranno tutti negativi, quindi mi basta aggiungere in coda al vettore vuoto massimi i valori positivi di estrel
ind=find(estrel>0);
massimi=estrel(ind);
gamma_n=diff(massimi);%il vettore delle differenze mi darà le variazioni di ampiezza per ciascun ciclo
gamma_d=pi*F/omega_0^2*ones(1,length(gamma_n));
%gamma_p=2*pi*lambda/omega_0.*massimi;
a=2*pi*lambda/omega_0;
gamma_p=a.*massimi(2:length(massimi));%gli levo il primo perché il vettore delle differenze ha un elemento in meno del vettore dei massimi; levo il primo perché mi interessa confrontare le coppie e il primo non ha precedente (penso)
figure%fissato un determinato ciclo il massimo rappresenta proprio l'ampiezza/la media quadratica (da cui gamma_p)
hold on
x_gamma=linspace(1,length(gamma_n),length(gamma_n));
plot(x_gamma,gamma_n,'o-');
plot(x_gamma,gamma_d,'o-');
plot(x_gamma,gamma_p,'o-');
legend('\Gamma_N','\Gamma_D','\Gamma_P');

figure
hold on
plot(T,Phi(1,:));
Gamma_D=gamma_d(1);%tanto è costante
fplot(@(t) Gamma_D.*t,tspan);


eq = diff(phi,2)+omega_0^2 == F*cos(omega_0*t)+A*cos(2*omega_0*t)*phi+B*sin(2*omega_0*t)*diff(phi)+C*cos(2*omega_0*t)*diff(phi,2);
[V,~]=odeToVectorField(eq);
f=matlabFunction(V, 'vars', {'t','Y','m','s','l','R','g','omega_0','theta_0'});
%T=linspace(tspan(1),tspan(2));
Z=ode45(@(t,Y) f(t,Y,m,s,l,R,g,omega_0,theta_0),tspan,cond_in);
Phi_lin=deval(Z,T);
figure
hold on
plot(T(1:indice),Phi_lin(1:indice));
fplot(phi_D,[tspan(1),t_plot]);
fplot(phi_P,[tspan(1),t_plot]);
legend('Soluzione numerica approx','Soluzione driven','Soluzione parametric');