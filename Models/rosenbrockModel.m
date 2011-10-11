model.type = 'functional';
model.dim  = 2;
% Rosenbrock function
model.density = @(x,y) inv( (1-x)^2 + 100*(y-x^2)^2 + 1 );
model.function = @(x,y) (1-x)^2 + 100*(y-x^2)^2;
% Ground-truth data
model.min = [1;1];
% useful values 
model.domain_x1 = [-5 5];
model.domain_x2 = [-5 5];