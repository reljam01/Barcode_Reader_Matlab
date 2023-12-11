function [cut_hist] = cutoff_histogram(hist)
    %cuts off zeroes on the end of the histogram
    max_hist = 0;
    for i = 1:length(hist)
        if hist(i) > 0
            max_hist = i;
        end
    end
    cut_hist = hist(1:max_hist+1);
end

