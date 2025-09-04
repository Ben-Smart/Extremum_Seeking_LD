function [T, xol] = All_ODE(dt,Tend,x0,Static_map)
%% Open loop simulation - no inputs
T = linspace(0,Tend,Tend/dt+1); %time span to solve for
    [~,xol] = ode_solver(x0,T,Static_map);

if length(T)==2
    xol = xol([1 end],:);
end

end


function [ t,xout ] = ode_solver(x0,tspan,Static_map)

if Static_map == true
    SM =1;
else
    SM=0;
end
opts = odeset('NonNegative',[4:9]);
[t,xout] = ode89(@f,tspan,[x0 SM],opts);
end


function xdot=f(t,x)
  % Cost function
    J = @(u)(25-(5-(u)).^2)/1e1;
    Static_map = x(10); %this indicates what system is being optimised.
%integrator parameters
[~,k2,k3,delta,gamma,theta] = Para_int(Static_map);

%ES parameters
[k1, A,K] = Para_ES(Static_map);

%Linear approximation of the repressilator parameters 
P_ES = [1,1.380823,20,2.13734,2.13734]';
alpha = P_ES(2);
alpha0 = P_ES(3);
beta = P_ES(4);
%matching the time unit of the represilator to the integrator
speed = 60;% min -> hr


  xdot=zeros(10,1);
  % Integrator
	xdot(1) = k2*x(2)-delta*x(1);

    xdot(2) = J(k1*x(3))*(x(9)-x(5))*K - x(2)*x(3)*theta - gamma*x(2);

    xdot(3) = x(1)*k3 - x(2)*x(3)*theta - gamma*x(3)+(A)*(x(9)-x(5));


     % Dither - Linear Represilator

    xdot(4) = (-x(4) - alpha*x(7) + alpha0)*speed;

	xdot(5) = (-beta*(x(5) - x(4)))*speed;

    xdot(6) = (-x(6) - alpha*x(9) + alpha0)*speed;

	xdot(7) = (-beta*(x(7) - x(6)))*speed;

    xdot(8) = (-x(8) - alpha*x(5) + alpha0)*speed;

	xdot(9) = (-beta*(x(9) - x(8)))*speed;

end