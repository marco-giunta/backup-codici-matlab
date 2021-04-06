clear
close all
N=70;%aggiungo 2 curve per poter tornare nell'origine
n_curve=22;%prima era 19 ma non sono sicuro di come l'avessi ottenuto
x=zeros(n_curve,N);%devo disegnare n_curve curve in totale; riga i=curva i. Ogni riga evidentemente sarà composta da N punti
y=zeros(n_curve,N);%così prealloco la memoria
x(1,:)=linspace(0,-3,N);%linea orizzontale bassa
y(1,:)=1.232*ones(1,N);
%plot(x(1,:),y(1,:))
x(2,:)=-3*ones(1,N);%linea verticale sinistra
y(2,:)=linspace(1.232,4,N);
x(3,:)=linspace(-3,0,N);%linea orizzontale alta
y(3,:)=4*ones(1,N);
x(4,:)=zeros(1,N);%linea verticale destra pezzettino alto
y(4,:)=linspace(4,3.6,N);
x(5,:)=linspace(0,-0.191,N);%linea orizzontale luna percorsa verso sinistra
y(5,:)=3.6*ones(1,N);
cx=sqrt(0.14);
cy=sqrt(0.15/1.5);
t=linspace(0,2*pi,N);
x(6,:)=-0.56+cx*cos(t);%luna
y(6,:)=3.65+cy*sin(t);
x(7,:)=linspace(-0.191,0,N);%linea orizzontale luna percorsa verso sinistra
y(7,:)=3.6*ones(1,N);
x(8,:)=zeros(1,N);%linea verticale destra pezzettone centrale
y(8,:)=linspace(3.6,1.7096,N);
%--------------------------TEST--------------------------------------------
cx=sqrt(10);%è sqrt(1/0.1)
cy=sqrt(1/16);
% A=0.1;
% B=16;
% C=1;

X=0;
Y=1.7096;
Y0=1.53;%attento: atan2 dà un risultato fra -pi e pi, mentre atan fra -pi/2 e pi/2!
X0=2.2;
t1=atan(((Y-Y0)/cy)/((X-X0)/cx))+pi;
%t1=asin((Y-Y0)/cy);
%t1=acos(sqrt(1-((B/C)*(Y-Y0)^2)));no

X=-0.9622;
Y=1.5282;
%t2=acos(sqrt(1-((B/C)*(Y-Y0)^2)));
%t2=asin((Y-Y0)/cy);
t2=atan(((Y-Y0)/cy)/((X-X0)/cx))+pi;

t=linspace(t1,t2,N);
%x(9,:)=-(X0+cx*cos(t));%una soluzione non elegante...
x(9,:)=X0+cx*cos(t);
y(9,:)=Y0+cy*sin(t);
%--------------------------------------------------------------------------
x(10,:)=flip(x(9,:));
y(10,:)=flip(y(9,:));%ripercorro la collina di destra tornando sull'asse y
x(11,:)=zeros(1,N);%segmentino verticale finale, in basso a destra
y(11,:)=linspace(1.7096,1.232,N);
D=crea_ellisse(2,5,(15+8+(9/5)),-2,-(3/5),0,1.233,-3,1.5354,0,1,N);
x(12,:)=D(1,:);
y(12,:)=D(2,:);
D=crea_ellisse(2,5,(15+8+(9/5)),-2,-(3/5),-3,1.5354,-2.2864,1.61973,1,1,N);
x(13,:)=D(1,:);
y(13,:)=D(2,:);
D=crea_ellisse(5,1,1,-2.7,2,-2.2864,1.61973,-2.2532,2.0416,0,0,N);
x(14,:)=D(1,:);
y(14,:)=D(2,:);
D=crea_ellisse(1,1.7,0.025,-2.145,2.13,-2.2532,2.0416,-2.0541,2.0308,1,0,N);
x(15,:)=D(1,:);
y(15,:)=D(2,:);
D=crea_ellisse(1.85,0.7,1,-2.74,1.6,-2.0541,2.0308,-2.005,1.6271,0,0,N);
x(16,:)=D(1,:);
y(16,:)=D(2,:);
D=crea_ellisse(2,5,(15+8+(9/5)),-2,-(3/5),-2.005,1.6271,-1.8625,1.6254,1,0,N);
x(17,:)=D(1,:);
y(17,:)=D(2,:);
x(18,:)=linspace(-1.8625,-1.8891,N);
y(18,:)=-17-10*x(18,:);
D=crea_ellisse(1,1.7,0.01,-1.96,1.945,-1.8891,1.8909,-2.0264,1.8876,0,-1,N);%ATTENZIONE: qui devo mettere -1 perché devo invertire il verso di percorrenza dell'ellisse, che nella funzione crea ellisse è antiorario
x(19,:)=D(1,:);%(spiegazione non impeccabile ma il senso è quello)
y(19,:)=D(2,:);
D=crea_ellisse(1,1.7,0.01,-1.96,1.945,-2.0264,1.8876,-2.0442,1.9863,-1,1,N);%il -1 fa quadrare le cose come sopra anche se non sono al 100% convinto del perché
x(20,:)=D(1,:);
y(20,:)=D(2,:);
D=crea_ellisse(1.85,0.7,1,-2.74,1.6,-2.0442,1.9863,-2.005,1.6271,0,0,N);
x(21,:)=D(1,:);
y(21,:)=D(2,:);
D=crea_ellisse(2,5,(15+8+(9/5)),-2,-(3/5),-2.005,1.6271,0,1.232,1,0,N);
x(22,:)=D(1,:);
y(22,:)=D(2,:);

%----------------------PRODUZIONE ARRAY FINALI-----------------------------
% X=x';%introduco nuove variabili per distinguerle dalle vecchie
% Y=y';%reshape scorre lungo le colonne, quindi per disegnare una curva alla volta anziché mescolarle devo trasporre
% reshape(X,[1,n_curve*N]);%una colonna con n*N elementi perché ogni curva ne ha N
% reshape(Y,[1,n_curve*N]); %reshape non fa niente per qualche motivo...
%X=zeros(n_curve*N,1);
%Y=zeros(n_curve*N,1);%meglio usare la soluzione non elegante che
%preoccuparmi di quale indice mettere dentro l'array
X=[];
Y=[];
xt=x';
yt=y';
for i=1:n_curve
    X=[X;xt(:,i)];
    Y=[Y;yt(:,i)];
end
%--------------------------------------------------------------------------

hold on
axis equal
for i=1:n_curve
    plot(x(i,:),y(i,:));
end
title("x vs y")

figure
axis equal
plot(X,Y);
title("X vs Y")
%M=[X Y];
fid=fopen("chiara.txt","w");
%fprintf(fid,'%f %f\n',M);
for i=1:length(X)
    fprintf(fid,'%f %f\n',X(i),Y(i));
end
fclose(fid);

%qui A e B sono i coefficienti di (x-X0)^2 e (y-Y0)^2, mentre C è il
%termine noto. ATTENZIONE: qui suppongo che dentro la parentesi non vi sia
%niente davanti a x o y
function D=crea_ellisse(A,B,C,X0,Y0,X1,Y1,X2,Y2,quadrante_1,quadrante_2,N)%quadrante=0 se va bene il dominio [-pi/2,pi/2] (quadranti 1 e 4), 1 se no (2 e 3)
    cx=sqrt(C/A);%in altri termini: se graficando l'ellisse traslata in modo da essere centrata su (0,0) il punto iniziale/finale si trova nel quadrante 1/4 metti 0, 1 se nel 2/3
    cy=sqrt(C/B);
    quadrante_1=quadrante_1*pi;
    quadrante_2=quadrante_2*pi;
    t1=atan(((Y1-Y0)/cy)/((X1-X0)/cx))+quadrante_1;
    t2=atan(((Y2-Y0)/cy)/((X2-X0)/cx))+quadrante_2;
    t=linspace(t1,t2,N);
    D=[X0+cx*cos(t);Y0+cy*sin(t)];%la prima riga è formata dalle x, la seconda dalle y
end


%non so perché non funzioni
% function [x;y]=crea_ellisse(A,B,C,X0,Y0,X1,Y1,X2,Y2)
%     cx=sqrt(C/A);
%     cy=sqrt(C/B);
%     temp=acos((X1-X0)/cx);
%     t1=asin((Y1-Y0)/cy);
%     if
%
%     end
% end