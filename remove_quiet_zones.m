function [bar, bar_list, bar_mapping, flag] = remove_quiet_zones(bin_line,lengths,mapping)
    
    %removes everything except segment between 2 quiet zones, with
    %adequate barcode length
    quiet = 0;
    pos = 0;
    last = 0;
    for i = 1:length(mapping)
        last = last + lengths(i);
        if mapping(i) == 5
            quiet = quiet + 1;
            pos = i;
        end
    end
    if quiet == 0
        bar_list = lengths;
        bar_mapping = mapping;
        bar = bin_line;
        flag = 1;
        return;
    end
    if quiet == 1
        if last > (length(bin_line)/2)
            bar_list = lengths(1:pos);
            bar_mapping = mapping(1:pos);
            bar = bin_line(1:(last - lengths(pos)));
            flag = 1;
            return;
        else
            bar_list = lengths(pos+1:end);
            bar_mapping = mapping(pos+1:end);
            bar = bin_line(last+1:end);
            flag = 1;
            return;
        end
    end
    
    bar_len = 0;
    line_len = 0;
    bar_start = 0;
    bar_end = 0;
    line_start = 0;
    line_end = 0;
    for i = 1:length(mapping)
        line_len = line_len + lengths(i);
        if mapping(i) == 5
            if bar_len == 95 || bar_len == 67
                bar_end = i-1;
                line_end = line_len - lengths(i);
                break;
            end
            bar_len = 0;
            bar_start = i+1;
            line_start = line_len + 1;
        else
            bar_len = bar_len + mapping(i);
        end
    end

    if bar_start == 0 || bar_end == 0
        flag = 0;
        bar = 0;
        bar_list = 0;
        bar_mapping = 0;
    else
        bar_list = lengths(bar_start:bar_end);
        bar_mapping = mapping(bar_start:bar_end);
        bar = bin_line(line_start:line_end);
        flag = 1;
    end
end

