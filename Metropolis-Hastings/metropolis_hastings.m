function [samples,rejection_ratio] = metropolis_hastings( model, maxSamples, seed, animate )
% Basic Metropolis-Hastings sampling for mixture model

rand('seed', 15 );

if ( nargin ~= 4 )
    disp('Usage:')
    disp('[samples,rej_ratio]   = metropolis_hastings( model, maxSamples, seed, animate)' )
    disp('model                 - model structure (type whichModel)')
    disp('maxSamples            - maximum samples')
    disp('seed                  - initial value')
    disp('animate               - animate the process');
    return;
end

% INDEPENDENT METROPOLIS
% We use the chi-squared distribution as a proposal distribution, with 4
% degrees of freedom

samples = [];
accept = false;
rejection_ratio = 0;

proposal = @(x) chi2pdf( x, 4 );
% proposal = @(x) gampdf( x, 9, 0.5 );
% rand_state = @() unifrnd( model.domain_x1(1), model.domain_x1(2) );
rand_state = @() chi2rnd( 4 );

current = seed;

if ( animate )
    f = figure();
    displayModel( model, f );
    hold on;

    % Also display the q
    tmp_x = model.domain_x1(1):.1:model.domain_x1(2);
    
    tmp_y = proposal( tmp_x );
    
    plot( tmp_x, tmp_y, '.k', 'MarkerSize', .2 );

end

for i=1:maxSamples
    
%     disp('-------------------------');
    
    % Evaluate current probability
    p_z_t = model.density( current );
    
    % How do we generate random numbers?
    % First, try uniform
    % Generate a proposal 
    z_star = rand_state();
    
    % Evaluate the candidacy
    p_z_star = model.density( z_star );
    
    % Evaluate ratio of q's
    q_z = proposal( current );
    q_z_star = proposal( z_star );
    
    % Accept/reject
    r = rand();

    ratio1 = (p_z_star/p_z_t);
    ratio2 = (q_z/q_z_star);
    
%     acceptance_prob = min( 1, (p_z_star/p_z_t)*(q_z/q_z_star) );
    acceptance_prob = min( 1, (ratio1*ratio2) );

    if ( animate )
        plot( current, 0, '.k', 'MarkerSize', 10 );
        plot( z_star, 0, '.r', 'MarkerSize', 10 );
    end
    
    if ( r < acceptance_prob )
        accept = true;
        if ( animate );
            plot( z_star, 0, '.g', 'MarkerSize', 10 );
        end
    else
        accept = false; 
    end
    
    if ( accept )
        current = z_star;
    end
    
    samples(:, end+1 ) = current;
    
    accept = false;
   
    if ( animate )
        pause
    end
    
    
end

if( animate )
    hold off
end


end