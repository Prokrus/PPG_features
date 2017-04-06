function [ IPA,IPAt ] = IPA( ppgSeg,makeplot )
%IPA calculate "Inflection point area ratio" of every pulse of ppg signal
%   calculate the ratio of the area after notch to the area before notch in one
%   pulse

%paper: Nonivasive cardiac output estimation using a novel
%photoplethysmogram index

%ppgSeg is array of structure, which include information of pulses
if nargin < 2
    makeplot = 0;
end


% calculate Inflection Point Area of every pulse
IPA=zeros(1,length(ppgSeg));
IPAt=zeros(1,length(ppgSeg));
for k=1:length(ppgSeg)
    [~,minP]=findpeaks(-ppgSeg(k).s(1:round(0.9*end)));
    [~,maxP]=max(ppgSeg(k).s);
    IPAt(k)=ppgSeg(k).t(maxP);
    if ~isempty(minP)            
            A1=trapz(ppgSeg(k).t(1:minP(1)),ppgSeg(k).s(1:minP(1))-min(ppgSeg(k).s));
            A2=trapz(ppgSeg(k).t(minP(1):end),ppgSeg(k).s(minP(1):end)-min(ppgSeg(k).s));
           IPA(k)=A2/A1;
    else
        IPA(k)=nan;
    end
end

if makeplot
    figure;
    plot(IPAt,IPA);
    title('inflection point area ratio of every pulse');
    xlabel('time of every systolic peak/s');
    ylabel('value of IPA');
    grid on;
end

end

