function [lower, upper] = mort_range_split(mort_index,cur_level,lev_above)

    % This function takes the morton index at the current level, and finds
    % the lower and upper limit of the four indexes that it would turn into
    % when going up a level. For example: Morton index 3 at level 1 would
    % split up into morton index 12 - 15 at level 2, assuming everything
    % splits up.
    
    lower = mort_index*4^(lev_above-cur_level);
    upper = (mort_index + 1)*4^(lev_above-cur_level)-1;

end

