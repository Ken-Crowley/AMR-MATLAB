function [Dcdx, Dcdy] = Del_DP(c,dx,dy)
    
    % This function finds the first derivative finite difference of the 
    % domain parameter, allowing a criteria to be used and set for the
    % AMR technique. 

    % Grabs the size of the matrix (2D)
    [M, N] = size(c);
    
    % Right - Left finite difference (x direction)
    Dcdx = zeros(M,N);
    Dcdx(1:M,2:N-1) = (c(1:M,3:N)-c(1:M,1:N-2))/(2*dx);
    Dcdx(:,1) = 0;
    Dcdx(:,N) = 0;
    
    % Top - Bottom finite difference (y direction)
    Dcdy = zeros(M,N);
    Dcdy(2:M-1,1:N) = (c(1:M-2,1:N)-c(3:M,1:N))/(2*dy);
    Dcdy(1,:) = 0;
    Dcdy(M,:) = 0;
end

