clear
close all
fidx=fopen("x.txt","r");
fidy=fopen('y.txt','r');
x=fscanf(fidx,'%f',[1,inf])';
y=fscanf(fidy,'%f',[1,inf])';
fclose(fidx);
fclose(fidy);
z=complex(x,y);
plot(z)
axis equal

N=length(z);
Z=fft(z)/N;
raggi=abs(Z);
fasi=angle(Z);
freq=0:N-1;
[raggi,indici]=sort(raggi,'descend');
Z=Z(indici);
fasi=fasi(indici);
freq=freq(indici);

h = figure;
handle = axes('Parent',h);
hold on
axis equal
wave = [];
n=1;%numero di ripetizioni della figura

axis([500 1400 -1100 0])%per non dover fare zoom
%j=1;

for t=0:(2*pi/N):2*pi*n
    x=0;
    y=0;
    for i=1:N
        prevx=x;
        prevy=y;
        x=x+raggi(i)*cos(freq(i)*t+fasi(i));
        y=y+raggi(i)*sin(freq(i)*t+fasi(i));
        centri(i,:) = [prevx, prevy];
        segmenti(i,:) = [prevx, x, prevy, y];
    end
    wave = [wave; [x,y]];
    cla
    viscircles(handle, centri, raggi, 'Color', 0.5 * [1, 1, 1], 'LineWidth', 0.1);
    plot(handle, wave(:,1), wave(:,2), 'k', 'LineWidth', 2);
    plot(handle, segmenti(:,1:2), segmenti(:,3:4), 'Color', 0.1*[1 1 1], 'LineWidth', 0.1);
    plot(handle, x, y, 'or', 'MarkerFaceColor', 'r');
    %pause(0.025);
    %pause(0.05);
    drawnow limitrate
    
    %set(gcf, 'PaperPositionMode', 'auto')%da decommentare per salvare
    %print(gcf, ['fourier_ritratto' '_' num2str(j) '.png'], '-dpng', '-r150')
    %j=j+1;
   
end
drawnow