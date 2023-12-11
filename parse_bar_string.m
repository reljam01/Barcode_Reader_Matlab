function [bcode] = parse_bar_string(line, lengths, mapping)

    %parses length mappings into a bar code string
    %bar code string example: 101001011.. ..010111101,
    %where 0 represents a black bar module, 1 a white bar module
    bcode = zeros(95,1) - 1;
    pos = 1;
    i = 1;
    curr = 0;
    while pos < length(line)
        if mapping(i) == 5
            pos = pos + lengths(i);
        else
            for j = 1:mapping(i)
                if line(1,pos) == 1
                    bcode(curr+j) = 0;
                else
                    bcode(curr+j) = 1;
                end
            end
            curr = curr + mapping(i);
            pos = pos + lengths(i);
        end
        i = i + 1;
    end
    
    %u bcode je 0 bela, 1 crna
    bcode = bcode + 1;
    bcode = nonzeros(bcode);
    bcode = bcode - 1;
end

