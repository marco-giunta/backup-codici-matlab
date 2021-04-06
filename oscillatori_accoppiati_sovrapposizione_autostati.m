clear
%clf
close all
%=========================================================================
modo_normale=3;%1 pendulum mode, 2 breathing mode, 3 battimenti 
trasformata=1; %1 per calcolare lo spettro delle frequenze
%=========================================================================
k1=1;
k2=1;
k=1;
m1=5;
m2=5;
dt=10;
%tspan=[0,10];
if modo_normale==1
    %così per il pendulum normal mode; queste posizioni sono riferite alla posizione di equilibrio
    x0=[1;1];
    v0=[0;0];
end
if modo_normale==2
    %così per il breathing normal mode
    x0=[1;-1];
    v0=[0;0];
end
if modo_normale==3
    m1=7;
    m2=7;
    k1=15;
    k2=15;
    k=0.5;%per avere battimenti deve essere k<<k1=k2
    %tspan=[0,20];
    x0=[0;1];
    v0=[0;0];
    dt=1000;%non viene fuori il comportamento "buono" con tempi troppo brevi
end
%matrice del sistema y''=Ay con y=[x1; x2], cioè è il ket dello stato
A=-[-(k+k1)/m1 k/m1;
    k/m2 -(k+k2)/m2];%senza quel - gli autovalori vengono negativi, le autofrequenze immaginarie e le x anziché oscillanti sonoo esponenziali reali
[V,D]=eig(A);%le colonne della matrice V sono gli autovettori ortogonali e già normalizzati; 
%la matrice D è A diagonalizzata, cioè ha sulla diagonale gli autovalori
%(autofrequenze^2)
%B=sym(A);
%[C,E]=eig(B);%RICORDA: D CONTERRà LE AUTOFREQUENZE ANGOLARI!!!
D=D.^(1/2);%le autofrequenze sono la radice quadrata degli autovalori di A
t=linspace(0,dt,1000);%linspace(0,10,1000); o 0:1000:10
C_p=dot(V(:,1),x0)+1i*dot(V(:,1),v0)/(-D(1,1));%eq 5.8.2-a-b-c-d di Smith, pagina 182 del pdf
C_b=dot(V(:,2),x0)+1i*dot(V(:,2),v0)/(-D(2,2));%C_p e C_b sono reali se le velocità iniziali sono nulle
x=real(C_p*exp(1i*D(1,1)*t).*V(:,1)+C_b*exp(1i*D(2,2)*t).*V(:,2));%eq 5.8.1 di Smith, pag 183 del pdf
%scritto così x avrà due righe (una per ogni x_i) e length(T) colonne,
%perché avrò length(T) "copie" (scalate dell'esponenziale complesso per
%C) del ket iniziale (cioè una per ogni istante di tempo)
plot(t,x(1,:));
hold on;
plot(t,x(2,:));
legend('x_1','x_2');
title('(esponenziale complesso)');
xlabel('tempo (s)');
ylabel('x');
y=(real(C_p)*cos(D(1,1)*t).*V(:,1)+real(C_b)*cos(D(2,2)*t).*V(:,2));%in alternativa col coseno
figure;
plot(t,y(1,:));
hold on;
plot(t,y(2,:));
legend('x_1','x_2');
title('(coseno)');

if trasformata==1
   x1=x(1,:);
   x2=x(2,:);
   [f,a1]=spettroFrequenze(t,x1); %#ok<ASGLU> %serve a sopprimere il messaggio di matlab
   [f,a2]=spettroFrequenze(t,x2);
   figure
   hold on;
   plot(f,a1);
   plot(f,a2);
   legend('tf x_1','tf x_2');
   title('spettri delle frequenze');
   xlabel('frequenze (Hz)');
   ylabel('ampiezze ([x])');
   
   [picchi_1,frequenze_1]=findpeaks(a1);
   [picchi_2,frequenze_2]=findpeaks(a2);
   for i=1:(length(picchi_1))
       %picco_str=num2str(picchi_1(i));
       %freq_str=num2str(frequenze_1(i));
       fprintf('\nTrovato un picco in a1 di ampiezza %s',num2str(picchi_1(i)));
       fprintf(' alla frequenza %s \n',num2str(f(frequenze_1(i))));
   end
   for i=1:(length(picchi_2))
       fprintf('\nTrovato un picco in a2 di ampiezza %s',num2str(picchi_2(i)));
       fprintf(' alla frequenza %s \n',num2str(f(frequenze_2(i))));
   end
   F=D./(2*pi);%Ricorda che D contiene le autofrequenze angolari, cioè 2*pi volte le frequenze che dovresti ottenere dalla tf!
   fprintf('\nValori attesi per x1: %s a %s',num2str(abs(real(C_p)*V(1,1))),num2str(F(1,1)));
   fprintf(' e %s a %s\n',num2str(abs(real(C_b)*V(1,2))),num2str(F(2,2)));
   fprintf('\nValori attesi per x2: %s a %s',num2str(abs(real(C_p)*V(2,1))),num2str(F(1,1)));
   fprintf(' e %s a %s\n',num2str(abs(real(C_b)*V(2,2))),num2str(F(2,2)));
end


