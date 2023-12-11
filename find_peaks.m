function [peaks] = find_peaks(hist)

    %finds peaks in histogram
    %in case of equal neighbouring bins, the latter is chosen as a peak
    
    peaks = zeros(length(hist),1);
    p = 1;
    for i = 2:length(hist)-1
        if (hist(i) >= hist(i-1)) && (hist(i) > hist(i+1))
            peaks(p) = i;
            p = p + 1;
        end
    end
    peaks = nonzeros(peaks);
end

