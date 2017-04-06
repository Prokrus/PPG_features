function [ output_args ] = signal_spec( s,fps )
%SIGNAL_SPEC plot spectrogram of input signal
%   use FFT to get Spectrogram


num = 2^nextpow2(length(s));
s_f = abs(fft(s,num)/num);
s_f_h = 2*s_f(1:num/2+1);
f = fps*(0:(num/2))/num;

plot(f,s_f_h);
title('spectrogram of signal')
xlabel('f/Hz)')
ylabel('magnitude')
end

