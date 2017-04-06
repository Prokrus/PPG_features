function [ time_s_mafiltered ] = time_point_gui( video_sequence,fs,bInvert,bTensor,isintergral )
%TIME_POINT_GUI show the time series of intergral video of gaussian blured
%video and the following processed time series.
%   For intergral video try different size of ROI and select best one to
%   use for the size of gaussian filter.



%get first frame of input video
if bTensor
    video_1frame = video_sequence(:,:,1);
else
    video_1frame = video_sequence.Data(1).frame;
end
%figure;

%get input point location
% imagesc(video_1frame);
% axis image
% [xindex,yindex] = ginput(1);
% cindex = round(xindex);
% rindex = round(yindex);


rindex = 60;
cindex = 60;

point_loc = [rindex,cindex];

%get time series of the selected point location along time dimension
if bTensor
    time_s = squeeze(video_sequence(rindex,cindex,:));
else
    time_s = zeros(1,video_sequence.Repeat);
    for  zz = 1 : video_sequence.Repeat
        img = video_sequence.Data(zz).frame;
        time_s(zz) = img(rindex,cindex);
    end
    
end
time_s = double(time_s);
tt = 0:1/fs:(length(time_s)-1)*1/fs;

if isintergral %for intergral video need to calculate averaged value in ROI first
    if bTensor
        sizevideo = size(video_sequence);
        roi_min = 3;
        roi_max = min([rindex*2-1, cindex*2-1, (sizevideo(1)-rindex)*2+1, (sizevideo(2)-cindex)*2+1]);
        if ~mod(roi_max, 2)
            roi_max = roi_max -1;
        end
        step =2;
        num_roi = (roi_max - roi_min)/step + 1;%the number of sizes of ROI
        point_series_group = zeros( num_roi, sizevideo(3));
        for rc = roi_min:step:roi_max
            rc_index = (rc - roi_min)/step + 1;
            for fra = 1:sizevideo(3)
                ima = video_sequence(:,:,fra);
                point_series_group(rc_index, fra) = point_in_roi(ima, point_loc, rc);%calculate averaged value through intergral image
            end
        end
    else
        sizeframe = size(video_sequence.Data(1).frame);
        roi_min = 3;
        roi_max = min([rindex*2-1, cindex*2-1, (sizeframe(1)-rindex)*2+1, (sizeframe(2)-cindex)*2+1]);
        if ~mod(roi_max, 2)
            roi_max = roi_max -1;
        end
        step =2;
        num_roi = (roi_max - roi_min)/step + 1;
        point_series_group = zeros(num_roi , video_sequence.Repeat);
        for rc = roi_min:step:roi_max
            rc_index = (rc - roi_min)/step + 1;
            for fra = 1:video_sequence.Repeat
                ima = video_sequence.Data(fra).frame;
                point_series_group( rc_index, fra) = point_in_roi(ima,point_loc,rc);%calculate averaged value through intergral image
            end
        end
    end
    
    %finally get a matrics 'point_series_group', which include the time
    %series of different size of ROI.
    
    
    time_figure = figure;%creat a figure to show the original and processed time series.
    
    %show the time series in intergral video
    ori_plot = subplot(4,1,1);
    plot(ori_plot,tt,time_s);
    title(['intergral image time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
    xlabel('time/s');
    ylabel('value');
    
    %show averaged time series, which is calculated from intergral video
    averaged_plot = subplot(4,1,2);
    plot(averaged_plot,tt,point_series_group(1,:));
    title(['averaged time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
    xlabel('time/s');
    ylabel('value');
    
    %get and show preprocessed time series of first size of ROI
    [time_s_preprocessed,time_s_interval] = preprocess(point_series_group(1,:),fs,tt);
    if bInvert
        time_s_preprocessed = -time_s_preprocessed; %% ivert for feature detection
    end
    pre_plot = subplot(4,1,3);
    %pre = axes;
    plot(pre_plot,tt,time_s_preprocessed);
    title(['preprocessed time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
    xlabel('time/s');
    ylabel('value');
    
    %get and show moving average filtered time series of first size of ROI
    time_s_mafiltered = ma_filter(time_s_preprocessed,round(time_s_interval/5));
    ma_plot = subplot(4,1,4);
    plot(ma_plot,tt,time_s_mafiltered);
    title(['mafiltered time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
    xlabel('time/s');
    ylabel('value');
    
    
    %creat slider and text to show the time series of other size of ROI
    sld = uicontrol('Style', 'slider',...
        'Min',roi_min,'Max',roi_max,'Value',roi_min,...
        'Position', [20 20 500 20],...
        'Callback', @roi_point_serie,...
        'SliderStep',[1,1]/num_roi);
    
    roi_show = uicontrol('Style', 'text',...
        'string', num2str(roi_min),...
        'Position',[530 20 20 20]);
    
    
    %calculate segments for features calculation
    %     time_s_seg = Segmentation(time_s_mafiltered,fs,time_s_interval,tt);
    %
    %     sa = SA(time_s_seg);%calculate feature
    
    
    
    
    time_secs =10;
    window = ones(1,ceil(fs*time_secs));
    if size(window,2) > 1
        noverlap = length(window)-1;
        nfft = 2^nextpow2(length(window));
    else
        noverlap = (window)-1;  %% if windows is scalar
        nfft = 2^nextpow2(window);
    end
    
    figure;
    spectrogram( time_s_mafiltered , window, noverlap,nfft,fs);
    
else%the input video is gaussian filtered video
    time_figure = figure;
    %show the time series of gaussian filtered video
    tt = 0:1/fs:(length(time_s)-1)*1/fs;
    blur_plot = subplot(3,1,1);
    plot(blur_plot,tt,time_s);
    title(['gaussian filtered domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
    xlabel('time/s');
    ylabel('value');
    
    %calculate and show the preprocessed time series
    [time_s_preprocessed,time_s_interval] = preprocess(time_s,fs,tt);
    if bInvert
        time_s_preprocessed = -time_s_preprocessed; %% ivert for feature detection
    end
    pre_plot = subplot(3,1,2);
    plot(pre_plot,tt,time_s_preprocessed);
    title(['preprocessed time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
    xlabel('time/s');
    ylabel('value');
    
    %     [time_s_preprocessed_2,time_s_interval_2] = preprocess(time_s_preprocessed,fs,tt);
    %      pre_plot = subplot(4,1,3);
    %     plot(pre_plot,tt,time_s_preprocessed_2);
    %
    
    %calculate and show the preprocessed time series
    time_s_mafiltered = ma_filter(time_s_preprocessed,round(time_s_interval/5));
    ma_plot = subplot(3,1,3);
    plot(ma_plot,tt,time_s_mafiltered);
    title(['mafiltered time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
    xlabel('time/s');
    ylabel('value');
    
    
    %calculate segments for features calculation
    %     time_s_seg = Segmentation(time_s_mafiltered,fs,time_s_interval,tt);
    %
    %     sa = SA(time_s_seg);%calculate feature
    
    
    time_secs =10;
    window = ones(1,ceil(fs*time_secs));
    if size(window,2) > 1
        noverlap = length(window)-1;
        nfft = 2^nextpow2(length(window));
    else
        noverlap = (window)-1;  %% if windows is scalar
        nfft = 2^nextpow2(window);
    end
    
    figure;
    spectrogram( time_s_mafiltered , window, noverlap,nfft,fs);
    
end


%callback function of slider to show time series of other size of ROI
    function roi_point_serie(source, callbackdata)
        
        val = floor(source.Value);%get the current value of slider
        %        rc_current = val*2-1;
        val_odd = val + 1 - mod(val,2);
        set(roi_show,'String',num2str(val_odd));
        figure(time_figure);
        %show the time series of the current size of ROI
        time_series_of_val = point_series_group((val_odd-roi_min)/2+1,:);
        plot(averaged_plot,tt,time_series_of_val);
        title(averaged_plot,['averaged time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
        xlabel(averaged_plot,'time/s');
        ylabel(averaged_plot,'value');
        
        %calculate and show the preprocessed time series of current size of
        %ROI
        [time_s_preprocessed,time_s_interval] = preprocess(time_series_of_val,fs,tt);
        if bInvert
            time_s_preprocessed = -time_s_preprocessed; %% ivert for feature detection
        end
        plot(pre_plot,tt,time_s_preprocessed);
        title(pre_plot,['preprocessed time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
        xlabel(pre_plot,'time/s');
        ylabel(pre_plot,'value');
        
        %calculate and show the moving averag filtered time series of current size of
        %ROI
        time_s_mafiltered = ma_filter(time_s_preprocessed,round(time_s_interval/5));
        plot(ma_plot,tt,time_s_mafiltered);
        title(ma_plot,['mafiltered time domain waveform of point (',num2str(rindex),',',num2str(cindex),') in ppgi']);
        xlabel(ma_plot,'time/s');
        ylabel(ma_plot,'value');
        
    end


end

