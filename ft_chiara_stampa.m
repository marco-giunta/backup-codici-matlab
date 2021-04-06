clear all
fid=fopen("chiara.txt","r");
% fid=fopen('coordinate.txt');
A=fscanf(fid,'%f',[2,inf])';
x=A(:,1);
y=A(:,2);
fclose(fid);
z=complex(x,y);
%plot(z)
N=length(z);
Z=fft(z)/N;
fid=fopen("chiara_stampa.txt","w");
%fprintf(fid,'%f %f\n',M);
for i=1:length(Z)
    fprintf(fid,'%f +%f i\n',real(Z(i)),imag(Z(i)));
end
fclose(fid);