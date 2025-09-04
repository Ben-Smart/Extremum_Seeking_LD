function [k1,k2,k3,delta,gamma,theta] = Para_int(Static_map)

%use as a starting point for a static map
k1 = 1;
k2 = 0.2;
k3 = 1;
delta = 1;
gamma = 0;0.001;

if Static_map == 1
theta = 0.001;
else
%use as a starting point for the LD system - this is tuning the integrator
%to increase its speed of integration. This should be adjusted for the
%timescale of the ODE system. 
theta = 0.01;

end