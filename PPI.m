function [ PPI,PPIt ] = PPI(ppgSeg,interval,fps,makeplot )
%PPI calculate PPI between two pulses of ppg signal
%   calculate the distance between one pulse and its previous pulse.

%paper: photoplethysmography pulse rate variability as a surrogate
%measurement of heart rat variability during non-stationary conditions.

%ppgSeg is array of structure, which include information of pulses

if nargin < 3
    makeplot = 0;
end


%calculate peak to peak interval between every pulses
PPI=zeros(1,length(ppgSeg)-1);
PPIt=zeros(1,length(ppgSeg)-1);
mindex=zeros(1,length(ppgSeg));
for k=1:length(ppgSeg)    
    [~,mindex(k)]=max(ppgSeg(k).s);
    if k>=2
        PPI(k-1)=ppgSeg(k).t(mindex(k))-ppgSeg(k-1).t(mindex(k-1));
        PPIt(k-1)=ppgSeg(k-1).t(mindex(k-1));
        if PPI(k-1) > 1.5*interval/fps
            PPI(k-1)=nan;
        end
    end

end

if makeplot
    figure
    plot(PPIt,PPI);
    title('peak-peak interval of every two pulses');
    xlabel('time of every systolic peak/s');
    ylabel('value of PPI');
    grid on;
end

end

