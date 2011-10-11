model.type = 'functional';
model.dim  = 1;
model.k = 9;
model.theta = .5;
% Gamma distributed
model.density = @(x) gampdf( x, model.k, model.theta );
% useful values 
model.domain_x1 = [0 10];
