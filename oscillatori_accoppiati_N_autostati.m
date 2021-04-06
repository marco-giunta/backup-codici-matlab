clear
%clf 
close all
figure
N=2;%numero degli oscillatori identici
k=1;
m=5;
dt=10;
modo_normale=3;%1 pendulum, 2 breathing, 3 contraggo la prima molla e lascio andare
%un metodo per generare automaticamente le equazioni del moto potrebbe
%essere costruire la lagrangiana mediante un ciclo accedendo ad un cell
%array di funzioni, derivando simbolicamente mediante diff e poi estraendo
%la matrice mediante equationsToMatrix; riesco però solo a gestire cell
%arrays di function handles, quindi sarebbe da capire. In ogni caso con un
%gran numero di oscillatori a meno che non si prendano masse e costanti da
%un file esterno l'unica cosa pratica è rendere tutto identico - nel qual
%caso si ha già a disposizione l'equazione ricorsiva già vista.
A=-(k/m).*(ones(N)-3.*eye(N));
[V,D]=eig(A);
D=D.^(1/2);

if modo_normale==1
    x0=ones(1,N);
    v0=zeros(1,N);
end

if modo_normale==2
    x0=(-1).^(1:N);%vettore di 1 e -1 alternati mediante vectorization (credo)
    v0=zeros(1,N);
end

if modo_normale==3
    x0=zeros(1,N);
    x0(1)=-1;
    v0=zeros(1,N);
    dt=1000;
end

t=linspace(0,dt);
C=zeros(N);
for i=1:N
    C(i)=dot(V(:,i),x0)+1i*dot(V(:,i),v0)/(-D(i,i));%matlab non confonde indici e sqrt(-1) se metto 1i (credo)
end
x=zeros(N,1);
for i=1:N
    x=x+(C(i)*exp(1i*D(i,i)*t).*V(:,i));
end
x=real(x);
%scritto così x avrà due righe (una per ogni x_i) e length(T) colonne,
%perché avrò length(T) "copie" (scalate dell'esponenziale complesso per
%C) del ket iniziale
hold on;
for i=1:N
    plot(t,x(i,:));
    %plot(t,x(i,:),'DisplayName','oscillatore %d',num2str(i));
    %legend(arrayfun(@(mode) sprintf('Mode %d', mode), 1:size(y, 2), 'UniformOutput', false));
end
%serve un modo per scrivere una legenda con un numero variabile di
%elementi; ho diverse "proposte" ma per ora non funziona mathworks
hold off;






