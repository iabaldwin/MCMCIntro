function [samples] = f( model, maxSamples, seed, animate )
% Simple Gibbs-sampling routine

assert( nargin==4, sprintf( 'Usage: [[float]]::samples = %s( Model::model, int::maxSamples, float::seed, bool::animate )', mfilename ) )
assert( isstruct(model), sprintf( '%s() : not a valid model', mfilename ) ) 
assert( strcmpi( model.type, 'gaussian' ) , sprintf( '%s() : require a 2D gaussian model', mfilename ) )

% Sampler parameters
samples = [];
accept = false;

% Seed
current = seed;

if ( animate )
    f = figure();
    hold on;
end

for i=1:maxSamples
    
    if ( animate )
        clf;
        contourModel( model,f );
        grid on
        view(45,45)
        
        if ( ~isempty( samples ) )
           plot(samples(end,1), samples(end,2), '.g', 'MarkerSize', 15 ); 
        end
    
    end
    
    % Condition on x1 given x2
    d = getNumericalApproxConditional( model, NaN, current(1) );
    condSample = generateSampleFromNumericalConditional( [d(:,2) d(:,3)] );

    s1 = condSample;
    
    if ( animate )
        %Plot the conditional 
        plot3(d(:,1), d(:,2), d(:,3), 'b' )
        % And the sample
        plot( current(1) ,s1, '.b', 'MarkerSize', 15 );
        drawnow
        pause
    end
    
    
    % Condition on x2 given x1
    d = getNumericalApproxConditional( model, condSample, NaN );
    condSample = generateSampleFromNumericalConditional( [d(:,1) d(:,3)] );

    s2 = condSample;
    
    if( animate )
        plot3(d(:,1), d(:,2), d(:,3), 'r' )
        plot( s2 ,s1, '.r', 'MarkerSize', 15 );
        drawnow
        pause
    end
    
    samples(end+1,:) = [s2 s1];
    
    current = [s2 s1 ];

    if ( animate )
        plot3( s2,s1, 0, 'sk', 'MarkerSize', 10 );
    end
    
end

end

function cond = getNumericalApproxConditional( model, a, b)
    
    numels = 100;
    
    if ( isnan( b ) )
        % Testing for b 
        x = linspace( model.domain_x1(1), model.domain_x1(2), numels );
        y = repmat( a, numels, 1 );
    else
        x = repmat( b, numels, 1 );
        y = linspace( model.domain_x2(1), model.domain_x2(2), numels );
        
    end

    x = reshape(x, numel(x), 1 );
    y = reshape(y, numel(y), 1 );
    
    
    for i =1:size( x,1)
        d(i,1) = model.density( x(i), y(i) );
    end
    
    d = d/sum(d);
    
    cond = [x y d];
    
end

function s = generateSampleFromNumericalConditional( conditional )
    
    cdf(1,1) = conditional(1,2);
    %Build CDF
    for i =2:numel(conditional(:,1) )
        
        cdf(i,1) = cdf(i-1,1) + conditional(i,2);
        
    end
    
    r = rand();
    pos = numel( find( cdf < r ) );
    
    s = conditional(pos,1);
    
end
