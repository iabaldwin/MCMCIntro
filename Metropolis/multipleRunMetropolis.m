function [samples] = multipleRunMetropolis( model, maxSamples, numChains, seeds )

if ( nargin ~= 4 )
    disp('Usage:')
    disp('[samples]     = multipleRunMetropolis( model, maxSamples, numChains, seeds' )
    disp('model         - model structure (type whichModel)')
    disp('maxSamples    - maximum samples')
    disp('seed          - initial value')
    disp('animate       - demo')
    
    return;
end

if ( ~isstruct(model) )
    disp('Erroneous model')
    return;
end

if ( isempty(seeds) )
    seeds = [];   
    % Place the seeds randomly
    for i = 1:numChains
        
        pos(1) = rand*( model.domain_x1(2) - model.domain_x1(1)) + model.domain_x1(1);
        pos(2) = rand*( model.domain_x2(2) - model.domain_x2(1)) + model.domain_x2(1);
        
        seeds(:,end+1) = pos;
    end
    
       
end

samples = {};

for i=1:numChains
    % For each chain, do metropolis
    data = metropolis( model, maxSamples, seeds(:,i), 3, false );
    
    samples{i} = data;
    
    fprintf('Done %d chains\n', i );
end

% Plotting
figure()
hold on
axis([ model.domain_x1(1) model.domain_x1(2) model.domain_x2(1) model.domain_x2(2)])

sampleVal = 50;

for i = 1:numel( samples )
    
    data = samples{i};
    
    sampledData = [];
    
    %for j = 2:numel(data(1,:))
    for j = 2:20
    
        sampledData = [sampledData [linspace( data(1,j-1), data(1,j), sampleVal);linspace( data(j-1), data(2,j), sampleVal) ] ]; 
        
    end
    
   
    scatter( data(1,:), data(2,:), 5, linspace(0,1,numel(data(1,:))), 'filled');
    scatter( sampledData(1,:), sampledData(2,:), 5, 'filled');
    
end

plot( seeds(1,:), seeds(2,:), '+r', 'MarkerSize', 15 );
seeds

hold off

