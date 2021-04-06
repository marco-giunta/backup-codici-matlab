function h = circle2(x,y,r)%l'oggetto h prodotto sar� un rettangolo (struttura ad hoc)
    d = r*2;%diametro
    px = x-r;%per fare cerchi con rectangle dobbiamo specificare il pi� piccolo rettangolo che contiene il cerchio
    py = y-r;%quindi questi due punti sono l'estremo in basso a sx di questo rettangolo; poi specifichiamo
    h = rectangle('Position',[px py d d],'Curvature',[1,1]);%dopo px,py specifichiamo larghezza e altezza
    daspect([1,1,1])
end
%il parametro curvatura � un numero da 0 a 1 che riguarda la curvatura
%lungo i lati orizzontali e verticali rispettivamente; mettere [1,1] fa s�
%che il risultato sia un cerchio.
%daspect setta le unit� relative (data aspect ratio) sui 3 assi; mettere
%1,1,1 fa s� che le unit� coincidano e quindi che il nostro cerchio non
%appaia come un ellisse. Equivale a fare axis equal; per invertire questo
%comando bisogna usare daspect auto