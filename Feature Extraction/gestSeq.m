function output_str = gestSeq(Labels, ngest, gesIds)

    output_str = [];

    if ngest ~= 0
        for i1 = 1:ngest
            for i2 = 1:length(gesIds)

                if(strcmp(Labels(i1).Name, gesIds(i2).Gesture))
                    %output_str = sprintf('%s_%d', output_str, gesIds(i2).Id);

                    output_str = [ output_str gesIds(i2).Id];  %append(output_str, gesIds(i2).Id);

                    break;
                end
            end
        end
    end
end