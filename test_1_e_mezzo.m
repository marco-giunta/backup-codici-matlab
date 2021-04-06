clear
n=4;
syms t;
syms x(t) y(t) [n 1];
%x=sym('x', [n 1]);
%y=sym('y', [n 1]); %per avere accesso ai coefficienti del vettore bisogna riempirlo "dopo" di sym, non prima!
X=x(t);%https://it.mathworks.com/matlabcentral/answers/410630-how-to-call-element-of-matrix-of-symbolic-variables
Y=y(t);%questo è il trucco: x e y sono funzioni simboliche "in blocco", inaccessibili nelle componenti, ma le matrici X e Y pur coincidendo con esse sono delle matrici a tutti gli effetti e pertanto posso chiamare mediante indice le loro componenti!
for i=1:n
    X(i)=cos(t)^i;
    Y(i)=sin(t)^i;
end
%x=subs(x) non servono più facendo in quel modo! serve con syms, non sym
%y=subs(y)
ax=diff(X,2);
ay=diff(Y,2);
disp(X); disp(Y); disp(ax); disp(ay);