clear all
figure
gamma = 1.2;
c = 299792458;
beta = sqrt(1 - 1/gamma^2);
v = beta*c;

r = 1e-3;%valore scelto dal tipo per qualche motivo

omega = v/r;
T = 2*pi/omega;
t = linspace(0,3*T, 300);%scelto dal tipo
x = r*cos(omega*t);
y = r*sin(omega*t);

hold on
axis equal
for n=1:length(t)
    scatter(x(n),y(n),100,'.','red')
    %drawnow limitrate
    pause(0.01)
end
%drawnow