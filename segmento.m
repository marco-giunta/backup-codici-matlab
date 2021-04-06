function S=segmento(x1,y1,x2,y2);
%SEGMENTO grafica un segmento di estremi noti.
%   S = segmento(x1,y1,x2,y2);
%   Produce l'oggetto S (Line) e grafica il segmento di 
%   estremi (x1,y1) e (x2,y2).
%   segmento(x1,y1,x2,y2);
%   Grafica il segmento di estremi (x1,y1) e (x2,y2).

    hold on
    x=[x1 x2];
    y=[y1 y2];
    S=line(x,y);
    hold off
end