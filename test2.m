clear
n=4;
syms t;
x=sym('x', [n 1]);
y=sym('y', [n 1]);
eqx=sym('eq', [n 1]);
eqy=sym('eq', [n 1]);
for i=1:n
    a=0;
    b=0;
    for j=1:n
        if j~=i
            r=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            a=a+((x(j)-x(i))/r^3);
            b=b+((y(j)-y(i))/r^3);
        end
    end
    eqx(i)=diff(x(i),t,2)==a; 
    eqy(i)=diff(y(i),t,2)==b;
end
