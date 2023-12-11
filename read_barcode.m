function [bar_code, found] = read_barcode(I,num_scans)

    I = im2gray(I);
    [y, x] = size(I);
    bar_code = zeros(13,1) - 1;
    found = 0;
    
    if (x<=95) || (y<=95)
        %nema dovoljno pixela za sliku
        return;
    else
        dscan_y = floor(y / (num_scans + 2)); %razdaljina izmedju sken linija
        codes_found = 0;
        for line = dscan_y:dscan_y:dscan_y*(num_scans+1)

            L = I(line,:);

            %trazenje optimalnog praga linije
            T = graythresh(L);
            bw_L = imbinarize(L,T);         %ovo je binarizovana 1 scan linija

            %prvo nalazimo listu i histograme duzina segmenata iste boje na
            %binarizovanoj slici
            [len_list, len_hist_w, len_hist_b] = make_histograms(bw_L);

            %trazimo pikove za bele i crne linije
            len_peaks_w = find_peaks(len_hist_w);
            len_peaks_b = find_peaks(len_hist_b);

            %ako nismo nasli pikove, linija sigurno ne sadrzi bar kod
            if isempty(len_peaks_b) || isempty(len_peaks_w)
                continue;
            end

            %poredjenje crnih i belih pikova
            [base_peak, bp_found] = find_base_peak(len_peaks_w, len_peaks_b);
            if ~bp_found
                continue;
            end

            %pronadjemo duzine modula
            len_moduli = find_modules(base_peak, len_peaks_w, len_peaks_b);

            %kategorizujemo duzine po modulima

            len_map = fit_modules(len_list, len_moduli);

            %uzimanje regiona izmedju tihih zona
            [bw_L, len_list, len_map, flag] = remove_quiet_zones(bw_L, len_list, len_map);
            if ~flag
                continue;
            end

            %pravimo duzine prema modulima
            bcode = parse_bar_string(bw_L,len_list,len_map);

            %tumacimo brojeve sa zeljenog selektovanog dela linije
            if length(bcode) == 95
                [kod, potvrda] = decode_bar_EAN_13(bcode);
            else
                if length(bcode) == 67
                    [kod, potvrda] = decode_bar_EAN_8(bcode);
                    bar_code = bar_code(1:8);
                else
                    potvrda = 0;
                end
            end

            %pronadjen kod na liniji!
            if potvrda
                bar_code = kod;
                codes_found = codes_found + 1;
            else
                continue;
            end
        end
    end

    if codes_found > 0
        found = 1;
    end
end

