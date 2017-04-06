function [ TD,TDt ] = TD( ppgSeg,makeplot )
%TD calculate Time Delay of every pulse of ppg signal
%   with the algorithm of Millasseau th calculate time delay

% Time Delay: the distance of systolic peak and dicrotic peak
% paper: Determination of age-related increases in large artery stiffness
% by digital pulse contour analysis.

%ppgSeg is array of structure, which include information of pulses

if nargin < 2
    makeplot = 0;
end

%calculate TD of each segment

%definition of time delay: the time from systolic peak to dicrotic peak
TD=zeros(1,length(ppgSeg));
TDt=zeros(1,length(ppgSeg));
for k=1:length(ppgSeg)
[m,index]=max(ppgSeg(k).s);
TDt(k)=ppgSeg(k).t(index);
[v,i]=findpeaks(ppgSeg(k).s(index+1:end),'MinPeakHeight',(m-min(ppgSeg(k).s))*0.1+min(ppgSeg(k).s));
i=i+index;
    if ~isempty(v)
    TD(k)=ppgSeg(k).t(i(1))-ppgSeg(k).t(index);
    else
        TD(k)=nan;
    end
end

if makeplot
    figure;
    plot(TDt,TD);
    title('time delay of every pulse');
    xlabel('time of every systolic peak/s');
    ylabel('value of TD');
    grid on;
end

end

