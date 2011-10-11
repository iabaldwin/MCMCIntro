s = 20;
x = ones( s,s );

% Index through the odd columns
for i = 1:2:s
    
    col = x(:,i);
    
    col(1:2:numel(col)) = 0;
    
    x(:,i) = col;
    
end

% Index through the even columns
for i = 2:2:s
    
    col = x(:,i);
    
    col(2:2:numel(col)) = 0;
    
    x(:,i) = col;
    
end
