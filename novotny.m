%function dydt = vdp1(t,y)
%VDP1  Evaluate the van der Pol ODEs for mu = 1
%
%   See also ODE113, ODE23, ODE45.

%   Jacek Kierzenka and Lawrence F. Shampine
%   Copyright 1984-2014 The MathWorks, Inc.

%dydt = [y(2); (1-y(1)^2)*y(2)-y(1)];
%[t,y] = ode45(@vdp1,[0 20],[2; 0]);

function dxdt = novotny(t,x)

%x sarà un vettore di coefficienti xa,xb,xa',xb'

%parametri
k=1;
kappa=1;
m=1;
deltak=1;
o20=(k+kappa)/m;
o2d=deltak/m;
o2c=kappa/m;
gamma=1;

%x=[];
x=zeros(20,2);
%qui sotto devo scrivere a cosa sono uguali le derivate xa'' e xb''
%f(t)=0
dxdt=[((-1)*gamma*x(3))+((o2d-o20)*x(1))+(o2c*x(2)), ((-1)*gamma*x(4))+((o2d-o20)*x(2))+(o2c*x(1))];
%[t,x]=ode45(dxdt,[0 20],[0; 0; 0; 0]);%intervallo di t e condizioni iniziali

%plot(t,x(:,1),'-o',t,x(:,2),'-o')
%title('Solution of van der Pol Equation (\mu = 1) with ODE45');
%xlabel('Time t');
%ylabel('Solution y');
%legend('y_1','y_2')