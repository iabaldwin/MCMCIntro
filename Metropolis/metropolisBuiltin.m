function metropolisBuiltin(model)

    seed = [0;0];
    numSamples = 1000;
   
    %proprnd = @(x) x + rand(size(x));  
    proprnd = @(x) x +rand;  
    
    proppdf = @(x,y) mvnpdf( x-y, x, [1 0; 0 1]);
    
    pdf = @(x) model.density( x(1), x(2) );
    
%     samples = mhsample( seed, numSamples, 'pdf', pdf, 'proprnd', proprnd, 'proppdf', proppdf );
    samples = mhsample( seed, numSamples, 'pdf', pdf, 'proprnd', proprnd, 'symmetric', 1);

end