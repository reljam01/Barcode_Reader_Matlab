function [code, flag] = decode_bar_EAN_13(bcode)

    str = string(bcode);
    str = strjoin(str);
    str = erase(str," ");

    code = zeros(13,1)-1;

    if startsWith(str,'101') && endsWith(str,'101') && strcmp(extractBetween(str,46,50),'01010')
        flag = 1;
    else
        flag = 0;
    end

    if mod(count(extractBetween(str,4,11),'1'),2) == 0
        str = reverse(str);
    end

    L = ['0001101'; '0011001'; '0010011'; '0111101'; '0100011';
        '0110001'; '0101111'; '0111011'; '0110111'; '0001011'];

    G = ['0100111'; '0110011'; '0011011'; '0100001'; '0011101'; 
        '0111001'; '0000101'; '0010001'; '0001001'; '0010111'];

    R = ['1110010'; '1100110'; '1101100'; '1000010'; '1011100';
        '1001110'; '1010000'; '1000100'; '1001000'; '1110100'];

    first_string = extractBetween(str,4,10);
    for i = 1:10
        if strcmp(first_string,L(i,:))
            first_digit = i-1;
            code(2) = first_digit;
            break;
        end
    end

    if code(2) == -1
        flag = 0;
        return;
    end
    
    for j = 2:6
        set = 0;
        for k = 1:10
            if strcmp(extractBetween(str,(j-1)*7+4,j*7+3),L(k,:))
                code(j+1) = k-1;
                set = 1;
                break;
            end
        end
        if set == 1
            continue;
        end
        for k = 1:10
            if strcmp(extractBetween(str,(j-1)*7+4,j*7+3),G(k,:))
                code(j+1) = k-1;
                break;
            end
        end
    end

    for j = 7:12
        for k = 1:10
            if strcmp(extractBetween(str,(j-1)*7+9,j*7+8),R(k,:))
                code(j+1) = k-1;
                break;
            end
        end
    end

    
    %calculating checksum
    suma = 0;
    for i = 2:13
        curr = code(i);
        if mod(code(i),2) == 0
            curr = curr * 3;
        end
        suma = suma + curr;
    end

    code(1) = 10 - mod(suma,10);
    if code(1) == 10
        code(1) = 0;
    end
    
    for i = 1:length(code)
        if code(i) == -1
            flag = 0;
        end
    end
end

