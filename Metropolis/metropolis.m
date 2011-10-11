function [samples, rejectionRatio] = metropolis( model, maxSamples, seed, proposal_variance, animate )
% Basic Metropolis (symmetric) sampling 

if ( nargin ~= 5 )
    disp('Usage:')
    disp('[samples,rej_ratio    = metropolis( model, maxSamples, seed, proposal_variance, animate)' )
    disp('model                 - model structure (type whichModel)')
    disp('maxSamples            - maximum samples')
    disp('seed                  - initial value')
    disp('proposal variance     - variance for the Gaussian proposal distribution')
    disp('animate               - animate the process');
    return;
end


if( ~isstruct( model ) )
    error('Erroneous model')
end

% Sampler parameters
samples = [];
accept = false;
rejections = 0;

%Isotropic proposal distribution:
%   Gaussian
if ( proposal_variance < 0 )
    error('Erroneous variance!')
end

sigma = [ proposal_variance 0; 0 proposal_variance];

current = seed;

if( animate )
    displayModel( model )
    hold on;
end

for i=1:maxSamples
    
    % Evaluate current probability
    p_z_t = model.density( current(1), current(2) );
    
    % Generate a proposal 
    z_star = mvnrnd( current, sigma );
    
    % Evaluate the candidacy
    p_z_star = model.density( z_star(1), z_star(2) );
    
    % Accept/reject
    r = rand();
    acceptance_prob = min( 1, p_z_star/p_z_t );
    
    if ( acceptance_prob > r )
        accept = true;
    else
        accept = false; 
    end
    
    if ( accept )
        current = z_star;
    else
        rejections = rejections + 1;
    end
             
    samples(:, end+1 ) = current;
    
    accept = false;
     
end

rejectionRatio = rejections/maxSamples;

if ( animate )
    hold off
end