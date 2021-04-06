clear
clf
syms x1(t) x2(t) x3(t) x4(t) k1 k2 k3 k4 m1 m2 m3 m4 k12 k13 k24 k34
eq1 = diff(x1,2) == -(k1/m1)*x1-(k12/m1)*(x1-x2)-(k13/m1)*(x1-x3);
eq2 = diff(x2,2) == -(k2/m2)*x2-(k12/m2)*(x2-x1)-(k24/m2)*(x2-x4);
eq3 = diff(x3,2) == -(k3/m3)*x3-(k34/m3)*(x3-x4)-(k13/m3)*(x3-x1);
eq4 = diff(x4,2) == -(k4/m4)*x4-(k34/m4)*(x4-x3)-(k24/m4)*(x4-x2);
equazioni=[eq1 eq2 eq3 eq4];
[V,S]=odeToVectorField(equazioni);
f=matlabFunction(V, 'vars', {'t','Y','k1','k2','k3','k4','m1','m2','m3','m4','k12','k13','k24','k34'});
k1=1;
k2=1;
k3=1;
k4=1;
m1=20;
m2=20;
m3=20;
m4=20;
k12=1;
k13=1;
k24=1;
k34=1;
tspan=[0,10];
cond_in=[1,0,-1,0,-1,0,1,0];%S=[x2 Dx2 x1 Dx1 x3 Dx3 x4 Dx4];
Y=ode45(@(t,Y) f(t,Y,k1,k2,k3,k4,m1,m2,m3,m4,k12,k13,k24,k34),tspan,cond_in);
x_1 = @(t) deval(Y,t,3)-sym(4);
x_2 = @(t) deval(Y,t,1)-sym(4);
x_3 = @(t) deval(Y,t,5)+sym(2);
x_4 = @(t) deval(Y,t,7)+sym(4);
fanimator(@(t) plot(x_1(t),0,'ro','MarkerSize',10,'MarkerFaceColor','r'),'AnimationRange',tspan);
hold on;
axis equal;
fanimator(@(t) plot(x_2(t),0,'go','MarkerSize',10,'MarkerFaceColor','g'),'AnimationRange',tspan);
fanimator(@(t) plot(x_3(t),0,'bo','MarkerSize',10,'MarkerFaceColor','b'),'AnimationRange',tspan);
fanimator(@(t) plot(x_4(t),0,'co','MarkerSize',10,'MarkerFaceColor','c'),'AnimationRange',tspan);
fanimator(@(t) text(-0.5,0.3,"Tempo trascorso: "+num2str(t,2)),'AnimationRange',tspan);
hold off;
playAnimation;
figure;
hold on;
X=linspace(tspan(1),tspan(2));
g=deval(Y,X);
for i=1:8 
    plot(X,g(i,:));
end
legend('x_2','dx_2/dt','x_1','dx_1/dt','x_3','dx_3/dt','x_4','dx_4/dt');