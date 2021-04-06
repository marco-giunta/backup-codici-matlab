clear all
syms A B C omega x a b c
a=4-C^2;
b=-16*omega^2+2*A*C+2*omega^2*C^2+B^2+4*omega*B*C;
b=-b;
c=-((A-omega*B)^2+omega^3*C*(omega*C-2*B));
% eq=a*x^2+b*x+c==0;
% s=solve(eq,x);
% s=simplify(s,100);
% disp(s)
f = @(y) a*y^4+b*y^2+c;
lambda=(A-omega*B-omega^2*C)/(4*omega);
r=f(lambda);
r=simplify(r,100);
disp(r)