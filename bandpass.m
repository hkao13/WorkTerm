%   bandpass filter 100Hz -> 1000Hz

n = 2;                                      %order
freq_sample = 10000;                        %sample rate
freq_pass = [100, 1000];                    %passband
freq_norm = 2*freq_pass / freq_sample;      %normalized passband
[b,a] = butter(n, freq_norm, 'bandpass');   %buttterworth bandpass filter
freqz(b,a,512,freq_sample)                  %plot