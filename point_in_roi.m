function [ point_out ] = point_in_roi( inter_img,point_loc, rc)
%POINT_IN_ROI calculate the averaged point in ROI through intergral image
%   use definition of intergral image
%[height_old, width_old ] = size(inter_img);

if mod(rc, 2)%size of ROI is odd
    %get the position of four corner points of ROI
    point_a = point_loc - [floor(rc/2), floor(rc/2)];
    point_b = point_loc + [-floor(rc/2), floor(rc/2)];
    point_c = point_loc + [floor(rc/2), -floor(rc/2)];
    point_d = point_loc + [floor(rc/2),floor(rc/2)];
    %calculate the area of ROI
    point_out_area = inter_img(point_d(1),point_d(2))...
        - inter_img(point_c(1),(point_c(2)))...
        - inter_img(point_b(1),point_b(2)) + inter_img(point_a(1),point_a(2));
    
    point_out = point_out_area/(rc^2);%calculate average value of selected point
    
elseif ~mod(rc, 2)%size of ROI is even
    %get the position of four corner points of ROI
    point_a = point_loc - [floor(rc/2), floor(rc/2)];
    point_b = point_loc + [-floor(rc/2), floor(rc/2)-1];
    point_c = point_loc + [floor(rc/2)-1, -floor(rc/2)];
    point_d = point_loc + [floor(rc/2)-1,floor(rc/2)-1];
    %calculate the area of ROI
    point_out_area = inter_img(point_d(1),point_d(2))...
        - inter_img(point_c(1),(point_c(2)))...
        - inter_img(point_b(1),point_b(2)) + inter_img(point_a(1),point_a(2));
    
    point_out = point_out_area/(rc^2);%calculate average value of selected point
end

end

