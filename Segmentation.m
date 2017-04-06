function [ ppgSeg ] = Segmentation( ppgs_preprocess,fps,interval,ppgt,makeplot )
%SEGMENTATION segment preprocessed signal into Pulses
%   first use 1. deritive signal to find the middle point on ascending
%   slope,the find the first minimum point before theses points. Use these
%   minimum points to segment ppg signal.

% Paper: Algorithm for identifying and sparating beats from arterial pulse
% records

%% preprocess
if nargin < 3
    error('the signal should first be propressed');
end

switch nargin
    case 3
        ppgt = 0:1/fps:(length(ppgs_preprocess)-1)*1/fps;
        makeplot = 0;
    case 4
        makeplot = 0;
end

%% find maximum 1. derive point of every pulse in signal, which is similar the 50% point on
%the ascending slope before systolic peak
ppg1derive = diff(ppgs_preprocess);

[m,index]=findpeaks(ppg1derive,'MinPeakHeight',0);%find all the ascending slopes

% find the maximum 1. derive point of every pulse
ii=0;
crit = round(interval*2/3);
temp = index(1);
for k=1:(length(index)-1)
    if (index(k+1)-temp)<crit
        if m(k+1) > m(index==temp)
            temp = index(k+1);
        end
    else
        ii=ii+1;
        c(ii)=temp;
        temp = index(k+1);
    end
end


%% search the beginning points of pulses in one interval before the systolic ascending slopes
p = zeros(1,length(c));

%find the foot of first segment
if c(1)>=3
    [~,b]=findpeaks(-ppgs_preprocess(1:c(1)));
    if ~isempty(b)
                p(1)=b(end);
            else
                p(1)=nan;
    end
else
    p(1)=nan;
end

%find the beginning points of every pulse
for k=2:length(c)
    [~,q]=findpeaks(-ppgs_preprocess(c(k-1)+1:c(k)));
    if ~isempty(q)
        p(k)=q(end)+c(k-1);
    else
        p(k)=nan;
    end
end

p(isnan(p))=[];

% figure;
% plot(ppgt,ppgs_preprocess,ppgt(p),ppgs_preprocess(p),'r*');


%% segmentation base on the beginning points
ppgSeg(1).t=ppgt(1:p(1));
ppgSeg(1).s=ppgs_preprocess(1:p(1));
for x=2:length(p);
    ppgSeg(x).t=ppgt(p(x-1)+1:p(x));
    ppgSeg(x).s=ppgs_preprocess(p(x-1)+1:p(x));
%     plot(ppgSeg(x).t,ppgSeg(x).s)
end

ppgSeg(1)=[];%the first segment is always not complete

%% remove the segment that not suitable

mm=zeros(1,length(ppgSeg));
mmi=zeros(1,length(ppgSeg));

for rr=1:length(ppgSeg)
    mm(rr)=max(ppgSeg(rr).s);
    mmi(rr)=min(ppgSeg(rr).s);
end
mm_average=mean(mm);
mmi_average=mean(mmi);

r=1;
while r<=length(ppgSeg)
    ma = findpeaks(ppgSeg(r).s);
    mai = min(ppgSeg(r).s);
    if ma(1)>1.7*mm_average||ma(1)<0.3*mm_average ...
            ||mai<1.7*mmi_average||mai>0.3*mmi_average ...
            ||length(ppgSeg(r).s)>round(interval*4/3)|| ...
            length(ppgSeg(r).s)<round(interval*2/3)|| ...
                        ma(1) ~= max(ppgSeg(r).s)
%            abs(ppgSeg(r).s(1)-ppgSeg(r).s(end))>0.5*(max(ppgSeg(r).s)-min(ppgSeg(r).s)) ...

        ppgSeg(r)=[];
        r=r-1;
    end
    r=r+1;
end 


if makeplot
     figure;
    plot(ppgt,ppgs_preprocess,ppgt(p),ppgs_preprocess(p),'r*');
    title('preprossed ppg signal with segment points');
    xlabel('time/s');
    ylabel('magnitude');
    grid on;
     figure;
    for ii=1:length(ppgSeg)
        plot(ppgSeg(ii).t,ppgSeg(ii).s)
        hold on
    end
    %ylim([-2,2]);
    title('segments after remove those with artifact');
    xlabel('time/s');
    ylabel('magnitude');
    grid on;
    hold off;
end
end

