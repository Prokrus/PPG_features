function [ interval ] = ppg_period_estimate( s,fps )
%PPG_PERIOD_ESTIMATE estimate interval of PPG signal
%   estimate interval of PPG signal with spectrogram

flimit_l = 0.8;
flimit_r = 3;
num=2^nextpow2(length(s));
s_f=abs(fft(s,num)/num);
s_f_h=2*s_f(1:num/2+1);
f=fps*(0:(num/2))/num;

[loc_max,loc] = findpeaks(s_f_h);
index = 1:length(loc);
f_range = f(loc) >= flimit_l & f(loc) < flimit_r;
index = index(f_range);
[~,hri] = max(loc_max(f_range));
f_interval = f(loc(index(hri)));

% [~,hri]=max(s_f_h(f>=flimit_l&f<=flimit_r));
% f_interval = (f(hri)+flimit_l);

interval=round(fps*1/f_interval);%get estimated beat-beat interval

end