function get_leaf(quadtree,level)

    % This function 

   global leaf_list

   if quadtree.c1.isleaf == 1   
       myleaf = quadtree.c1;
       x = myleaf.x;
       y = myleaf.y;
       val = myleaf.value;
       
       info = [level + 1,x,y,val];
       leaf_list = [leaf_list; info];
   else
       mynode = quadtree.c1;
       get_leaf(mynode,level + 1)
   end
   
   if quadtree.c2.isleaf == 1
       myleaf = quadtree.c2;
       x = myleaf.x;
       y = myleaf.y;
       val = myleaf.value;
       
       info = [level + 1,x,y,val];
       leaf_list = [leaf_list; info];
       
   else
       mynode = quadtree.c2;
       get_leaf(mynode,level + 1)
   end
    
   if quadtree.c3.isleaf == 1
       myleaf = quadtree.c3;
       x = myleaf.x;
       y = myleaf.y;
       val = myleaf.value;
       
       info = [level + 1,x,y,val];
       leaf_list = [leaf_list; info];
       
   else
       mynode = quadtree.c3;
       get_leaf(mynode,level + 1)
   
   end
   
   if quadtree.c4.isleaf == 1
       myleaf = quadtree.c4;
       x = myleaf.x;
       y = myleaf.y;
       val = myleaf.value;
       
       info = [level + 1,x,y,val];
       leaf_list = [leaf_list; info];
       
   else
       mynode = quadtree.c4;
       get_leaf(mynode,level + 1)
   end
      
end

