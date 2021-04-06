syms x10 x20
syms omega
subs(equazioni, [x1 x2], [x10*exp(1i*omega*t) x20*exp(1i*omega*t)])
simplify(equazioni)
equazioni_sost=subs(equazioni, [x1 x2], [x10*exp(1i*omega*t) x20*exp(1i*omega*t)])
equazioni_sost=simplify(equazioni_sost)
variabili=[x10 x20];
[A,b]=equationsToMatrix(equazioni_sost,variabili)
[autovettori,autovalori]=eig(A)