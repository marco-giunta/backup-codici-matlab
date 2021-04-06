clear
close all
fid = fopen('c.txt');
A = fscanf(fid,'%f',[3,inf])';
fclose(fid);
B=xyz2grid(A(:,1),A(:,2),A(:,3));
