function [ img_out ] = image_intergral(img_in )
%IMGAGE_INTERGRAL calculate intergral image of input image
%   use the definition of intergral image

[w, h] = size(img_in);
%calculate intergral image
img_out = zeros(w,h);
for row = 1:w
    for col = 1:h
        if row == 1 && col == 1             %first pixel
            img_out(row,col) = img_in(row,col);
        elseif row == 1 && col ~= 1         %first row
            img_out(row,col) = img_out(row,col-1) + img_in(row,col);
        elseif row~=1 && col == 1         %first column
            img_out(row,col) = img_out(row-1,col) + img_in(row,col);
        else                        %other pixels
            img_out(row,col) = img_in(row,col) + img_out(row-1,col) + img_out(row,col-1) - img_out(row-1,col-1);
        end
    end
end

end

