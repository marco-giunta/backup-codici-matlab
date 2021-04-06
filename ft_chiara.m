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
end
drawnow