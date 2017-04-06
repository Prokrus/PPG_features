function [ average_img ] = integral_to_average( original_img,integral_img,filtersize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
size2d = size(original_img);
bound_distance = floor(filtersize/2);
average_img = zeros(size2d(1),size2d(2));
for row =1:size2d(1)
    for col = 1:size2d(1)
        if (row>bound_distance) && (row<size2d(1)-bound_distance) ...
                && (col>bound_distance) && (col<size2d(2)-bound_distance)
            average_img(row,col) = integral_img(row+bound_distance,col+bound_distance) ...
                -integral_img(row-bound_distance,col+bound_distance)...
                -integral_img(row+bound_distance,col-bound_distance)...
                +integral_img(row-bound_distance,col-bound_distance);
        else
            average_img(row,col) = original_img(row,col);
        end
    end
end

end
