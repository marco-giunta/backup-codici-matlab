%funzione per il calcolo delle lunghezze d'onda in nm del fotone emesso
%secondo la formula di Rydberg (atomo di deuterio). 
%Passagli i numeri quantici principali dei livelli coinvolti nella 
%transizione. Vanno bene sia i processi di
%emissione che assorbimento, ho messo un abs() a posta
function lambda=rydbergD(n1,n2)
    R=1.09722267e7;%valore con massa ridotta idrogeno
    lambda=1e9/(R*abs((n1^-2)-(n2^-2)));%lambda in nm
end