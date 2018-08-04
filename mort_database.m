function table = mort_database(level)
    
    % This function creates a table which converts x and y coordinate
    % points (where (0,0) is at the top left of the cartesian axes) into
    % its corresponding morton code.

    % Grabs the dimensions of the M x N matrix, depending on the level
    M = 2^level;
    N = 2^level;
    
    % Cretes x and y vectors from 0 to the end of that dimension-1. This
    % will be used later on as coordinate points.
    x = 0:M-1;
    y = 0:N-1;
    
    % Initializes the morton table with the dimensions M x N
    table = zeros(M,N);
    
    % Loops through each grid point of the 2-D morton table and assigns the
    % morton code for the coordinate points of x and y at each point in
    % this table.
    for i = 1:M
        for j = 1:N
            table(i,j) = convert_to_morton(x(i),y(j));
        end
    end
end

