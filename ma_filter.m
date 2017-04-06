function [ outcome ] = ma_filter( signal, len )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

len_signal = length(signal);
outcome = zeros(1,len_signal);
if mod(len,2)
    range1 = floor(len/2);
    for sii = 1:len_signal
        leftlim = max(sii-range1,1);
        rightlim = min(sii+range1,len_signal);
        outcome(sii) = mean(signal(leftlim:rightlim));
    end
else
    range2 = len/2;
    for sii = 1:len_signal
        leftlim = max(sii-range2,1);
        rightlim = min(sii+range2-1,len_signal);
        outcome(sii) = mean(signal(leftlim:rightlim));
    end
end


