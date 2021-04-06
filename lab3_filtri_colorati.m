clear all 
close all
colori=["azzurro","blu","rosso","verde","senza filtro"];
n_col=length(colori);
I=zeros(1280,n_col);%ogni colonna è un colore, composto da 1280 misure

for i=1:n_col
    fid=fopen(strcat(colori(i),".txt"),"r");
    A=fscanf(fid,'%f',[2,inf])';
    lambda=A(:,1);%lambda in nm
    I(:,i)=A(:,2);%intensità relativa
    fclose(fid);
    figure(i)
    plot(lambda,I(:,i))
    title(colori(i))
    xlabel("$\lambda$ (nm)","interpreter","latex")
    ylabel("I relativa (%)")
end

T=I(:,1:n_col-1);
T=T./I(:,n_col);
A=-log(T);

col=["c","b","r","g"];
aree=zeros(n_col-1,1);
C=colori(1:end-1);%stringhe dei colori senza il senza filtro

for i=1:n_col-1
  figure(i+n_col)%conto anche le figure di prima 
  sgtitle(colori(i))%https://www.mathworks.com/help/matlab/ref/sgtitle.html
  subplot(2,1,1)
  plot(lambda,T(:,i),strcat(col(i),"."))%meglio un plot a puntini a causa dei NaN e Inf
  xlabel("$\lambda$ (nm)","interpreter","latex")
  ylabel("T (n. puro)")
  subplot(2,1,2)
  plot(lambda,A(:,i),strcat(col(i),"."))    
  xlabel("$\lambda$ (nm)","interpreter","latex")
  ylabel("A (n. puro)")%rimuovo i NaN e gli Inf; poi integro con i trapezi
  v=rmmissing(T(:,i));
  ind=isfinite(v);
  v=v(ind);
  aree(i)=trapz(v);
  disp(strcat("area sotto T ",colori(i)," (u.a.)=",num2str(aree(i))))
end

[~,ind]=sort(aree);
disp("Filtri dal più efficiente al meno efficiente:")
disp(C(ind))