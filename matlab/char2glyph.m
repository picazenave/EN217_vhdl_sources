function [output] = char2glyph(input)
%CHAR2GLYPH Summary of this function goes here
%   Detailed explanation goes here
    if (input >= 97)
        output= input - 97 + 10;
    elseif (input >= 48) && (input <= 57)
        output= input - 48;
    elseif(input==double(char(' ')))
       output= 36;
    else
        output=64;
    end
end

