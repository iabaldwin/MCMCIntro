model.type = 'gaussian';
model.dim  = 2;
model.mu = [-3;-5];
model.A = [2 0; 0 2];
model.gaussian_density = @(x,y) (1/(2*pi()*norm(model.A)))*exp( -.5* ([x;y] - model.mu)'*inv(model.A)*([x;y]-model.mu));
model.density = model.gaussian_density;
model.domain_x1 = [-10 10];
model.domain_x2 = [-10 10];
