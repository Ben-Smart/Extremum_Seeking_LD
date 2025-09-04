function [alpha,beta,n,alpha0] = Para_osc

Parameter = [112,3,2,1e-3*112];

para = Parameter(1,:);
alpha = para(1);
beta = para(2);
n = para(3);
alpha0 = para(4);

end