clear
n=4;
syms t;
syms x(t) y(t) eqx(t) eqy(t) [n 1];
X=x(t);
Y=y(t);
Eqx=eqx(t);
Eqy=eqy(t);

for i=1:n
    a=0;
    b=0;
    for j=1:n
        if j~=i
            r=sqrt((X(i)-X(j))^2+(Y(i)-Y(j))^2);
            a=a+((X(j)-X(i))/r^3);
            b=b+((Y(j)-Y(i))/r^3);
        end
    end
    Eqx(i)=diff(X(i),t,2)==a; 
    Eqy(i)=diff(Y(i),t,2)==b;
end
equazioni=[Eqx Eqy];
[V,S]=odeToVectorField(equazioni);
f=matlabFunction(V, 'vars', {'t','Z','X','Y'});
cond_in=[rand,rand,rand,rand,rand,rand,rand,rand];
tspan=[0,10];
[t,Z]=ode45(@(t,Z) f(t,X,Y),tspan,cond_in);
hold on
for i=1:n
    plot(t,Z(:,i));
end