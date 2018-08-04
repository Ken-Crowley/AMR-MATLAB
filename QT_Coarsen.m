function [x_vertex,y_vertex,level_data_vert,M,N,level,domain_vert] = QT_Coarsen
clc;
clear;
clear global;
clear plot;

level=6;

%domain_vert = ReadArray_FortranBinary('DP_Smooted.dat',2);
% load = matfile('saveA65.mat');
% domain_vert = load.A;
ImageA = imread('circle65.png');
imshow(ImageA)
Inte = 0.2989 * ImageA(:,:,1) + 0.5870 * ImageA(:,:,2) + 0.1140 * ImageA(:,:,3);
A = (1-Inte/255);

% Parameters
h = 1;
dt = .1*h^2;
t0 = 0;
tf = .5;
time = t0:dt:tf;

% Precision correction
A = double(A);

% Diffusion Smoothing
for n = 1:length(time)  
    A = A + dt*(Diffusion_Smoothing_Function(A,h));    
end

domain_vert = A;

% Spacing of the grid
dx = .05;
dy = .05;

[Dpdx , Dpdy] = Del_DP(domain_vert,dx,dy);
mag_Psi = sqrt(Dpdx.^2+Dpdy.^2);
domain = (mag_Psi(1:end-1,1:end-1) + mag_Psi(2:end,1:end-1) + mag_Psi(1:end-1,2:end) + mag_Psi(2:end,2:end))/4;

% Grid size must be power of two for quad tree decomposition to work
[M, N] = size(domain);

Lx = M*dx;
Ly = N*dy;

% Creates morton 2D table depending on the level chosen. This morton table 
% has all of the associated morton indexes moving in an n (or z) order
% curve. This database starts initally at the most refined level uniformly
morton_database = mort_database(level);

% Initializes the x, y and value vectors
value = zeros(1,M);
x = zeros(1,M);
y = zeros(1,M);

% Loops through MxN to receive x and y coordinates and DP value. (The x and
% y coordinates correspond to the DP value in the middle of the refined
% mesh space.
for i = 1:M
    for j = 1:N
        
        % Grabs the morton index with the associated i and j coordinates.
        % This index moves around in a z pattern for evey four points. It
        % starts at 0 and goes to 2^depth - 1.
        index = morton_database(i,j);
        
        % Grabs the psi value, x coordinate, and y coordinate of each
        % center within the most refined level (associated w/ index + 1)
        value(index+1) = domain(i,j);
        x(index+1) = (i-1)*dx + 0.5*dx;
        y(index+1) = (j-1)*dy + 0.5*dx;
    end
end

% Allocates space for a vector that contains all the inputs
leaf_input = cell(1,(2^level)^2);

% Grabs size and corresponding length of input vector
sizeinput = size(leaf_input);
length_leaf_input = sizeinput(2);

% Allocates input array in loop below.
input = cell(1,length_leaf_input);

% Creates vector that creates every leaf in the first refined mesh
% (length_size). Each leaf has its own associated x and y coordinate, and
% a psi domain parameter value. The levels for all of these leafs being
% initialized are the same, at the most refined level starting (since this
% is a bottom-up technique). The mort index is also associated with each
% leaf. The morton index goes from 1 to length_size
for i = 1:length_leaf_input
    
    % assigns morton index each iteration (i-1 because it starts with 0)
    mort_index = i-1;
    
    % Creates a leaf with the given x,y,val at the morton index and level
    leaf = leaf_opt(x(i),y(i),value(i),level,mort_index);
    
    % Stores the leaf in a vector
    input{1,i} = leaf;
    
end

% decrements level
d = level - 1;

% Initializes q as a cell array. Objects will be loaded into the q four at
% a time.
q = {};
queue = {};

% Checks through depth - 1 to lowest depth
while d >= 0
    
    input_vector = (2^d)^2;
    
    % Spans entire input vector
    for i = 1:input_vector
        
        % Initially starts off as every object in the vector being a leaf.
        leafs = 1;
        
        % Looks at the next 4 leafs in the input vector and stores them
        % into the queue, checks if all are leafs.
        for j = 1:4
            
            q{j} = input{4*(i-1) + j};
            
            % Checks each input in the queue to see if it is a leaf. If at
            % least one of them isn't a leaf and can't combine later.
            if q{j}.isleaf == 0
                leafs = 0;
            end
            
        end
        
        % Grabs the morton index of the leaf or node that is in the input
        % vector
        morton_index = i-1;
        
        % If all four within the queue are leafs, then look and see if
        % combining into a node can work.
        if leafs == 1
            
            % Finds the average of the four values within the queue at the
            % time, since it will be combined into one from the four.
            avg_val = (q{1}.value+q{2}.value+q{3}.value+q{4}.value)/4;  
            area = (Lx/2^(d))^2;
            
            % Checks to see if combining four points should be done
            criteria = combine_QT(area,avg_val);
            
            % If combining can work,
            if criteria == 1
                
                balanced = 1;
                neighbor_level = d+2;
                
                % Finds the range of morton index two levels deeper. For
                % example: if given morton index of 0 at level d, then
                % level d_2 (neighbor_level) would be have a lower of 0 and
                % upper of 15)
                [lower, upper] = mort_range_split(morton_index,d,neighbor_level);
                
                % Converts the lower and higher morton indices of d+2 to
                % x and y coordinates
                [x_lower, y_lower] = convert_to_coords_fix(lower);
                [x_upper, y_upper] = convert_to_coords_fix(upper);
                
                % Finds the lowest x and y coordinates of the upper and
                % lower range
                x_min = min(x_lower,x_upper);
                y_min = min(y_lower,y_upper);
                
                % Finds the highest x and y coordinates of the upper and
                % lower range
                x_max = max(x_lower,x_upper);
                y_max = max(y_lower,y_upper);
                
                neigh_list = [];
                % If corner of grid then won't store neighbors
                if x_min > 0
                   for k = y_min:y_max
                    neigh_list = [neigh_list; convert_to_morton(x_min-1,k)];
                   end
                   if y_min > 0
                    neigh_list = [neigh_list; convert_to_morton(x_min-1,y_min-1)];
                   end
                   if y_max < 2^(neighbor_level) - 2
                    neigh_list = [neigh_list; convert_to_morton(x_min-1,y_max+1)];
                   end
                end
                
                if x_max < 2^(neighbor_level) - 2
                    for k = y_min:y_max
                        neigh_list = [neigh_list; convert_to_morton(x_max+1,k)];
                    end
                    if y_min > 0
                        neigh_list = [neigh_list; convert_to_morton(x_max+1,y_min-1)];
                    end
                    if y_max < 2^(neighbor_level) - 2
                        neigh_list = [neigh_list; convert_to_morton(x_max+1,y_max+1)];
                    end                        
                end
                
                if y_min > 0
                   for k = x_min:x_max
                       neigh_list = [neigh_list; convert_to_morton(k,y_min-1)];
                   end
                end
                
                if y_max < 2^(neighbor_level) - 2
                    for k = x_min:x_max
                    neigh_list = [neigh_list; convert_to_morton(k,y_max+1)];
                    end
                end
                                
                for ii = 1:length(neigh_list)
                    
                    mort = neigh_list(ii);
                    isthere = 0;
                    start_search = floor(mort/4);

                    if input{start_search}.isnode == 1
                        isthere = look_for_leaf(input{start_search},mort,neighbor_level);
                    end
                    
                    if isthere == 1
                        balanced = 0;
                        break;
                    end
                end
                
                if balanced == 1
                   x_avg = (q{1}.x+q{2}.x+q{3}.x+q{4}.x)/4;
                   y_avg = (q{1}.y+q{2}.y+q{3}.y+q{4}.y)/4;
                   next_push = leaf_opt(x_avg,y_avg,avg_val,d,morton_index);
                else
                    c1 = q{1};
                    c2 = q{2};
                    c3 = q{3};
                    c4 = q{4};
                    next_push = node_opt(c1,c2,c3,c4,d,morton_index);
                end
                
            else
              c1 = q{1};
              c2 = q{2};
              c3 = q{3};
              c4 = q{4};
              next_push = node_opt(c1,c2,c3,c4,d,morton_index);
            end
                
        else
           c1 = q{1};
           c2 = q{2};
           c3 = q{3};
           c4 = q{4};
           next_push = node_opt(c1,c2,c3,c4,d,morton_index);      
        end
        queue{end+1} = next_push;
    end     
      input = queue;
      queue = {};
      d = d-1;
end

% Python code written in other file in this repository ends here!

global leaf_list

tree = input{1};
get_leaf(tree,0);

sizeleaf = size(leaf_list);
leaf_length = sizeleaf(1);

level_data = zeros(1,leaf_length);
x_data_cent = zeros(1,leaf_length);
y_data_cent = zeros(1,leaf_length);
val_data = zeros(1,leaf_length);

for i = 1:leaf_length
    data = leaf_list(i,:);
    level_data_cent(i) = data(1);
    x_data_cent(i) = data(2);
    y_data_cent(i) = data(3);
    val_data(i) = data(4);
end

% figure(1)
% plot(x_data_cent,y_data_cent, 'b.')
 
x_vertex = [];
y_vertex = [];
level_data_vert = [];

% Finds the x and y vertex based on the coordinates of the center of the
% cell
for i = 1:leaf_length
    
    depth = level_data_cent(i);
    
    dx = (1/2)*(Lx/2^(depth));
    dy = (1/2)*(Ly/2^(depth));
    
    x_vertex = [x_vertex, x_data_cent(i) - dx];
    x_vertex = [x_vertex, x_data_cent(i) - dx];
    x_vertex = [x_vertex, x_data_cent(i) + dx];
    x_vertex = [x_vertex, x_data_cent(i) + dx];
    
    y_vertex = [y_vertex, y_data_cent(i) + dy];
    y_vertex = [y_vertex, y_data_cent(i) - dy];
    y_vertex = [y_vertex, y_data_cent(i) + dy];
    y_vertex = [y_vertex, y_data_cent(i) - dy];

    
    for j = 1:4
        level_data_vert = [level_data_vert; level_data_cent(i)];
    end
end

end