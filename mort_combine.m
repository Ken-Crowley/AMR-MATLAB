function mort_index = mort_combine(mort_index, cur_level, level_above)

    % This function finds the morton index when combining a quadtree. For
    % example, in a range of 12 - 15 on level 2, the morton_index of those
    % four would be 3 on level 1.
    
    mort_index = floor(mort_index/(4^(level_above-cur_level)));

end

