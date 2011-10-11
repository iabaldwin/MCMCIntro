% Display the density function we are going to sample from

% mu = [1; 1];
% A = [1 0; 0 1];


% Function handles

% Gaussian density
density = @(x,y,mu,A) (1/(2*pi()*norm(A)))*exp( -.5* ([x;y] - mu)'*inv(A)*([x;y]-mu));
% MOG
% wt = [.2; .8];
wt = [.5; .5];

c1 = [-3;-5];
A1 = [2 0; 0 2];
c2 = [4;9];
A2 = [3 1; 1 3];
mog = @(x,y) wt(1)*density(x,y,c1,A1) + wt(2)*density(x,y,c2,A2);


figure()
hold on

data = [];

for x =-10:.5:10
    
    for y = -10:.5:10
        
        f = mog(x,y);
        
        
        data(end+1,:) = [x,y,f];
        
    end
end

[s,i] = sort( data(:,3) );
srt = data(i,:);


scatter3(srt(:,1),srt(:,2),srt(:,3),5,linspace(0,1,numel(srt(:,1))),'filled');       
        
