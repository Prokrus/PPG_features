function [ IHAR,IHARt ] = IHAR( ppgSeg,ipa,makeplot )
%IHAR calculate "Inflection and Harmonic area ratio" of every pulse of ppg
%signal
%   base on IPA and NHA to calculate IHAR.

%paper: Noninvasive cardiac output estimation using a novel
%photoplethysmogram index.

%ppgSeg is array of structure, which include information of pulses

if nargin < 3
    makeplot = 0;
end

% if nargin<6
%  ppgSeg=Segmentation(ppgt,ppgs,fps);%segmentation
% if nargin<5
%    makeplot=false;
%    if nargin<4
%     ipa=IPA(ppgt,ppgs,fps);
%     end
% end
% end

IHAR=zeros(1,length(ppgSeg));
IHARt=zeros(1,length(ppgSeg));
for k=1:length(ppgSeg)
    [~,pos]=max(ppgSeg(k).s);
    IHARt(k)=ppgSeg(k).t(pos);
    if ~isnan(ipa(k))
     len = 2^nextpow2(length(ppgSeg(k).s));
    spec = abs(fft(ppgSeg(k).s,len)/len);
    spec_h = 2*spec(1:len/2+1);
%    spec_f = fps*(0:len/2)/len;
    [~,freMaxP] = findpeaks(spec_h);
    nha = sum(spec_h(freMaxP(2:end)).^2)/sum(spec_h(freMaxP).^2);
    IHAR(k)=(1-nha)/ipa(k);
    else
        IHAR(k)=nan;
    end
end

if makeplot
    figure;
    plot(IHARt,IHAR);
    title('Inflection and Harmonic area ratio of every pulse');
    xlabel('time of every systolic peak/s');
    ylabel('value of IHAR');
    grid on;
end

