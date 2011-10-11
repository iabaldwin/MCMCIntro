function discreteMultipleT( steps, start, random_transition_operator )

T = [ 2/3 1/2 1/2;
    1/6 0 1/2;
    1/6 1/2 0];

if nargin == 3
    
    if ( random_transition_operator )
        T = rand(3,3);
    end    

end

P = start;

P_log = [];

for i =1:steps
    
    P = T*P;
    
    P_log(:,end+1) = P;
    
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

end
