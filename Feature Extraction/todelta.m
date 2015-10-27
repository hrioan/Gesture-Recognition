function [ cmatx ] = todelta( mtx, NN )
%Extracts the delta coefficients and appends them to the matrix, similar to
%delta MFCCs

% get size of matrix
[N,m] = size(mtx);

% matrix where we incorporate each frame's coeffs with the delta values
cmatx = zeros(N-2,m+m);

for t=2:N-1
dt = zeros(m,1);

nm = zeros(m,1);
dnm = 0;
for n=1:NN
    nm = nm + n*(mtx(t+n,:)' - mtx(t-n,:)');
    dnm = dnm + n^2;
end
dnm = 2*dnm;

dt = nm/dnm;

% append the delta to the coefficient vector for the specific frame

cmatx(t-1,:) = [ mtx(t,:) dt'];  

end
end
