clear all
N=5; %t=0:0.05:10
% for t=0:0.1:10 %quello di coding train evidentemente non può essere 
%     x=0;        %riciclato come se niente fosse
%     y=0;
%     for i=1:N
%         prevx=x;
%         prevy=y;
%         j=2*i-1;
%         r=4/(j*pi);
%         x=x+r*cos(j*t);
%         y=y+r*sin(j*t);
%         cerchio(prevx,prevy,r);
%         segmento(prevx,prevy,x,y);
%     end
%     %pause(0.001);
%     drawnow limitrate
% end
% drawnow

%hold on
%syms x t
%f=@(x) 0
%for i=1:N
%    f=f+
%end

h = figure;
handle = axes('Parent',h);
hold on
axis equal
wave = [];

for i=1:N
    raggi(i)=4/(i*pi);
end
%loops = 200;
%M(loops) = struct('cdata',[],'colormap',[]);
for t=0:0.1:20
    x=0;
    y=0;
    for i=1:N
        prevx=x;
        prevy=y;
        j=2*i-1;
        x=x+raggi(i)*cos(j*t);
        y=y+raggi(i)*sin(j*t);
        centri(i,:) = [prevx, prevy];
        segmenti(i,:) = [prevx, x, prevy, y];
    end
    wave = [wave; [t+1.5,y]];%io
   %wave = [wave; [x,y]];%formalismo complesso (lui)
    cla
    viscircles(handle, centri, raggi, 'Color', 0.5 * [1, 1, 1], 'LineWidth', 0.1);
    %plot(x,y,'b*')%manca l'handle, che penso serva a causa di viscircles
    plot(handle, wave(:,1), wave(:,2), 'k', 'LineWidth', 2);
    plot(handle, segmenti(:,1:2), segmenti(:,3:4), 'Color', 0.1*[1 1 1], 'LineWidth', 0.1);%x1,x2,y1,y2
    plot(handle, x, y, 'or', 'MarkerFaceColor', 'r');
    plot([x,t+1.5],[y,y],'Color','k');%io
    %M=getframe(handle);
    pause(0.025);
end
%movie(M);