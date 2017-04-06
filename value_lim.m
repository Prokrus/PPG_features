function [min_lim, max_lim ] = value_lim( video_input, bTensor )
%VALUE_LIM get the maximum and minimum value of input mappedtensor or
%memmapfile
%   The result is calculated just to show the video


if nargin<2
    bTensor = 1;
end

if bTensor%mappedtensor
    size_input = size(video_input);
    max_lim = max(max(video_input(:,:,1)));%set the initial value of the limit
    min_lim = min(min(video_input(:,:,1)));
    for fra = 2:size_input(3)  % find the limit value of every frame and update
        max_temp = max(max(video_input(:,:,fra)));
        min_temp = min(min(video_input(:,:,fra)));
        if max_temp > max_lim
            max_lim = max_temp;
        end
        if min_temp < min_lim
            min_lim = min_temp;
        end
    end
else%memmapfile
    max_lim = max(max(video_input.Data(1).frame));%set the initial value of the limit
    min_lim = min(min(video_input.Data(1).frame));
    for fra = 2:video_input.Repeat % find the limit value of every frame and update
        max_temp = max(max(video_input.Data(fra).frame));
        min_temp = min(min(video_input.Data(fra).frame));
        if max_temp > max_lim
            max_lim = max_temp;
        end
        if min_temp < min_lim
            min_lim = min_temp;
        end
    end
end


end

