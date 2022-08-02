[y,fs] = audioread('0.wav');
% soundsc(y,fs); % Let's hear it
M = round(0.02*fs);  % 20 ms window is typical
M=400;
N = 2^nextpow2(4*M); % zero padding for interpolation
% w = hamming(M);
w=hann(M);
spectrogram(y,w,100,N)
% % spectrogram(y,N,fs,w,-M/8,1,60);  %spectrogram(y,w,60)
% % title('Speech Sample Spectrogram');
% % % for classic look:
% % colormap(1-gray);