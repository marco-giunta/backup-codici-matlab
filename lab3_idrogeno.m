clear all 
close all
fid=fopen("idrogeno.txt","r");
A=fscanf(fid,'%f',[2,inf])';
lambda=A(:,1);%lambda in nm
I=A(:,2);%intensità relativa
fclose(fid);
fid=fopen("idrogeno_saturato.txt","r");
A=fscanf(fid,'%f',[2,inf])';
%lambda=A(:,1);%lambda in nm
I_s=A(:,2);%intensità relativa
fclose(fid);

plot(lambda,I)
%findpeaks(I)%metterlo sballa l'asse x nella rappresentazione
grid on
title("idrogeno")
xlabel("$\lambda$ (nm)","interpreter","latex")
ylabel("I relativa (%)")

figure
plot(lambda,I_s)
%findpeaks(I_s)
grid on
xlabel("$\lambda$ (nm)","interpreter","latex")
ylabel("I relativa (%)")
title("idrogeno saturato")

%disp("n. valori con I>5 idrogeno:")
%disp(nnz(I>5))
%disp("n. valori con I>5 idrogeno saturato:")
%disp(nnz(I_s>5))

ind=find(I>5);
ind_s=find(I_s>1.6);%si vede una riga debole all'inizio che corrisponde a tipo 1.9 di intensità; 
%gli altri picchetti li scarto perché nella foto evidentemente non
%corrispondono a righe ma a rumore
%ignora il picchetto con indice 420, non si vede una riga, solo quello a
%148 è onesto


x=lambda(594:706)*1e-9;%isolo la riga dominante
y=I_s(594:706);
c=299792458;%vel luce SI
omega=flip(2*pi*c./x);
%y_omega=2*pi*c*flip(y)./(omega.^2);%jacobiano trasformazione...?
y_omega=flip(y);%lavoro con le frequenze
%devo invertire l'asse x se no è decrescente e di conseguenza pure y
%se no non c'è più corrispondenza di ogni punto con la sua coordinata orizzontale

f=@(p,omega) ((1/(2*pi))*p(1)/((omega-p(2)).^2+(p(1)/2)^2))';%lorentziana; senza trasposto sotto non gli piace
p0=[8e13,2.89e15];%gamma e omega0; stima parametri iniziali. Stimo gamma con delta omega(che lo maggiora) e omega0 con rydb.
%pfit = nlinfit(omega,y_omega,f,p0);
[pfit,R,J,CovB] = nlinfit(omega,y_omega,f,p0);
gamma=pfit(1);
disp("gamma fit (Hz):")
disp(gamma)
disp("delta omega a occhio (Hz): 8.4e13")

omega0=pfit(2);
disp("omega0 fit (Hz):")
disp(omega0)

lambda0=1e9*2*pi*c/omega0;
disp("lambda0 fit (nm):")
disp(lambda0)
t=rydberg(3,2);
disp("valore teorico per la transizione 3->2 (nm):")
disp(t)
dperc=100*abs(t-lambda0)/t;
disp("discrepanza percentuale:")
disp(dperc)

% [ypred,delta] = nlpredci(f,mean(omega),pfit,R,'Jacobian',J,"Covar",CovB);
% %[ypred,delta] = nlpredci(f,mean(omega),pfit,R,'Jacobian',J);
% v=[ypred-delta,ypred+delta];
% disp("Confidence Interval:")
% disp(v)%niente, inventa

%niente, così vengono errori improponibili di 1e30...
% errori=sqrt(diag(CovB));%sono gli errori standard sui parametri del fit; non mi è chiarissimo di cosa si tratti
% %ma almeno come stima dovrebbero andare bene, penso... sono tipo delle
% %deviazioni standard modificate in qualche modo
% v_gamma=[gamma-errori(1),gamma+errori(1)];
% v_omega0=[omega0-errori(2),omega0+errori(2)];
% disp("Intervallo gamma:")
% disp(v_gamma)
% disp("Intervallo omega0:")
% disp(v_omega0)

% %-----------Plot della lorentziana che però sembra non funzionare----------
figure
hold on
plot(omega,y_omega)
%plot(omega,1000*f(pfit,omega))
Y=f(pfit,omega);
g=@(x) ((gamma/(4*pi))./(x-omega0).^2);
v=1e13*g(omega);
plot(omega,v)


figure
hold on
V=((gamma/(4*pi))./((omega-omega0).^2+1e15));
plot(omega,V,"g")
plot(omega,v+rand(size(v)),"b.:")
% 
% GAMMA=1e-12*gamma;%THz
% OMEGA0=1e-12*omega0;%faccio a parte anziché comprimere nella F per chiarezza
% OMEGA=1e-12*omega;
% F = @(x) ((GAMMA/(2*pi))/((x-OMEGA0).^2+(GAMMA/2)^2))';
% plot(OMEGA,F(OMEGA))

