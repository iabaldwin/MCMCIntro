function data = contourModel( model, h )

if ( ~isstruct( model ) )
    error('Erroneous model')
    return
end

% Function handles
if ( ~isfield( model, 'density' ) )
    error('Model has no density')
    return
end

if ( ~isfield( model, 'dim') )
    error('Model has no dimension')
    return
end

if ( model.dim ~= 2 )
    error('Cannot render contours for this model')
    
end

xmin = -10;
xmax = 10;
ymin = -10;
ymax = 10;

if ( isfield( model, 'domain_x1' ) )
    xmin = model.domain_x1(1);
    xmax = model.domain_x1(2);
end

if ( isfield( model, 'domain_x2' ) )
    ymin = model.domain_x2(1);
    ymax = model.domain_x2(2);
end

if ( isfield( model, 'function' ) )
    density = model.function;
else
    % Assign density
    density = model.density;
end

if nargin == 1
    figure()
    hold on
else
    figure( h )
    hold on
end
    
data = [];

resolution = 0.5;

xcount = 0;

for x =xmin:resolution:xmax
    xcount = xcount + 1;

    ycount = 0;

    for y = ymin:resolution:ymax
        ycount = ycount  + 1;
        f = density(x,y);

        data(end+1,:) = [x,y,f];

    end
end

[s,i] = sort( data(:,3) );
srt = data(i,:);
cdata = reshape( data(:,3), xcount, ycount );
contour(xmin:resolution:xmax, ymin:resolution:ymax, cdata );

end