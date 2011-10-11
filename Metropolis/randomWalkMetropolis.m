function randomWalkMetropolis( numIterations, seed )

if ( nargin ~= 2 )
    disp('Usage:')
    disp('randomWalkMetropolis( numIterations, seed)' )
    disp('numIterations         - maximum iterations')
    disp('seed                  - starting value')
    return;
end

% 1D example
p_sigma     = 1;
p_mu        = 0;

% Q1
q1_sigma    = .1;
q1_mu       = 0;

% Q2
q2_sigma    = 1;
q2_mu       = 0;

% Q3
q3_sigma    = 100;
q3_mu       = 0;


% 3 Different proposal distributions
  
q1_samples = [];
q1_acceptance = 0;
current = seed;
for i = 1:numIterations
    
    prop = current + normrnd(q1_mu, q1_sigma );
    
    a = min( 1, [normpdf( prop, p_mu, p_sigma)/ normpdf( current, p_mu, p_sigma )] );
    
    if ( rand() < a )
        
       % Accept the proposal
        
       current = prop; 
       q1_acceptance = q1_acceptance + 1; 
       
    end
    
    q1_samples(end+1,1) = current;
    
end
q1_acceptance = q1_acceptance/numIterations;


q2_samples = [];
q2_acceptance = 0;
current = seed;
for i = 1:numIterations
    
    prop = current + normrnd(q2_mu, q2_sigma );
    
    a = min( 1, [normpdf( prop, p_mu, p_sigma)/ normpdf( current, p_mu, p_sigma )] );
    
    if ( rand() < a )
        
       % Accept the proposal
        
       current = prop; 
       q2_acceptance = q2_acceptance + 1; 
       
    end
    
    q2_samples(end+1,1) = current;  
    
end
q2_acceptance = q2_acceptance/numIterations;

q3_samples = [];
q3_acceptance = 0;
current = seed;
for i = 1:numIterations
    
    prop = current + normrnd(q3_mu, q3_sigma );
    
    a = min( 1, [normpdf( prop, p_mu, p_sigma)/ normpdf( current, p_mu, p_sigma )] );
    
    if ( rand() < a )
        
       % Accept the proposal
        
       current = prop; 
       q3_acceptance = q3_acceptance + 1; 
  
        
    end
    
    q3_samples(end+1,1) = current;
    
end
q3_acceptance = q3_acceptance/numIterations;

subplot(3,1,1)
plot(1:numIterations, q1_samples, 'r');
ystring = sprintf('%f', q1_acceptance );
ylabel( ystring );
subplot(3,1,2)
plot(1:numIterations, q2_samples, 'b');
ystring = sprintf('%f', q2_acceptance );
ylabel( ystring );
subplot(3,1,3)
plot(1:numIterations, q3_samples, 'g');
ystring = sprintf('%f', q3_acceptance );
ylabel( ystring );


% Display the estimates
e1 = sum(q1_samples)/numel(q1_samples);
e2 = sum(q2_samples)/numel(q2_samples);
e3 = sum(q3_samples)/numel(q3_samples);

disp([ e1 e2 e3]);

end