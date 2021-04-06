clear
clf
delta_t=300;
enne=5
n=10000;
om(1)=10.0;
delta_om=1.;
dom=delta_om/(enne-1);
for i=2:enne
om(i)=om(i-1)+dom;
end 
dt=delta_t/n;
for i=1:n
    t(i)=dt*(i-1)-delta_t/5;
    x(i)=0.;
    for j=1:enne
    x(i)=x(i)+cos(om(j)*t(i));
    end
end 
subplot(2,1,1)
plot (t,x,'linewidth',1)
axis([-delta_t/5 delta_t+dt -enne*(1+0.1) enne*(1+0.1)])
%pause
%clf
for i=1:n
    x2(i)=x(i)*x(i);
end
subplot(2,1,2)
plot (t,x2,'linewidth',1)
axis([-delta_t/5 delta_t+dt -0.2 enne^2+enne])