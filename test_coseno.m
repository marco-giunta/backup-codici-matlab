clear
clf
syms y(x)
eq = diff(y,2) == -y(x);
[V,S]=odeToVectorField(eq);
f=matlabFunction(V, 'vars', {'x','Y'});
cond_in=[1,0];
intervallo=[0,4*pi];
Y=ode45(@(t,Y) f(x,Y),intervallo,cond_in);
T=linspace(0,4*pi);
coseno=deval(Y,T);
plot(T,coseno);
%oppure singolarmente per essere ancora pi� sicuri che la prima riga �
%y=cos(x) mentre la seconda � y'(x)=-sen(x) - ha molto senso fornire sia y
%che y', y'' � nota dall'equazione e avere solo y pu� non bastare perch�
%comunque non lo si pu� derivare facilmente ottenendo y' in assenza di una
%espressione analitica
figure;
plot(T,coseno(1,:));
hold on;
plot(T,coseno(2,:));
legend('y=cos(x)','y=-sen(x)');
%cos� � ancora pi� esplicito!
figure;
plot(Y.x,Y.y(1,:));
hold on;
plot(Y.x,Y.y(2,:));
%se grafichiamo direttamente la struttura dati soluzione offerta da ode 45
%(che ha come componente x l'input a cui viene valutata la soluzione e come
%componente y due righe: la prima evidentemente � y e la seconda y') spunta
%fuori una figura spigolosa perch� ode45 calcola la soluzione "a campione"
%ogni tanto; invece deval contiene una funzione che fa una interpolazione
%in modo da produrre una funzione continua e pertanto una curva liscia -
%ecco perch� conviene usarlo!