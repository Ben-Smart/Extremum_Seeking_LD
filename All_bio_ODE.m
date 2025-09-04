function [T, xol] = All_bio_ODE(dt,Tend,x0, Static_map)
%% Open loop simulation - no inputs
T = linspace(0,Tend,Tend/dt+1); %time span to solve for
    [~,xol] = ode_solver(x0,T, Static_map);

if length(T)==2
    xol = xol([1 end],:);
end

end


function [ t,xout ] = ode_solver(x0,tspan,Static_map)
opts = odeset('NonNegative',1:17);
if Static_map == true
    SM =1;
else
    SM=0;
end

[t,xout] = ode23(@f,tspan,[x0,SM],opts);
end

function xdot=f(t,x)
  % Cost function
    %J = @(u)(25-(5-(u)).^2)/1e1;
Static_map = x(18);
[~,k2,k3,delta,gamma,theta] = Para_int(Static_map);

[k1, A, K] = Para_ES(Static_map);

P_ES = [1,1.380823,20,2.13734,2.13734]';
alpha = P_ES(2);
alpha0 = P_ES(3);
beta = P_ES(4);

[mu1,mu2,kld1,kld2,w1,w2,kw1,kw2,gamma1,gamma2,Kb1,Kb2,kb1,kb2,Kab,D,s0,phi,v1,km,Cn,Cb,Ca] = Para_bio;


speed = 60;% min to hr
slow = 1;

  xdot=zeros(18,1);
  % Integrator
	xdot(1) = k2*x(2)-delta*x(1);

	xdot(2) = (x(17))*(x(5)-x(7))*K - x(2)*x(3)*theta - gamma*x(2);

    xdot(3) = x(1)*k3 - x(2)*x(3)*theta - gamma*x(3)+(A)*(x(5) - x(7));
  
   % Dither - Linear approximation of the represilator

    xdot(4) = (-x(4) - alpha*x(7) + alpha0)*speed;

	xdot(5) = (-beta*(x(5) - x(4)))*speed;

    xdot(6) = (-x(6) - alpha*x(9) + alpha0)*speed;

	xdot(7) = (-beta*(x(7) - x(6)))*speed;

    xdot(8) = (-x(8) - alpha*x(5) + alpha0)*speed;

	xdot(9) = (-beta*(x(9) - x(8)))*speed;
    

    % LD production - to be optimised

    xdot(10) = (mu1.*(x(12).*x(10))./(kld1 + x(12)) - w1.*(x(13).*Cb.*x(10))./(kw1 + x(13).*Cb) - x(10).*D)*slow;

    xdot(11) = (mu2.*(x(12).*x(11))./(kld2 + x(12)) - w2.*(x(14).*Cb.*x(11))./(kw2 + x(14).*Cb) - x(11).*D)*slow;

    xdot(12) = (D.*(s0-x(12)) - (mu1/gamma1).*(x(12).*x(10).*Cn)./(kld1 + x(12)) - (mu2/gamma2).*(x(12).*x(11).*Cn)./(kld2 + x(12)))*slow;

    xdot(13) = (Kb1.*(kb1.*x(10).*Cn)./((kb1 + x(15)).*Cb) - x(13).*D)*slow;

    xdot(14) = (Kb2.*(kb2.*x(11).*Cn)./((kb2 + x(15)).*Cb) - x(14).*D)*slow;

    xdot(15) = (Kab.*k1*x(3).*x(10).*Cn./Ca - x(15).*D)*slow;

    xdot(16) = (phi.*mu1.*(x(12).*x(10))./(kld1 + x(12)) - v1.*(x(16).*x(11))./(km + x(16)) - x(16).*D)*slow;

    xdot(17) = (v1.*(x(16).*x(11))./(km + x(16)) - x(17).*D)*slow;
end