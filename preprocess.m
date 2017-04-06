function [ preprocessed,interval ] = preprocess( s,fps,t, make_plots )
% PREPROCESS preprocess ppg signal before segmentation
%preprocess function include 'interpolation','detrend',and 'bessel filter'

% With this function ppg signal is preprocessed for Segmentation function.
% Detrend_paper: Analysis of photoplethysmographic signals of
% cardiovascular patients.


%% initialization

switch nargin
    case 1
        error('arguments should include fps');
    case 2
        t = 0:1/fps:(length(s)-1)*1/fps;
        make_plots = 0;
    case 3
        make_plots = 0;
end

if ~isa(s,'double')
    s = double(s);
end
%% interpolation

    s = squeeze(s);
if any(isnan(s))
    s = interpolation(s,t);
end

[srow,scol] = size(s);
if srow > scol
    s = s';
end

%% Beat interval estimate

interval = ppg_period_estimate(s,fps);
%interval = psd_interval_estimate(s,fps);


%% detrend & remove DC component

trend = ma_filter(s,interval);
detrended = s-trend;%detrend
% detrended = detrend(s);
% plot(t,ppgs_Lowfilter)
% hold on
% plot(t,ppgs_detrend,'r')
%% lowfilter
constant_delay_fre = 10;
degree = 5;
lowfiltered = bessel_filter(detrended,fps,constant_delay_fre,degree);
% plot(t(10000:30000),lowfiltered(10000:30000));
% hold on;
% plot(t(10000:30000),detrended(10000:30000),'r');
% hold off;


%% result

preprocessed = lowfiltered;

%% plot
if make_plots
    figure;
%spectral of original ppg signal
subplot(3,1,1);
signal_spec(s,fps);
title('spectrogram of original signal');

%spectral after loefilter
subplot(3,1,2);
signal_spec(detrended,fps);
title('spectrogram of detrended signal');

%spectral after detrend
subplot(3,1,3)
signal_spec(lowfiltered,fps);
title('spectrogram of lowfiltered signal');

end


end

