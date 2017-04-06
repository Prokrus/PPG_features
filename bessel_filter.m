function [ lowfiltered ] = bessel_filter( s,fps,constant_delay_fre ,degree)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[bx,ax] = besself(degree,constant_delay_fre*2*pi);
[bz,az] = bilinear(bx,ax,fps);
%fvtool(bz,az);
len = length(s);
num = 2^nextpow2(len);
grp = grpdelay(bz,az,num);
delaynum = round(constant_delay_fre/(fps/2)*length(grp));
%delaynum1 = round(constant_delay_fre(1)/(fps/2)*length(grp));
% delaynum2 = round(constant_delay_fre(2)/(fps/2)*length(grp));
delay = round(mean(grp(1:delaynum)));
s = [s zeros(1,delay)];
lowfilter_delay = filter(bz,az,s);
lowfiltered = lowfilter_delay(delay+1:end);

end

