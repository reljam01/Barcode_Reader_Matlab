function [len_list, len_hist_w, len_hist_b] = make_histograms(bin_line)

    %makes list of lengths of different color chain pixels, 
    %and histograms of white and black lengths of binarized image line
    %input arguments: bin_line - binarized line (array) of pixels
    %outputs: len_list - list of lengths of same color pixel segments, 
                        %from start to end of line
             %len_hist_w - histogram for white pixel lengths
             %len_hist_b - histogram for black pixel lengths
             
    len_list = zeros(length(bin_line),1);
    len_hist_w = zeros(length(bin_line)+1,1);
    len_hist_b = zeros(length(bin_line)+1,1);

    curr_len = 1;
    curr_pix = bin_line(1,1);
    j = 1;

    for i = 2:length(bin_line)
        if curr_pix == bin_line(1,i)
            curr_len = curr_len + 1;
            counted = 1;
        else
            len_list(j) = curr_len;
            if curr_pix
                len_hist_w(curr_len) = len_hist_w(curr_len) + 1;
            else
                len_hist_b(curr_len) = len_hist_b(curr_len) + 1;
            end
            curr_len = 1;
            curr_pix = bin_line(1,i);
            j = j + 1;
            counted = 0;
        end
    end

    if counted
        len_list(j) = curr_len;
        if curr_pix
            len_hist_w(curr_len) = len_hist_w(curr_len) + 1;
        else
            len_hist_b(curr_len) = len_hist_b(curr_len) + 1;
        end
    end

    len_list = nonzeros(len_list);
    len_hist_w = cutoff_histogram(len_hist_w);
    len_hist_b = cutoff_histogram(len_hist_b);
end

