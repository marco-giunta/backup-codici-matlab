clf;
a=input("Per favore inserisci la semiampiezza dell'intervallo [-a,a] cui apparterranno x e y");

risposta = questdlg('Vuoi misurare il tempo di esecuzione?', ... 
        'Misura del tempo di esecuzione', ...
	'Sì','No','No');
switch risposta
    case 'Sì'
        disp("Parte il cronometro!");
        tic;
    case 'No'
        disp("Non parte il cronometro!");
end

[X,Y] = meshgrid(-1*a:0.1:a,-1*a:0.1:a);%il mesh di 0.1 è già abbastanza fine
Z=log(X+1i.*Y);
surf(X,Y,real(Z));
xlabel("Re z");
ylabel("Im z");
zlabel("Re ln(z)");
%hold on;
figure;
surf(X,Y,imag(Z));
xlabel("Re z");
ylabel("Im z");
zlabel("Im ln(z)");

if(risposta=="Sì")
    disp(toc);
end