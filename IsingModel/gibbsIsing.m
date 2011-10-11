function [sample] = gibbsIsing( isingModel, iterations )

spins = [];
for i=1:iterations
    
    
    % Pick a random spin
    spin = pickRandomSpin ( isingModel );
    spins = [spins; spin];
    
    % Draw the neighbors
    
    
    
end

figure()
hold on
   
% Draw the spins
for i=1:numel( spins )
   
   [r,c] = ind2sub( size(isingModel), spins(i) );
   
   plot(c+(rand*0.01),r+(rand*.01),'.g','MarkerSize', 20);
    
    
end



end

function spin = pickRandomSpin( isingModel )

    r = rand();
    
    spin = ceil( r*numel(isingModel ) );
    
end

function [neighbors] = getNeighbors( spin )

    % Convert spin to [r,c]
    

end