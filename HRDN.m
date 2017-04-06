function [ HRDN,HRDNt ] = HRDN( ppgSeg,makeplot)
%HRDN calculate Half rise to dicrotic notch of every pulse of ppg signal
%   calculate the distance from %50 point on ascending slope to dicrotic
%   notch.

%paper: Inverstigation of phtoplethysmogram morphology for the detection of 
%hypovolemic states.
%HRDN:the time from sharpest point on the ascending slope before systolic
%peak to dicrotic notch

%ppgSeg is array of structure, which include information of pulses

if nargin < 2
    makeplot = 0;
end


%with the algorithm of Cox to calculate HRDN
HRDN=zeros(1,length(ppgSeg));
HRDNt=zeros(1,length(ppgSeg));
for k=1:length(ppgSeg)
    [~,tindex] = max(ppgSeg(k).s);
    HRDNt(k) = ppgSeg(k).t(tindex);
    [~,index]=max(diff(ppgSeg(k).s));
    [~,minP]=findpeaks(-ppgSeg(k).s(index+1:round(0.9*end)));
    if ~isempty(minP)
        minP(1)=minP(1)+index;
           HRDN(k)=ppgSeg(k).t(minP(1))-ppgSeg(k).t(index);
    else
        HRDN(k)=nan;
    end

end

if makeplot
    figure
    plot(HRDNt,HRDN);
    title('Half Rise to Dicrotic Notch of every pulse');
    xlabel('time of every systolic peak/s');
    ylabel('value of HRDN');
    grid on;
end

end