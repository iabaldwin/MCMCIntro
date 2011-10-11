function discreteTransition( steps, start, random_transition_operator )

if ( nargin ~= 3 )
    disp('Usage:')
    disp('discreteTransition( steps, start, random_transition_operator)' )
    disp('steps                 - steps to take')
    disp('start                 - starting distribution')
    disp('random                - (bool) use a randomt transition operator');
    return;
end


T = [ 2/3 1/2 1/2;
    1/6 0 1/2;
    1/6 1/2 0];

if nargin == 3
    
    if ( random_transition_operator )
        T = rand(3,3);
        
        T(:,1) = T(:,1)/sum(T(:,1));
        T(:,2) = T(:,2)/sum(T(:,1));
        T(:,3) = T(:,3)/sum(T(:,1));
    end    

end

P = start;

P_log = [];

for i =1:steps
    
    P = T*P;
    
    P_log(:,end+1) = P;
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construct a chain
% Start in state 1
state = 1;

frequencies = zeros(3,1);

for i = 1:steps
    
    % Get the state transition probability
    trans = T(:, state );
    
    % Sample from the distribution to get the next position
    s = sampleState( trans );
    
    frequencies( s ) = frequencies( s ) + 1;
    
end


subplot(3,1,1)
plot(P_log(1,:), 'r' );
title('dimension 1')
subplot(3,1,2)
plot(P_log(2,:), 'g' );
title('dimension 2')
subplot(3,1,3)
plot(P_log(3,:), 'b' );
title('dimension 3')

disp( frequencies/sum(frequencies) );


end

function state = sampleState( trans )

    % Build the cumulative density function

    cdf = generateCDF( trans );
    
    r = rand();
    
    posInCDF = cdf( cdf < r );
    
    if( isempty( posInCDF ) )
        state = 1;
    elseif ( numel(posInCDF) == 1 )
        state = 2;
    else
        state = 3;
    end
    
end


function cdf = generateCDF( trans )

    cdf = zeros(3,1);
    cdf(1) = trans(1);
    cdf(2) = cdf(1) + trans(2);
    cdf(3) = cdf(2) + trans(3);
    

end
