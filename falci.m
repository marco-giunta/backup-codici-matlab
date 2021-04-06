f=@(x,T)exp(-x^2/T)/T^(3/2);
f10=@(x) f(x,10);
fplot(f10);