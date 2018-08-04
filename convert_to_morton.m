function morton_index = convert_to_morton(x,y)
    
    % This function reads in a coordinate position (x,y), converts
    % them into binary, interweaves them into a vector, then turns
    % that new binary vector into an integer, thus spitting out a single
    % number (the morton index)

    % x cooordinate
    % converts decimal to binary
    binary_x = decimalToBinaryVector(x);
    % Finds length of vector (spits out two numbers however)
    length_x = size(binary_x);
    
    % y coordinate
    binary_y = decimalToBinaryVector(y);
    length_y = size(binary_y);
    
    % Compares the x and y coordinate binary length, and determins the max
    binmax = max(length_x(2),length_y(2));
    
    % Allocated an array double the size of the max of length_x and length_y. 
    % This is done because no matter what lengths the x and y are, 
    % the largest array to be made when combining x and y would be doubled
    % (in highest case of length_x = length_y) 
    xy_combined = zeros(1,2*binmax);
    
    % Stores the binary_x array into every other index of the xy_combined
    % array, starting from the very end. It starts from the back of both 
    % arrays and moves to the front
    for i = 1:length_x(2)
        xy_combined(end + 2 - 2*i) = binary_x(end + 1 - i);   
    end
    
    % Stores the binary_y array into every other index of the xy_combined
    % array, starting from the very end-1. It starts from the back of both
    % arrays and moves to the front
    for i = 1:length_y(2)
       xy_combined(end + 1 - 2*i) = binary_y(end + 1 - i);
    end
    
    % this section of code essentially takes the xy_combined array
    % binary numbers and combines them into just a binary number so later
    % on it can be turned back into a decimal number
    newbinary=num2str(xy_combined);
    idx=strfind(newbinary,' ');
    newbinary(idx)=[];
    
    % Finds the morton_index of the x,y coordinate provided (this is
    % decimal equivalency of the interwoven binary number created above
    morton_index = bin2dec(newbinary);

end

