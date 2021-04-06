clear all
clf
f=@(x,T) x^2*exp(-x^2/T)*T^(-1.5);
%f10=@(x) f(x,10);
%fplot(f10);
hold on
for t=1:4
    fplot((@(x) f(x,t)),[0,5]);
end