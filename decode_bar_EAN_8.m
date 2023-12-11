function [code, flag] = decode_bar_EAN_8(bcode)

    str = string(bcode);
    str = strjoin(str);
    str = erase(str," ");
    %create code
    code = zeros(8,1)-1;

    if startsWith(str,'101') && endsWith(str,'101') && strcmp(extractBetween(str,32,36),'01010')
        flag = 1;
    else
        flag = 0;
        return;
    end

    if mod(count(extractBetween(str,4,11),'1'),2) == 0
        str = reverse(str);
    end

    L = ['0001101'; '0011001'; '0010011'; '0111101'; '0100011';
        '0110001'; '0101111'; '0111011'; '0110111'; '0001011'];

    R = ['1110010'; '1100110'; '1101100'; '1000010'; '1011100';
        '1001110'; '1010000'; '1000100'; '1001000'; '1110100'];


    for j = 1:4
        for k = 1:10
            if strcmp(extractBetween(str,(j-1)*7+4,j*7+3),L(k,:))
                code(j) = k-1;
                break;
            end
        end
    end

    for j = 5:7
        for k = 1:10
            if strcmp(extractBetween(str,(j-1)*7+9,j*7+8),R(k,:))
                code(j) = k-1;
                break;
            end
        end
    end

    %calculating checksum
    suma = 0;
    for i = 1:7
        curr = code(i);
        if mod(code(i),2) == 0
            curr = curr * 3;
        end
        suma = suma + curr;
    end

    code(8) = 10 - mod(suma,10);
    if code(8) == 10
        code(8) = 0;
    end
    
    for i = 1:8
        if code(i) == -1
            flag = 0;
            return;
        end
    end
end

