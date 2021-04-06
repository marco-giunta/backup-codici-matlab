clear
%https://it.mathworks.com/help/symbolic/examples/animation-and-solution-of-double-pendulum.html
syms theta_1(t) theta_2(t) L_1 L_2 m_1 m_2 g
x_1 = L_1*sin(theta_1);
y_1 = -L_1*cos(theta_1);
x_2 = x_1 + L_2*sin(theta_2);
y_2 = y_1 - L_2*cos(theta_2);
vx_1 = diff(x_1);
vy_1 = diff(y_1);
vx_2 = diff(x_2);
vy_2 = diff(y_2);
ax_1 = diff(vx_1);
ay_1 = diff(vy_1);
ax_2 = diff(vx_2);
ay_2 = diff(vy_2);
syms T_1 T_2
eqx_1 = m_1*ax_1(t) == -T_1*sin(theta_1(t)) + T_2*sin(theta_2(t))
eqy_1 = m_1*ay_1(t) == T_1*cos(theta_1(t)) - T_2*cos(theta_2(t)) - m_1*g
eqx_2 = m_2*ax_2(t) == -T_2*sin(theta_2(t))
eqy_2 = m_2*ay_2(t) == T_2*cos(theta_2(t)) - m_2*g
Tension = solve([eqx_1 eqy_1],[T_1 T_2]);%risolve il sistema in 4 incognite rispetto alla tensione 1 e 2
eqRed_1 = subs(eqx_2,[T_1 T_2],[Tension.T_1 Tension.T_2]);%sostituisce le tensioni trovate in modo da avere solo 2 incognite
eqRed_2 = subs(eqy_2,[T_1 T_2],[Tension.T_1 Tension.T_2]);%idem
L_1 = 1;
L_2 = 1.5;
m_1 = 2;
m_2 = 1;
g = 9.8;
eqn_1 = subs(eqRed_1)
eqn_2 = subs(eqRed_2)
[V,S] = odeToVectorField(eqn_1,eqn_2);%riduce al prim'ordine
S
M = matlabFunction(V,'vars',{'t','Y'});%traduce la funzione simbolica in una numerica comprensibile a ode45
initCond = [pi/4 0 pi/6 0];
sols = ode45(M,[0 10],initCond);%così esce fuori una struttura dati
plot(sols.x,sols.y)%infatti per fare il plot devo pescare i pezzi della struttura
legend('\theta_2','d\theta_2/dt','\theta_1','d\theta_1/dt')
title('Solutions of State Variables')
xlabel('Time (s)')
ylabel('Solutions (rad or rad/s)')
figure;
x_1 = @(t) L_1*sin(deval(sols,t,3));
y_1 = @(t) -L_1*cos(deval(sols,t,3));
x_2 = @(t) L_1*sin(deval(sols,t,3))+L_2*sin(deval(sols,t,1));
y_2 = @(t) -L_1*cos(deval(sols,t,3))-L_2*cos(deval(sols,t,1));
fanimator(@(t) plot(x_1(t),y_1(t),'ro','MarkerSize',m_1*10,'MarkerFaceColor','r'));
axis equal;
hold on;
fanimator(@(t) plot([0 x_1(t)],[0 y_1(t)],'r-'));
fanimator(@(t) plot(x_2(t),y_2(t),'go','MarkerSize',m_2*10,'MarkerFaceColor','g'));
fanimator(@(t) plot([x_1(t) x_2(t)],[y_1(t) y_2(t)],'g-'));
fanimator(@(t) text(-0.3,0.3,"Timer: "+num2str(t,2)));
hold off;
playAnimation;