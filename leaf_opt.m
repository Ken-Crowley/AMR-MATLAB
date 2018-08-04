classdef leaf_opt
    
    properties
        % Parameters of leaf
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
        
        function obj = leaf_opt(x,y,value,level,mort_index)
            % Mutators
            obj.x = x;
            obj.y = y;
            obj.value = value;
            obj.level = level;
            obj.mort_index = mort_index;
            
            % Other values within leaf not defined by parameters
            obj.length = 0; % 0 because it is a leaf
            obj.isleaf = 1;
            obj.isnode = 0;
        end
        
    end
    
end

