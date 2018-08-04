function leaf = look_for_leaf(node,mort_index,level)

    % Initializes as not finding leaf
    leaf = 0;
    
    % Criteria to make sure that the node isn't a leaf. If the length and
    % level of the node are greater than the parameters level, and it
    % actually is a node ,not a leaf, then continue
    criteria = node.length + node.level;
    
    while criteria >= level && node.isnode == 1
        
        index = rem(mort_combine(mort_index, level, node.level + 1),4);
        
        if index == 0
           node = node.c1; 
        elseif index == 1     
           node = node.c2;
        elseif index == 2
           node = node.c3;
        elseif index == 3
           node = node.c4;
        end
        
        if node.isleaf == 1
            leaf = 1;
        end
    end
end

