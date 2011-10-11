model.type = 'mixture';
model.dim  = 2;
model.wt = [.1; .9];
model.c1 = [-3;-5];
model.A1 = [5 0; 0 5];
model.c2 = [4;9];
model.A2 = [.2 0; 0 .2];
%Evaluations
model.gaussian_density = @(x,y,mu,A) (1/(2*pi()*det(A)))*exp( -.5* ([x;y] - mu)'*inv(A)*([x;y]-mu));
% Mixture of gaussians
model.density = @(x,y) model.wt(1)*model.gaussian_density(x,y,model.c1,model.A1) + model.wt(2)*model.gaussian_density(x,y,model.c2,model.A2);
% Ground-truth data
model.E = model.wt(1)*model.c1 + model.wt(2)*model.c2;
% useful values 
model.domain_x1 = [-15 15];
model.domain_x2 = [-15 15];