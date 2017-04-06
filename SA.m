function [ sa,sat ] = SA( ppgSeg,makeplot )
%SA calculate Systolic Amplitude of every Pulse
%   use Algorithm of Chua to calculate Systolic Amplitude

% Paper: Continuous Blood Pressure Monitoring using ECG and Finger
% Photoplethysmogram.

%ppgSeg is the array of structures, which include  information of pulses

if nargin<2
    makeplot = 0;
end


% calculate systolic amplitude of every pulse
sa=zeros(1,length(ppgSeg));
sat=zeros(1,length(ppgSeg));
%calculate the maxinum points of every segment
for k=1:length(ppgSeg)
    [ma,index]=max(ppgSeg(k).s);
    sat(k)=ppgSeg(k).t(index);
    sa(k)=ma-ppgSeg(k).s(1);
end

if makeplot
    figure;
    plot(sat,sa,'Marker','o');
    title('systolic of every pulse');
    xlabel('time of every systolic peak/s');
    ylabel('value of SA');
    grid on;
end

end

