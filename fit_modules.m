function [mapping] = fit_modules(lengths, modules)

    %maps modules to lengths on line
    mapping = zeros(length(lengths),1);
    for i = 1:length(lengths)
        delta_len = abs(lengths(i)-modules(1));
        mapping(i) = 1;
        for j = 2:length(modules)
           if delta_len > abs(lengths(i)-modules(j))
               mapping(i) = j;
               delta_len = abs(lengths(i)-modules(j));
           end
        end
    end
end

