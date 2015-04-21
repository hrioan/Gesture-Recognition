function A = fusion(B,C)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[m1 n1] = size(B);
[m2 n2] = size(C);

for i=1:m1
    A(i,:) = B(i,:);
end
for i=1:m2
    A(i+m1,:) = C(i,:);
end

