% codice di prova perchè il precedente non trova i corretti valori del
% parametro d'ordine
clc
clear
N=1000;
dt=0.05;
T=1500;
w=randn(N,1);
r=[];
x0=[zeros(N,1) rand(N,1)*2*pi];

for k=1:2
    x=x0(:,k);
    for t=1:T
        real_part=1/N*sum(arrayfun(@(y) cos(y),x));
        imag_part=1/N*sum(arrayfun(@(y) sin(y),x));
        
        r(k,t)=sqrt((real_part)^2+(imag_part)^2);
        psi=2*atan(imag_part/(r(k,t)+real_part));
        a=arrayfun(@(x,y) k*r(k,t)*sin(psi-x)+y,x,w(:,1));
        x=x+a*dt;
    end
end

figure 
tsteps=linspace(0,T,T);
scatter(tsteps,r(1,1:T),3);
hold on;
scatter(tsteps,r(2,1:T),3);
axis([0,T,0,1])
xlabel('t')
ylabel('r')
legend('k<k_c','k>k_c')