function A = eigenSort(D,V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[m, n] = size(D);
A = zeros(n,n);
d = zeros(n,1);
d(1) = D(1,1);
d(2) = D(2,2);

if (d(1)<d(2))
    A(:,1) = V(:,2);
    A(:,2) = V(:,1);
else
    A(:,1) = V(:,1);
    A(:,2) = V(:,2);
end
