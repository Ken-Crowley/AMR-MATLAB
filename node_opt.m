classdef node_opt
    
    % This class is for a node. A node contains 4 children (leafs or other
    % nodes), a x coordinate value, a y coordinate value, a level with
    % which the node is in, and a morton index of where the node is. 
    % It also has local variables that describe whether it is a node or a
    % leaf, and the length
    
    properties
        % Parameters of node.       
        c1
        c2
        c3
        c4
        x
        y
        value
        level
        mort_index
        
        % Nonchanging in leaf        
        length
        isleaf
        isnode
    end
    
    methods        
        function obj = node_opt(c1,c2,c3,c4,level,mort_index)
            obj.c1 = c1;
            obj.c2 = c2;
            obj.c3 = c3;
            obj.c4 = c4;
            
            % Initializes the nodes length to its first childs length
            obj.length = c1.length;
            
            % Checks through all lengths of the children in the node and,
            % in the end, assigns the highest length from one of the 4
            % children to obj.length (lenght in node)
            if c1.length > obj.length
               obj.length = c1.length;
            end
            
            if c2.length > obj.length
               obj.length = c2.length;
            end
            
            if c3.length > obj.length
               obj.length = c3.length;
            end
            
            if c4.length > obj.length
               obj.length = c4.length;
            end
            
            % Adds 1 to the length of the node, since it is 1 higher than
            % the highest child in its parameter
            obj.length = obj.length + 1;
            
            % Other values within leaf not defined by parameters
            obj.level = level;
            obj.mort_index = mort_index;
            obj.isleaf = 0;
            obj.isnode = 1;  
        end        
    end    
end

