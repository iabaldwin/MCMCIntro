classdef isingModel < handle
    
    properties (Constant)
       %b = 1.3806503e-23; 
       b = 1;
    end
    
    properties
        % Initial properties
        size;
        temperature;
        beta;
        J;
        H;
        
        spins;
        E;
        
        odd_checker;
        even_checker;
        indices;
        
    end
    
    
    methods
        function obj = isingModel( size, temperature, J, H )
                obj.size = size;
                obj.temperature = temperature;
                obj.J = J;
                obj.H = H;
            
                % Create the initial spins;
                obj.createSpins();
                
                obj.beta = inv(temperature);
                
                % Create checkerboards for gibbs sampling
                obj.generateCheckerBoards( size );
                
                % Create the referenc indices
                indices = 1:obj.size*obj.size;
                obj.indices = reshape( indices, size, size );
        end
        
        function createSpins( obj )

            % Set the seed
            rand('seed', 15 );

            % Construct the values
            randVals = rand( obj.size, obj.size );
            randVals( randVals < .5 ) = -1; 
            randVals( randVals >= .5 ) = 1;

            obj.spins = randVals;
        end
        
        function calculateEnergy( obj )
            
            E = 0;
            
            % Calculate pair-wise energy
            for i=1:numel( obj.spins )
                
                xn = obj.getSpinValue( i );
                
                neighbors = obj.getNeighbors( i );
               
                for j = 1:4
                    
                    if ( neighbors(j) == 0 )
                        continue;
                    end
                    
                    xm = obj.getSpinValue( neighbors(j ) );
                    
                    E = E + obj.J*( xm * xn );
                   
                end
                
                
            end
            
            obj.E = E;
            
            % Calculate applied field energy
            % Assume to be zero
            
        end
        
        function [spins] = gibbsIterate( obj )
            % Perform 1 iteration of gibbs sampling
            % Do not sample the boundaries
            
            even_checker = obj.even_checker;
            even_checker (:,1) = 0;
            even_checker (1,:) = 0;
            even_checker (:,end) = 0;
            even_checker (end,:) = 0;
            
            white_checks = obj.indices( find( even_checker) );
            
            odd_checker (:,1) = 0;
            odd_checker (1,:) = 0;
            odd_checker (:,end) = 0;
            odd_checker (end,:) = 0;
            
            black_checks = obj.indices( find( odd_checker) );
            
            % Check
            [white_checks_x, white_checks_y] = obj.spin2xy( white_checks );
            [black_checks_x, black_checks_y] = obj.spin2xy( black_checks );
            
%             figure()
%             hold on
%             obj.drawSpins();
%             plot( white_checks_x, white_checks_y+1, '.g' );
%             hold off
%             
            changes = [];
            
            for i=1:numel(white_checks)
                
                % Get the local field
                neighbors = obj.getNeighbors( white_checks(i));
                
                % For debugging
                original = obj.getSpinValue( white_checks(i) );
                
                field = 0;
                for j =1:4
                    
                    if ( neighbors(j) == 0 )
                        continue;
                    end
                    
                    field = field + obj.J * obj.getSpinValue( neighbors(j) ) + obj.H;
                    
                end
                
                p_positive = inv( 1 + exp(  -2* obj.beta *field) );
                
                r = rand();
                
                if p_positive > r
                   
                    obj.setSpinValue( white_checks(i), +1 );

%                     disp([ r p_positive] )
                    
                    if ( obj.getSpinValue( white_checks(i) ) ~= original )

                        changes(end+1,1) = white_checks(i);
                        
                    end
                
                end
                
            end
            
            for i=1:numel(black_checks)
                
                % Get the local field
                neighbors = obj.getNeighbors( black_checks(i));
                
                % For debugging
                original = obj.getSpinValue( black_checks(i) );
                
                field = 0;
                for j =1:4
                    
                    if ( neighbors(j) == 0 )
                        continue;
                    end
                    
                    field = field + obj.J * obj.getSpinValue( neighbors(j) ) + obj.H;
                    
                end
                
                p_positive = inv( 1 + exp(  -2* obj.beta *field) );
                
                r = rand();
                
                if p_positive > r
                   
                    obj.setSpinValue( black_checks(i), +1 );
                    
                end
                
            end
            
            
            obj.drawSpins();
            drawnow;
            
            % Plot all the ones with changes
            %plot( white_checks_x, white_checks_y+1, '.g' );
            %[changes_x, changes_y] = obj.spin2xy( changes );
            %hold on
            %obj.drawSpins();
            %plot( changes_x, changes_y+1, '.g', 'MarkerSize', 10 );
            %hold off
            
        end
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Helper Functions
        
        function [neighbors] = getNeighbors( obj, spin )
            % Need to assume periodic boundary conditions
            
            neighbors = zeros(4,1);
            
            [r,c] = ind2sub( [obj.size obj.size], spin );
            
            % left neighbor
            cleft = c - 1;
            if ( cleft > 0 )
                neighbors(1) = sub2ind( [obj.size obj.size], r, cleft );
            else
               cleft = obj.size; 
               neighbors(1) = sub2ind( [obj.size obj.size], r, cleft );
            end
            
            % top neighbor
            rtop = r - 1;
            if ( rtop > 0 )
                neighbors(2) = sub2ind( [obj.size obj.size], rtop, c );
            else
                rtop = obj.size;
                neighbors(2) = sub2ind( [obj.size obj.size], rtop, c );
            end
                
            % right neighbor
            cright = c + 1;
            if ( cright <= obj.size )
                neighbors(3) = sub2ind( [obj.size obj.size], r, cright );
            else
                cright = 1;
                neighbors(3) = sub2ind( [obj.size obj.size], r, cright );
            end
            
            % bottom neighbor
            rbottom = r + 1;
            if ( rbottom <= obj.size )
                neighbors(4) = sub2ind( [obj.size obj.size], rbottom, c );
            else
                rbottom = 1;
                neighbors(4) = sub2ind( [obj.size obj.size], rbottom, c );
            end
            
        end
        
        function [x,y] = spin2xy( obj, spin )
            
           [r,c] = ind2sub( [obj.size, obj.size], spin );
            
           x = c;
           y = obj.size - r;
            
        end
        
        function value = getSpinValue( obj, spin )
            
            [r,c] = ind2sub( [obj.size obj.size], spin );
            
            
            value = obj.spins(r,c);
            
        end
        
        function setSpinValue( obj, spin, value )
            
             [r,c] = ind2sub( [obj.size obj.size], spin );
             
             obj.spins(r,c) = value;
        end
        
        function generateCheckerBoards( obj, s )
            % Logical checkerboard
            
            % Odd checkerboard
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

            obj.odd_checker = x;
            % Even checkerboard
            obj.even_checker = ~(x);
            
            
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Drawing
        function drawSpins( obj, handle )
            if nargin == 1
                imagesc( obj.spins )
            else
               figure( handle )
               hold on;
               imagesc( obj.spins )
               hold off
            end
        end
        
        function drawNeighbors( obj, spin )
            
            neighbors = obj.getNeighbors( spin );
            
            [spin_x, spin_y] = obj.spin2xy( spin );
            
            obj.drawSpins();
            hold on;
            axis( [0 obj.size 0 obj.size] );
            
            for i = 1:4
                if ( neighbors(i) == 0 )
                    continue;
                end
                
                [x,y] = obj.spin2xy( neighbors(i) );
                line( [spin_x x], [spin_y y] );
                
                
            end
            
            hold off;
            
        end
        
    end
    
end