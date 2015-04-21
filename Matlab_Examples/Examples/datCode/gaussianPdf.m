function p = gaussianPdf(x,m,S)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
l=2;

synt = 1/(((2*pi)^(l/2))*(det(S)^(1/2)));

e = -0.5*((x-m)/S)*(x-m)';
p = synt * exp(e);

end

