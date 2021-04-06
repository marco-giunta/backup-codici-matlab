%Vogliamo scrivere un sistema del primo ordine della forma:
% (d/dt) theta=f(t,theta,omega,beta,n)
%dove theta è il vettore delle incognite, omega un vettore fissato mediante
%rand, e beta ed n sono due parametri scalari fissati una tantum all'inizio
%(n rappresenta il numero di incognite e pertanto di equazioni).
%Evidentemente l'informazione è contenuta nella funzione f, che viene
%codificata alla fine del codice mediante alcuni cicli; si noti che il
%tempo t va specificato come argomento anche se nella f non appare
%esplicitamente perché per usare ode45 ci serve una dipendenza temporale
%dal parametro t scalare libero. Alla fine del codice "produco" una
%funzione kura che restituisce il vettore f dei secondi membri delle varie
%equazioni in funzione di t, theta, omega, beta, n; nel codice dichiaro dei
%valori specifici per omega=rand..., beta=K con K prefissato, n=N con N già
%dichiarato, e costruisco una funzione secondaria kuraN che dipenda solo da
%t e theta e che numericamente assuma il valore "offerto" da kura valutando
%esplicitamente solo gli ultimi argomenti (quindi solo con t e theta
%indeterminati). Questo passaggio è importante perché ode45 richiede che la
%funzione che gli passiamo dipenda solo dal tempo e dal vettore delle
%incognite, ma non richiede necessariamente una dichiarazione (di kuraN in
%questo caso) a parte; difatti si può fare tutto in un colpo solo
%dichiarando in loco la funzione @(t,theta) kura(t,theta,omega,K,N) anziché
%semplicemente chiamando kuraN (ma in quest'ultimo caso evidentemente non 
%ho bisogno di specificare gli argomenti liberi e quelli già valutati).
%Entrambe le alternative equivalenti sono presenti nel codice (commentate o
%meno). Quello che segue è un utilizzo standard di ode45, deval per
%estrarre i valori numerici dalla struttura soluzione valutati ai tempi
%scelti, e un modo balordo per visualizzare il risultato.
%--------------------------------------------------------------------------
clear all
N=3;
K=0.5;
omega=randn(N,1);
kuraN = @(t,theta) (kura(t,theta,omega,K,N))';
tspan=[0,10];
cond_in=zeros(N,1);
soluzione=ode45(kuraN, tspan, cond_in);
%[T, soluzione] = ode45(@(t,theta) (kura(t,theta,omega,K,N))', tspan, cond_in);
delta_t=linspace(tspan(1),tspan(2));
theta_sol=deval(delta_t,soluzione);
%theta_sol=deval(T,soluzione);
% for i=1:N
%     figure
%     plot(delta_t,theta_sol(i,:));%riga i= theta_i(t)
% end

K=@(t) sin(randn(N,N)*t);
omega=@(t) cos(randn(N,1)*t);
kuraN2 = @(t,theta) (kura2(t,theta,omega(t),K(t),N))';
tspan=[0,10];
cond_in=zeros(N,1);
soluzione=ode45(kuraN2, tspan, cond_in);
delta_t=linspace(tspan(1),tspan(2));
theta_sol=deval(delta_t,soluzione);
%theta_sol=deval(T,soluzione);
for i=1:N
    figure
    plot(delta_t,theta_sol(i,:));%riga i= theta_i(t)
end


%--------------------------------------------------------------------------
function f=kura(t,theta,omega,beta,n)
   for i=1:n
       somma=0;
       for j=1:n
           somma=somma+sin(theta(j)-theta(i));
       end 
       f(i)=omega(i)+(beta/n)*somma;
   end
end

function f=kura2(t,theta,omega,beta,n)
    for i=1:n
       somma(i)=0;
       for j=1:n
           somma(i)=somma(i)+beta(i,j)*sin(theta(j)-theta(i));
       end 
       f(i)=omega(i)+somma(i)/n;
    end
end
