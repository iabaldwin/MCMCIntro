function [samples,estimate] = simulated_annealing( model, maxSamples, start )
% Basic Simulated annealing sampling 

if ( nargin ~= 3 )
    disp('Usage:')
    disp('[samples]             = simulated_annealing( model, maxSamples, seed' )
    disp('model                 - model structure (type whichModel)')
    disp('maxSamples            - maximum samples')
    disp('seed                  - initial value')
    return;
end

if( ~isstruct( model ) )
    error('Erroneous model')
end

if ( model.dim ~= numel(start) )
    error('Inconsistent dimensions')
end

% Sampler parameters
samples = [];
accept = false;
estimate = [];

%T_zero = 100;
%T_final = 1/10;

T_zero = 1;
T_final = 1;

numCoolingSteps = 100;
current = start;

temps = [];

%Proposal distribution:
%   Gaussian
sigma = [ 4 0; 0 4];

for i=1:maxSamples
    
    % Evaluate current probability
    p_z_t = model.density( current(1), current(2) );
    
    % Generate a proposal 
    z_star = mvnrnd( current, sigma );
    
    % Evaluate the candidacy
    p_z_star = model.density( z_star(1), z_star(2) );
    
    % Simulated annealing ratio
    temp = getTemperature( T_zero, T_final, i, numCoolingSteps );
    temps(i,1) = temp;
    
    acceptance_prob = min( 1, (p_z_star/p_z_t)^temp );
    
    % Accept/reject
    r = rand();

    if ( acceptance_prob > r )
        accept = true;
    else
        accept = false; 
    end
    
    if ( accept )
        samples(:, end+1 ) = z_star;
        current = z_star;

        if size( samples,2 ) > 1

            m1 = mean( samples(1,:) );
            m2 = mean( samples(2,:) );

            estimate(:,end+1) = [m1;m2];
        end

    
    end
    
    accept = false;
   
end

% Plot the temperature
figure()
title('Temperature vs. iteration');
plot( temps );

f = figure()
title('Samples vs. temp')
hold on
contourModel( model ,f)
scatter(samples(1,:), samples(2,:), 3, linspace(1,0, numel(samples(1,:))), 'filled');


end

function temp = getTemperature( initial_temperature, final_temperature, time, numSteps )

    temp = max( initial_temperature * ( final_temperature/ initial_temperature )^( time/numSteps ), final_temperature );

end
