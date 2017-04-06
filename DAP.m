function [ dap ] = DAP( ppgs,fps,ppgt,artifactPlot,envelopePlot )
%DAP get all Amplitude fluctuation of PPG
%   use the algorithm of Gil to calculate the DAP information

% Paper: Detection of decreases in the amplitude fluctuation of pulse
% photoplethysmography signal as indication of obstructive sleep apnea
% syndrome in children.

% Paper: OSAS detection in children by using PPG amplitude fluctuation
% decreases and pulse rate variability.

% Paper: Discrimination of Sleep-Apnea-Related Decreases in the Amplitude
% Fluctuations of PPG Signal in Children by HRV Analysis.

[ppgspre,interval]=preprocess(ppgs,fps,ppgt);

if nargin<4
    artifactPlot=0;
end
if nargin<5
    envelopePlot=0;
end

wi0=zeros(1,length(ppgspre)-2);
wi2=zeros(1,length(ppgspre)-2);
wi4=zeros(1,length(ppgspre)-2);
h1=zeros(1,length(ppgspre)-2);
h2=zeros(1,length(ppgspre)-2);

pd1=diff(ppgspre);
pd2=diff(pd1);

P=round(1.5*interval);
for k=P:length(ppgspre)-2
    wi0(k)=2*pi*sqrt(sum(ppgspre(max(k-(P-1),1):k).^2))/P;
    wi2(k)=2*pi*sqrt(sum(pd1(max(k-(P-1),1):k).^2))/P;
    wi4(k)=2*pi*sqrt(sum(pd2(max(k-(P-1),1):k).^2))/P;
    h1(k)=sqrt(wi2(k)/wi0(k));
    h2(k)=abs(sqrt(wi4(k)/wi2(k)-wi2(k)/wi0(k)));
end

n1u=mean(h1)*1.3;
n1l=mean(h1)*0.7;
n2u=mean(h2)*1.5;

art=find(h1<=n1l|h1>=n1u|h2>=n2u);

if artifactPlot
    subplot(2,1,1)
    plot(ppgt(1:end-2),h1)

    line('Xdata',[20000,55000],'Ydata',[n1u,n1u],'Color','r');
    line('Xdata',[20000,55000],'Ydata',[n1l,n1l],'Color','r');
    grid on
    title('h1')
    subplot(2,1,2)
    plot(ppgt(1:end-2),h2)

    line('Xdata',[20000,55000],'Ydata',[n2u,n2u],'Color','r');
    grid on
    title('h2')
end

xe=zeros(1,length(ppgspre));
Np=1.5*interval;
for kk=1:length(ppgspre)
    xe(kk)=sqrt(1/Np*sum(ppgspre(max(kk-(Np-1),1):kk).^2));
end

if envelopePlot
    plot(ppgt,xe);
    hold on;
    plot(ppgt,ppgspre,'r');
    hold off;
end

apnea=0;
a=0;
zeta=zeros(1,length(ppgspre));
zeta(1)=0.5*xe(1);
for kkk=2:length(ppgspre)
    if xe(kkk)<zeta(kkk-1)
        ii=kkk;
        nn=0;
        while ii>0&&xe(ii-1)<zeta(ii-1)
            nn=nn+1;
            ii=ii-1;
        end
        if nn>=2*interval
%            apnea=apnea+1;
            zeta(kkk)=zeta(kkk-1);
        end
    elseif any(art==kkk)
        zeta(kkk)=zeta(kkk-1);
    elseif abs(xe(kkk)-xe(kkk-1))>(max(ppgspre(1:interval))-min(ppgspre(1:interval)))*0.5*5/fps;
        zeta(kkk)=zeta(kkk-1);
    else
        a=a+1;
        na(a)=kkk;
        li=max(a-interval,1);
        zeta(kkk)=mean(xe(na(li:a)))*0.5;
    end
end

num=0;
for kkkk=1:length(ppgspre)

    if xe(kkkk)<zeta(kkkk)&&~any(art==kkkk)
        num=num+1;
        if num==2*interval
            apnea=apnea+1;
        end
    else
        num=0;
    end
end

dap=apnea/(length(ppgspre)/fps/3600);

            
    
    

% 
% activ=var(ppgspre);
% md=diff(ppgspre);
% mv=var(md);
% mob=sqrt(mv/activ);
% mdd=diff(md);
% mvv=var(mdd);
% comp=sqrt(mvv/mv)/mob;
% sp=spectrogram(ppgspre,300);
% spectrogram(ppgspre,'yaxis')

end

