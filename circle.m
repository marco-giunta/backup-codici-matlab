function h = circle(x,y,r)%coordinate centro+raggio
    hold on
    th = 0:pi/50:2*pi;%theta va da 0 a 2pi con salti piccolini
    xunit = r * cos(th) + x;%se sommi uno scalare a un vettore lui interpreta lo scalare come un vettore costante
    yunit = r * sin(th) + y;%vettori di tutti gli x e y dei punti del cerchio salvati in memoria e poi graficati
    h = plot(xunit, yunit);
    hold off
end
%questa è la soluzione più lenta, intasa la memoria