function [base_peak,found] = find_base_peak(len_peaks_w,len_peaks_b)

    %finds first peak for module length
    if len_peaks_w(1) ~= len_peaks_b(1)
        if (len_peaks_b(1) > (len_peaks_w(1)/2))&&((len_peaks_b(1)*2) > len_peaks_w(1))
            base_peak = round((len_peaks_b(1)+len_peaks_w(1))/2);
            found = 1;
        else
            base_peak = -1;
            found = 0;
        end
    else
        base_peak = len_peaks_w(1);
        found = 1;
    end
    
end

