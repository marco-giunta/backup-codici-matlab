clear all
close all
fid=fopen("faretto_alogeno.txt","r");
A=fscanf(fid,'%f',[2,inf])';
lambda=A(:,1);%lambda in nm
I_faretto=A(:,2);%intensità relativa
fclose(fid);
%plot(lambda,I_faretto)

fid=fopen("incandescenza.txt","r");
A=fscanf(fid,'%f',[2,inf])';
%lambda=A(:,1);%lambda in nm
I_inc=A(:,2);%intensità relativa
fclose(fid);

fid=fopen("led_bianco.txt","r");
A=fscanf(fid,'%f',[2,inf])';
%lambda=A(:,1);%lambda in nm
I_led_bianco=A(:,2);%intensità relativa
fclose(fid);

hold on
plot(lambda,I_inc)
plot(lambda,I_inc./I_led_bianco)
%I_inc_cor_f=I_inc./I_faretto;
%plot(lambda,I_inc_cor_f)
%legend("faretto","inc","inc corr")

p=planck(lambda,2700)*1e-10;
%plot(lambda,p);
%legend("al","inc","planck")



%figure
X=3000;% 3000nm=3 micrometri dorebbero bastare
x=linspace(1,X,X/0.5);
y=planck(x,2700)*1e-10;
%plot(x,y)

figure
ft = fittype( 'planck( x, T )' );
f = fit( lambda, I_inc, ft );
plot( f, lambda, I_inc ) 


figure
hold on
plot(lambda,I_inc)
yp=planck2(lambda,1e-34,1e8,1e-23,1e3)*1e-11;%valori che escono da scipy+rescaling necessario
plot(lambda,yp)
legend("incandescenza","fit")%non truccato

figure
hold on
plot(lambda,I_inc)
plot(lambda,flip(yp))
legend("incandescenza","fit")%truccato. Casomai sposta flip+rescaling in un planck3 a parte


function y=planck(lambda,T)%planckiana
    h=6.626e-34;%cost planck SI
    k=1.38e-23;%cost boltzmann SI
    c=299792458;%vel luce SI
    %f=c*lambda*1e-9;%vettore di frequenze con lambda portata da nm a m
    lambda=lambda*1e-9;
    y=(2*h*c^2)./((lambda).^5.*(exp(h*c./(lambda*k*T))-1));%https://en.wikipedia.org/wiki/Planck%27s_law
end

