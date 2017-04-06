function [ s ] = interpolation( s,t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

nd = ndims(s);
if nd >= 3
    error('This function is only suitable for 2D signal.');
else
    vacant = find(isnan(s));
    index_value = 1:length(t);
    index_value(vacant) = [];
    vvacant = interp1(t(index_value),s(index_value),t(vacant),'pchip');
    s(vacant) = vvacant;%interpolation to make the signal contineous
end

end

