function C = circle3(x,y,r)
    %syms theta%angolo simbolico per graficare la funzione simbolica; fplot accetta anche funzioni dichiarate
    %con function handle vari, ma così è più immediato (credo)
    hold on
    %C=fplot(r*cos(theta)+x,r*sin(theta)+y,[0 2*pi],'Color','black');%funzione da graficare,intervallo cui appartiene theta
    C=fplot(@(t) r*cos(t)+x,@(t) r*sin(t)+y,[0 2*pi],'Color','black');
    daspect([1,1,1])%setta le unità relative sui tre assi x,y,z; così è come fare axis equal
    hold off
end


