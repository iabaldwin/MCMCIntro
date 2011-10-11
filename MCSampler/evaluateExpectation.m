function [eval, mean] = evaluateExpectation( model, interval, range )
% Basic Metropolis (symmetric) sampling 

if( ~isstruct( model ) )
    error('Erroneous model')
end

% Sampler parameters
mean = [];
eval = [];

for x=range(1):interval:range(2)

    for y = range(1):interval:range(2)
   
        f = model.density( x, y );
    
        eval(end+1,:) = [ x y f];

        mean(end+1,:) = [eval(:,1)'*eval(:,3) eval(:,2)'*eval(:,3)];
        
    end
end


