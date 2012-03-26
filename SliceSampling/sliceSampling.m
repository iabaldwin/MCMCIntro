function [samples] = sliceSampling( model, numSamples, seed, animate )

if ( nargin ~= 4 )
    disp('Usage:')
    disp('[samples]             = sliceSampling( model, numSamples, seed, animate' )
    disp('model                 - model structure (type whichModel)')
    disp('numSamples            - maximum samples')
    disp('seed                  - initial value')
    disp('animate               - animate the process');
    return;
end

if ( ~isstruct(model) )
    error('Erroneous model')
end

rand('seed', 15 );

if model.dim ~= 1
    error('Model dimension must be 1')   
end

% Init
samples = [];
current = seed;

if ( animate )
    g = figure();
end

for i=1:numSamples
    fprintf('Iteration %d\n', i );

    if ( animate )
        displayModel( model, g );
        hold on;
        axis([model.domain_x1(1) model.domain_x1(2) 0 .02])
    end
    
    % Get the value of the current
    f = model.density( current );
    
    if ( animate )
        plot( [current;current],[0;f], 'b');
        drawnow
    end
    
    % Sample uniformly under the bound to get a point
    s = sampleUnderBound( f );
    
    % Get the bounds of the model
    bounds = getBounds( model, current, s );
    
    if( animate )
        plot( current, s, '.r', 'MarkerSize', 20 );
        plot( current, 0, '.k', 'MarkerSize', 20 );
        plot( bounds(1), s, 'sk', 'MarkerSize', 5 )
        plot( bounds(2), s, 'sk', 'MarkerSize', 5 )
        line([bounds(1) bounds(2)],[s s],'Color','k')
    end
    
    % Sample within bounds to get another sample
    sample = sampleWithinBounds( bounds );
    
    if( animate )
        plot( sample, s, '.g','MarkerSize', 20 );
    end
    
    % Check to see if the sample is valid
    if ( model.density( sample ) < s )
        
        while ( true )
            distToLower = abs( sample - bounds(1) );
            distToUpper = abs( sample - bounds(2) );
            
            if ( distToLower < distToUpper )
                bounds(1) = sample;
            else
                bounds(2) = sample;
            end
            
            sample = sampleWithinBounds( bounds );
    
            if( animate )
                plot( bounds(1), s, 'sk', 'MarkerSize', 5 )
                plot( bounds(2), s, 'sk', 'MarkerSize', 5 )

                plot( sample, s, '.b', 'MarkerSize', 20 );
            
                fprintf('Bounds:Lower[%f]Upper[%f]\n', bounds(1), bounds(2) );
                
                drawnow
                pause
            end
            
            if ( model.density( sample ) > s )
                break
            end
            
        end
        

    end
    
    samples(end+1,1) = sample;
    current = sample;
    
    if( animate )
        pause
        clf;
    end
end



end


function [sample] = sampleUnderBound( bound )

r = rand();

sample = r*bound;

end

function [bounds] = getBounds( model, current, boundSample )

lower = current - 3;

while ( true )
    
    if ( model.density( lower ) > boundSample )
        lower = lower - 1;
    else
        break;
    end
    
end

upper = current + 3;

while ( true )
    
    if ( model.density( upper ) > boundSample )
        upper = upper + 1;;
    else
        break;
    end
    
end

bounds = [lower upper];

end

function sample = sampleWithinBounds( bounds )

delta = max(bounds) - min(bounds);

r = rand();

sample = delta*r + min(bounds);

end
