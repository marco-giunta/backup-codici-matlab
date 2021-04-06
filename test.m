clear
n=4;
syms t;
%syms x(t) y(t) [n 1];
x=sym('x', [n 1]);
y=sym('y', [n 1]); %per avere accesso ai coefficienti del vettore bisogna riempirlo "dopo" di sym, non prima!
%x
%y
for i=1:n
    x(i)=cos(t)^i;
    y(i)=sin(t)^i;
end
%x=subs(x) non servono più facendo in quel modo! serve con syms, non sym
%y=subs(y)
ax=diff(x,2);
ay=diff(y,2);
