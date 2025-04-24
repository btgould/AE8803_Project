clear; 
load("obs1.mat");
load("data1.mat");

%% Reachability Calculation

fun = @(x, u) [x(4) * cos(x(3)); x(4) * sin(x(3)); u(1); u(2)]; % x, y, theta, v
sys = nonlinearSys(fun, 4, 2);

params.tStart = T_brk(1);
params.tFinal = T_brk(end-1);
params.R0 = zonotope(Z_brk(:, 1), [0.1, 0.1; -0.1, 0; 0, 0; 0, 0]); % starting states
params.u = U_brk(:, 1:end-1); 
params.U = zonotope([0; 0], [pi / 10; 0.01]); % admissible inputs

options.alg = 'lin'; % use lineariztion
options.timeStep = T_brk(2) - T_brk(1); 
options.tensorOrder = 2;
options.zonotopeOrder = 20; % caps number of generators in zonotope representaiton
options.taylorTerms = 5; % number of taylor terms used to represent sys

R = reach(sys, params, options);

%% Plotting and Verification

O = polytope(O);
mc = simulateRandom(sys, params);

hold on;
plot(R, [1, 2], "DisplayName", "Reachable Set");
plot(params.R0, [1, 2], "LineWidth", 2, "Color", "green", "DisplayName", "Initial Set");
plot(mc, [1, 2], "Color", "#888888", "DisplayName", "Monte Carlo Trajectories");
plot(O, [1, 2], "LineWidth", 2, "Color", "red", "DisplayName", "Obstacle");

legend("Location", "southwest");
title("TurtleBot Reachable Sets")
xlabel("x [m]");
ylabel("y [m]");