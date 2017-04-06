function [ pat,patt ] = PAT( ecgt,ecgs,ppgSeg,interval,makeplot)
%PAT caculate Pulse Arrive Time with PPG and ECG signal
%   calculate the time from R wave in ECG singal to %50 point in ascending
%   slope in PPG signal.

%paper: Continuous Blood Pressure Monitoringt using ECG and Finger
%Photoplethysmogram.

%ppgSeg is array of structure, which include information of ppg pulses

if nargin < 5
    makeplot = 0;
end


pat=zeros(1,length(ppgSeg));
patt=zeros(1,length(ppgSeg));
for k=1:length(ppgSeg)
    [~,mp] = max(ppgSeg(k).s);
    patt(k) = ppgSeg(k).t(mp);
    ppg1derive = diff(ppgSeg(k).s);
    [~,l] = max(ppg1derive);
    eind=find(ecgt == ppgSeg(k).t(l));
    [~,le]=max(ecgs(max(eind-interval,1):eind));
    
    pat(k)=ppgSeg(k).t(l)-ecgt(max(eind-interval,1)-1+le);
    
end
pat(1) = nan;
if makeplot
    figure;
    plot(patt,pat);
    title('Pulse arrival time of every pulse');
    xlabel('time of every systolic peak/s');
    ylabel('value of PAT');
    grid on;
end
end

