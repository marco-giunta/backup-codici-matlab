clear
clf
delta_t=100;
n=10000;
om1=input('omega 1 ');
om2=input('omega 2 ');
a1=input('a1 ');
a2=input('a2 ');
%om1=1;
dom=0.05;
om2=om1+dom;
t=linspace(0,delta_t,n);
x=a1*cos(om1*t)+a2*cos(om2*t);
    plot (t,x,'linewidth',3)
    axis([0 delta_t -(a1+a2+.1) (a1+a2+.1)])