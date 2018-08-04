function [list_mort_index,list_level] = leaf_details(node)
    
    list = node;
    sizelist = size(list);
    length_list = sizelist(2);
    
    list_most_index = [];
    list_level = [];
    
    while length_list > 0
       
        node = list(1);
        
        if node.c1.isleaf == 1
            list_mort_index = [list_mort_index, node.c1.mort_index];
            list_level = [list_level, node.c1.level];
        else
            list = [list, node.c1];
        end
        
        
        if node.c2.isleaf == 1
            list_mort_index = [list_mort_index, node.c2.mort_index];
            list_level = [list_level, node.c2.level];
        else
            list = [list, node.c2];
        end
        
        
        if node.c3.isleaf == 1
            list_mort_index = [list_mort_index, node.c3.mort_index]
            list_level = [list_level, node.c3.level]
        else
            list = [list, node.c3];
        end
        
        
        if node.c4.isleaf == 1
            list_mort_index = [list_mort_index, node.c4.mort_index];
            list_level = [list_level, node.c4.level];
        else
            list = [list, node.c4];
        end
        
    end
    
    list_mort_index
    list_level

end

