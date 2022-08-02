[y,fs] = audioread('0.wav');
soundsc(y,fs); % Let's hear it
% for classic look:
colormap('gray'); map = colormap; imap = flipud(map);
M = round(0.02*fs);  % 20 ms window is typical
N = 2^nextpow2(4*M); % zero padding for interpolation
w = 0.54 - 0.46 * cos(2*pi*[0:M-1]/(M-1)); % w = hamming(M);
colormap(imap); % Octave wants it here
spectrogram(y,N,fs,w,-M/8,1,60); 
colormap(imap); % Matlab wants it here
title('Hi - This is <you-know-who> ');
ylim([0,(fs/2)/1000]); % don't plot neg. frequencies