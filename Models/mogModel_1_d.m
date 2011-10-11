model.type = 'mixture';
model.dim  = 1;
model.wt = [.2; .8];
model.c1 = [-3];
model.A1 = [2];
model.c2 = [9];
model.A2 = [33];
%Evaluations
model.gaussian_density = @(x,mu,A) (1/(2*pi()*det(A)))*exp( -.5* ([x] - mu)'*inv(A)*([x]-mu));
% Mixture of gaussians
model.density = @(x) model.wt(1)*model.gaussian_density(x,model.c1,model.A1) + model.wt(2)*model.gaussian_density(x,model.c2,model.A2);
model.domain_x1 = [-10 20];
