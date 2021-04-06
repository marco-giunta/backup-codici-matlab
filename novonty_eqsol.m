[t,y]=ode45(@novotny,[0 20],[0; 0; 0; 0]);%intervallo di t e condizioni iniziali

plot(t,y(:,1),'-o',t,y(:,2),'-o')
%title('Solution of van der Pol Equation (\mu = 1) with ODE45');
xlabel('Time t');
ylabel('Solution y');
%legend('y_1','y_2')