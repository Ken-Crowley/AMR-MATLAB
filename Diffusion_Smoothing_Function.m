function dcdt = Diffusion_Smoothing_Function(A,h)

    [M, N] = size(A);
    dcdt = zeros(M,N);
    
    % Middle Section
	dcdt(2:(M-1),2:(N-1)) = (A(2:(M-1),3:N) + A(2:(M-1),1:(N-2)) ...
	+ A(1:(M-2),2:(N-1)) + A(3:M,2:(N-1)) -4*A(2:(M-1),2:(N-1)))/h^2;
	
	% Left Section
	dcdt(2:(M-1),1) = (2*A(2:(M-1),2) + A(1:(M-2),1) + A(3:M,1) - 4*A(2:(M-1),1))/h^2;
	
	% Right Section
	dcdt(2:(M-1),N) = (2*A(2:(M-1),N-1) + A(1:(M-2),N) + A(3:M,N) - 4*A(2:(M-1),N))/h^2;
	
	% Top Section
	dcdt(1,2:(N-1)) = (A(1,1:(N-2)) + A(1,3:N) + 2*A(2,2:(N-1)) - 4*A(1,2:(N-1)))/h^2;
	
	% Bottom Section
	dcdt(M,2:(N-1)) = (A(M,1:(N-2)) + A(M,3:N) + 2*A(M-1,2:(N-1)) - 4*A(M,2:(N-1)))/h^2;
	
	% NW Corner
	dcdt(1,1) = (2*A(1,2) + 2*A(2,1) - 4*A(1,1))/h^2;
	
	% SW Corner
	dcdt(M,1) = (2*A(M,2) + 2*A((M-1),1) - 4*A(M,1))/h^2;
	
	% NE Corner
	dcdt(1,N) = (2*A(1,(N-1)) + 2*A(2,N) - 4*A(1,N))/h^2;
	
	% SE Corner
	dcdt(M,N) = (2*A(M,(N-1)) + 2*A((M-1),N) - 4*A(M,N))/h^2;
end

