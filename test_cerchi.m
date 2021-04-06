%clear
clear all
N=1000; %con N=1000 cerchi 1 ci mette tipo 1.4533, cerchi 2 tipo 0.3912;
%stesso pattern per N minori. Pertanto cerchi 2 è meglio sperimentalmente!
%con N=5000 1 6.3341, 2 1.8661
%N=10000 1 12.2956, 2 3.6530
centri=linspace(0,10,N);%x, y è 0, r=1
test1=0;
if test1==1
    tic
    for i=1:length(centri)
        circle(centri(i),0,1);
    end
    %circle(centri,0,1);
    t=toc;
    daspect([1,1,1]);  
    disp('cerchi 1: ')
    disp(t);
    figure
end

tic
for i=1:length(centri)
    circle2(centri(i),0,1);
end
%circle2(centri,0,1);
t=toc;
daspect([1,1,1]);
disp('cerchi 2: ')
disp(t);
%in più 2 mette sempre lo stesso colore perché specificato ad hoc,
%fantastico
%giustamente è ragionevole che vinca 2: 1 fa un numero arbitrariamente
%grande di conti perché matlab è costretto a farli manualmente, mentre
%rectangle se lo gestisce come vuole e quindi lavora meglio
%forse c'entra anche il fatto che 2 non ha bisogno di hold on/off a
%ripetizione
%adesso aggiungo 3 con fanimator e le variabili simboliche:
figure
tic
for i=1:length(centri)
    circle2(centri(i),0,1);
end
%circle2(centri,0,1);
t=toc;
daspect([1,1,1]);
disp('cerchi 3: ')
disp(t);
%PUNTEGGI AGGIORNATI:
%N=1000 1: 1.4038, 2: 0.3838, 3: 0.3836
%N=5000 1: 6.3974, 2: 1.8469, 3: 1.8469
%N=10000 1: 12.6015, 2: 3.6470, 3: 3.7224
%N=20000 1: 25.2132, 2: 7.2549, 3: 7.2494
%N=100000 1: N/A, 2: 38.7956, 3: 37.3292
%N=200000 1: N/A, 2: 73.0720, 3: 73.3092
%quindi evidentemente non differiscono in modo significativo, magari perché
%funzionano allo stesso modo... Se non altro il 2 mi evita gli hold on/off,
%entrambi tengono lo stesso colore 

%ATTENZIONE: ho modificato il 3 per non dover ricorrere all'engine
%simbolico, riprovo
%N=1000 2: 0.4725, 3: 0.3680
%N=10000 2: 3.7620, 3: 3.6079
%N=20000 2: 7.2992, 3: 7.2125
%N=50000 2: 
%quindi il tre sembra migliore