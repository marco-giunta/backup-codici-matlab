%Calcolo del Gamma teorico =2*(A1+A2) e confronto con i risultati del fit
clear all
close all
eps0=8.854187e-12;%tutto in SI
h=1.054571e-34;%è h tagliato in realtà
m=9.1093837e-31;%massa elettrone
e=1.602176e-19;
%a=4*pi*eps0*h^2/(m*e^2);
a=4*pi*eps0+h^2/(m^2); %valore sbagliato usato inizialmente
c=299792458;%vel luce SI

lambda0=rydberg(3,2)*1e-9;
omega0=2*pi*c/lambda0;
%omega0=en(2)-en(3);
q1=3.1310;
q2=9.0172;

%p2=q*e^2*a^2;
A = @(q) omega0^3*(q*e^2*a^2)/(3*pi*eps0*h*c^3);
disp("q1=")
disp(q1)
disp("A(q1)=")
disp(A(q1))
%disp("lambda0=")
%disp(lambda0)
disp("q2=")
disp(q2)
disp("A(q2)=")
disp(A(q2))
disp("A tot=")
disp(A(q1)+A(q2))
A_tot=A(q1)+A(q2);
Gamma_teo=2*A_tot;

Gamma_ns=1.0612e13;
Gamma_s=3.1467e13;
disp("Gamma_teo/Gamma_ns=")
disp(Gamma_teo/Gamma_ns)
disp("Gamma_teo/Gamma_s=")
disp(Gamma_teo/Gamma_s)

disp("stima Gamma_c id. non sat.=")
disp(abs(Gamma_ns-Gamma_teo))
disp("stima Gamma_c id. sat.=")
disp(Gamma_s-Gamma_teo)