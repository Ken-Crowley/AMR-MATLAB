function merged = combine_QT(area,quantity)

    % This function determines whether or not the QT leaf should be
    % combined or not It checks the area and quantity of the magnitude of
    % the psi gradient to determine whether merging occurs. If the qunatity
    % of psi is greater than the criteria, then it does not merge (0), else
    % it does merge (1)

    % Since psi gradient is between 0 and 1 
    criteria = quantity*area;
    
    if criteria > .005
        merged = 0;
    else   
        merged = 1;
    end
end

