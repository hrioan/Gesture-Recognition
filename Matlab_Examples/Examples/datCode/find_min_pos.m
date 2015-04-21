function pos = find_min_pos(a)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    min = a(1);
    pos = 1;
    for i=2:length(a)
        if (min>a(i))
            pos = i; min = a(i);
        end
    end
end

