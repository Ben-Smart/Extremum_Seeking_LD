function [k1, A,K] = Para_ES(Static_map)


if Static_map == 1
% Use as starting point for static maps
k1 = 0.07;
A = 0.1;
K = 175;
else
% Use as a starting point for the LD system
k1 = 0.035;
A = 0.1;
K = 50;
end

end