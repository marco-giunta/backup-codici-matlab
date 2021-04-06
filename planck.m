function y=planck(lambda,T)%planckiana
    h=6.626e-34;%cost planck SI
    k=1.38e-23;%cost boltzmann SI
    c=299792458;%vel luce SI
    %f=c*lambda*1e-9;%vettore di frequenze con lambda portata da nm a m
    lambda=lambda*1e-9;
    y=(2*h*c^2)./((lambda).^5.*(exp(h*c./(lambda*k*T))-1));%https://en.wikipedia.org/wiki/Planck%27s_law
end