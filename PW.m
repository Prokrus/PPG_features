function [ PW,PWt ] = PW( ppgSeg,makeplot )
%PW calculate Pulse Width of every pulse of ppg signal
%   calculate the distance of the %50 points on ascending and descending
%   slopes.

%Paper: The relationship between the photoplethysmographic waveform and
%systemic vascular resistance.

%ppgSeg is array of structure, which include information of pulses

if nargin < 2
    makeplot = 0;
end


%calculate pulsewidth of every pulse
PW=zeros(1,length(ppgSeg));
PWt=zeros(1,length(ppgSeg));
for k=1:length(ppgSeg)
    [m,indexm]=max(ppgSeg(k).s);
    PWt(k)=ppgSeg(k).t(indexm);
    mid=(m+ppgSeg(k).s(1))/2;%mid punkt finden
    x=interp1(ppgSeg(k).s(1:indexm),ppgSeg(k).t(1:indexm),mid);
    y=interp1(ppgSeg(k).s(indexm:end),ppgSeg(k).t(indexm:end),mid);
    PW(k)=y-x;%pulsewidth
end

if makeplot
    figure;
    plot(PWt,PW);
    title('pulse width of every pulse');
    xlabel('time of every systolic peak/s');
    ylabel('value of PW');
    grid on;
end

end

