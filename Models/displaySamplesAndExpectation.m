function displaySamplesAndExpectations( model, samples )

l = length( samples );
samples = reshape( samples, 2, l );

f = figure();
hold on
contourModel( model,f );
plot( samples(1,:), samples(2,:), '.b', 'MarkerSize', .1 );

% Calculate the moving expectation
e = [];
for i = 1:numel( samples(1,:) )
    
    e(1,end+1) = mean( samples(1,1:i) );
    e(2,end) = mean( samples(2,1:i) );


end

% Display the expectation trail
% scatter(e(1,:), e(2,:), 5, linspace(0,1,numel(e(1,:))), 'filled' );
% 
% % Display the actual expectation
% plot( model.E(1), model.E(2), 'og', 'MarkerSize', 8, 'LineWidth', 3 );

hold off