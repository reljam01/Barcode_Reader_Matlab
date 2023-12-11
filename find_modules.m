function [modules] = find_modules(base_peak, peaks_w, peaks_b)

    modules = base_peak:base_peak:5*base_peak;
    modules(5) = modules(4)*2;

    for j = 2:length(modules)-1
        modules(j) = modules(j-1) + modules(1);
        for i = 2:min(length(peaks_b),length(peaks_w))
            if abs(peaks_b(i) - modules(j)) < modules(1)/2
                if abs(peaks_w(i) - modules(j)) < modules(1)/2
                    modules(j) = (peaks_b(i) + peaks_w(i))/2;
                    break;
                end
            end
        end
    end
end

