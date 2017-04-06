function [augmentation_index,timepoint] = AI( ppgSeg,makeplot)
%AI calculate Augmentation Index of every pulse of ppg signal
%   with the definition of Kenji Takazawa "the ratio of the height of late
%   systolic peak to that of the early systolic" to calculate this feature

%paper: Assessment of Vasoactive Agents and Vascular Aging by the Second
%Derivative of Pthotoplethysmogram Waveform.

%ppgSeg is array of structure, which include information of pulses

if nargin < 2
    makeplot = 0;
end

%calculate AI of every segment
augmentation_index=zeros(1,length(ppgSeg));
timepoint=zeros(1,length(ppgSeg));
    for k=1:length(ppgSeg)
    [m, index]=max(ppgSeg(k).s);
    timepoint(k)=ppgSeg(k).t(index);
    h=(m-min(ppgSeg(k).s))*0.1+min(ppgSeg(k).s);
    [v,~]=findpeaks(ppgSeg(k).s(index+1:end),'MinPeakHeight',h);

        if ~isempty(v)
           augmentation_index(k)=(v(1)-min(ppgSeg(k).s))/(m-min(ppgSeg(k).s));
        else 
            augmentation_index(k)=nan;  
        end
    end
    
if makeplot
    figure;
    plot(timepoint,augmentation_index);
    title('augmentation index of every pulse');
    xlabel('time of every systolic peak/s');
    ylabel('value of AI');
    grid on;
end

end

