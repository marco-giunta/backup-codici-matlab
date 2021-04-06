clear
clf
delta_t=500;
enne=4
n=10000;
om(1)=1.0;
delta_om=1.;
dom=delta_om/(enne-1);
for i=2:enne
om(i)=om(i-1)+dom;
end 
dt=delta_t/n;
for i=1:n
    t=dt*(i-1);
    clf
    for j=1:enne
    x=cos(om(j)*t);
    y=sin(om(j)*t);
    plot(x,y,'.','markersize',40+j*(40/enne))
    axis([-1.1 1.1 -1.1 1.1])
    hold on
    end
    pause(0.0001)
end 

    