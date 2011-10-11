function plotStepLengths( samples )
% Plot the step lengths from the samples

figure()
hold on

lengths = [];

for i=2:size(samples,2)
    
    length = norm( samples(:,i) - samples(:,i-1) );
    
    lengths(i,1) = length;
    
    
end

maxNorm = max( lengths );
minNorm = min( lengths );

divs = linspace(minNorm, maxNorm, 5 );

for i=2:size(samples,2)

    disp(lengths(i))
    if lengths(i) > divs(5)
        line([samples(1,i) samples(1,i-1)],[samples(2,i) samples(2,i-1)], 'Color', 'r' )
    elseif lengths(i) > divs(4)
        line([samples(1,i) samples(1,i-1)],[samples(2,i) samples(2,i-1)], 'Color', 'y' )
    elseif lengths(i) > divs(3)
        line([samples(1,i) samples(1,i-1)],[samples(2,i) samples(2,i-1)], 'Color', 'g' )
    elseif lengths(i) > divs(2)
        line([samples(1,i) samples(1,i-1)],[samples(2,i) samples(2,i-1)], 'Color', 'c' )
    else
        line([samples(1,i) samples(1,i-1)],[samples(2,i) samples(2,i-1)], 'Color', 'b' )
    end
    
end    
    

end