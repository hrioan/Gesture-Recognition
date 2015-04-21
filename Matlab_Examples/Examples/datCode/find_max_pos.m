function pos = find_max_pos(a)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    max = a(1);
    pos = 1;
    for i=2:length(a)
        if (max<a(i))
            pos = i; max = a(i);
        end
    end
end