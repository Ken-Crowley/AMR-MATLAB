function [x, y] = convert_to_coords_fix(morton_index)

    % This function reads in a morton index, converts it back into an
    % interwoven binary number. Then it extracts the x and y binary codes
    % and turns it back into coordinate number.
    
    % Turns the morton_index number into binary
    morton_binary = decimalToBinaryVector(morton_index);

    % Finds length of binary vector
    length_bin_vec = size(morton_binary);
    length_bin = length_bin_vec(2);
        
    % Takes the length of the binary number, divides by two and stores
    % the integer and remainer portion into two variables
    int_div = fix(length_bin/2);
    rem_div = mod(length_bin,2);
        
    % Finds highest possible integer to be made when doubling integer
    % portion
    int_div = (int_div+rem_div)*2;
        
    % computes length of x and y vectors (both the same size) and
    % allocates vector of zeros
    length_x = int_div/2;
    length_y = int_div/2;
    x = zeros(1,length_x);
    y = zeros(1,length_y);
    m = zeros(1,length_bin);
       
    for i = 1:length_bin
        m(int_div + 1 - i) = morton_binary(length_bin + 1 - i);
    end
    
    % Builds the x and y binary vectors from the interwoven binary
    % morton_index number.
    for i = 1:(int_div/2)    
        x(i) = m(2*i);
        y(i) = m(2*i - 1) ;
    end

    % Converts the binary vector found for x and y into a binary number
    x_number = num2str(x);
    idx=strfind(x_number,' ');
    x_number(idx)=[];
    y_number = num2str(y);
    idx=strfind(y_number,' ');
    y_number(idx)=[];
        
    % Spits out the x and y by converting the binary numbers to decimal
    % numbers
    x = bin2dec(x_number);
    y = bin2dec(y_number);
end

