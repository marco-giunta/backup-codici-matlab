function C = cerchio(x,y,r)
%CERCHIO grafica un cerchio di centro e raggio noti.
%   C = cerchio(xc,yc,r);
%   Produce l'oggetto C (ParametrizedFunctionLine) e grafica il cerchio di 
%   centro (xc,yc) e raggio r.
%   cerchio(xc,yc,r);
%   Grafica il cerchio di centro (xc,yc) e raggio r.

    hold on
    C=fplot(@(t) r*cos(t)+x,@(t) r*sin(t)+y,[0 2*pi],'Color','black');
    daspect([1,1,1])%setta le unit� relative sui tre assi x,y,z; cos� � come fare axis equal
    hold off
end