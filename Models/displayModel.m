function displayModel( model, fig )
% Display the density function we are going to sample from

if ( ~isstruct( model ) )
    fprintf(1,'Erroneous model')
    return
end

% Function handles
if ( ~isfield( model, 'density' ) )
    fprintf(1,'Model has no density')
    return
end

if ( ~isfield( model, 'dim') )
    fprintf(1,'Model has no dimension')
    return
end

if ( model.dim > 2 )
    fprintf(1,'Cannot render')
    return
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

% Assign density
density = model.density;

if nargin == 1
    figure()
    hold on
else
    figure( fig )
    hold on
end
    
data = [];

if ( model.dim == 2)
    resolution = 0.2;

    for x =xmin:resolution:xmax

        for y = ymin:resolution:ymax

            f = density(x,y);

            data(end+1,:) = [x,y,f];

        end
    end

    [s,i] = sort( data(:,3) );
    srt = data(i,:);

    scatter3(srt(:,1),srt(:,2),srt(:,3),5,linspace(0,1,numel(srt(:,1))),'filled');       
else
   resolution = 0.1;

   for x =xmin:resolution:xmax

        f = density(x);

        data(end+1,:) = [x f];

    end

    [s,i] = sort( data(:,2) );
    srt = data(i,:);

    scatter(srt(:,1),srt(:,2),5,linspace(0,1,numel(srt(:,1))),'filled');        
   
   
end
