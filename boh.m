syms c1 c2 k1 k2 m1 m2 t Ftfcn x1(t) x2(t) Y 
%x1''=(F(t)-(c1+c2)*x1'+c2*x2'-(k1+k2)*x1+k2*x2)/m1
Dx1 = diff(x1);
D2x1 = diff(x1,2);
Dx2 = diff(x2);
D2x2 = diff(x2,2);
Eq1 = D2x1 == (Ftfcn-(c1+c2)*Dx1+c2*Dx2-(k1+k2)*x1+k2*x2)/m1
% x2''=(c2*x1'-c2*x2'+k2*x1-k2*x2)/m2
Eq2 = D2x2 == (c2*Dx1-c2*Dx2+k2*x1-k2*x2)/m2
[VF,Subs] = odeToVectorField(Eq1, Eq2)
ftotal = matlabFunction(VF, 'Vars',{t,Y,Ftfcn,c1,c2,k1,k2,m1,m2})
Ftfcn = @(t) sin(t);
c1 = rand;
c2 = rand;
k1 = rand;
k2 = rand;
m1 = rand;
m2 = rand;
ic = zeros(4,1);
tspan = [0,1];
[T,Y] = ode45(@(t,Y) ftotal(t,Y,Ftfcn,c1,c2,k1,k2,m1,m2), tspan, ic);
plot(T, Y)
grid