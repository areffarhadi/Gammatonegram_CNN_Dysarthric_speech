
clc
clear; 
close all;

addpath('MFCCextractor')
addpath('getf0s_matlab')
addpath(genpath('ssgmm'))

% Load audio file (source: http://www.voiptroubleshooter.com/open_speech/american.html)
%[s, fs] = read_NIST_sph('./tfbvu.sph');
% [s, fs] = audioread('./OSR_us_000_0010_8k.wav');

% [s, fs] = audioread('1 (57).wav');
% Make sure it is mono; 
s = s(:,1);

% Get default parameters
params = set_SSGMM_default_params(fs);

% Flag "semisupervised" enables semi-supervised training strategy 
% while flag "VQ" switches from GMM to vector quantization (k-means).
% .semisupervised=1 - semi-supervised training
% .semisupervised=0 - supervised training
% .VQ=1             - k-means
% .VQ=0             - GMM
% Note: semi-supervised training for VQ is not implemented.
params.semisupervised           = true;
params.VQ                       = false;

params.fea                      = 'mfcc';
params.covtype                  = 'full';
params.sharedcov                = false;
params.use_pitch                = true;
params.rasta                    = true;
params.energy_fraction          = 0.20;
params.vq_size                  = 4;

tic;
speechScores = SSGMMSAD(s, fs, params);
speechInd = speechScores > 0;

% Some stats
proc_time        = toc;
speech_frames    = find(speechInd);
nonspeech_frames = find(~speechInd);
n_speech         = length(speech_frames);
n_nonspeech      = length(nonspeech_frames);
speech_prop      = 100*(n_speech/(n_speech + n_nonspeech));
total_dur        = length(s)/fs;
rt_factor        = total_dur/proc_time;

fprintf('Analyzed utterance of duration %2.2f sec, took %2.2f sec (real-time factor = %2.2f)\n', total_dur, proc_time, rt_factor);
fprintf('Found %d speech (%2.2f %%) and %d nonspeech (%2.2f %%) frames\n', n_speech, speech_prop, n_nonspeech, 100 - speech_prop);

% Plot the results
subplot(311);
t = (0:length(s)-1)./fs;
plot(t, s); xlabel('Time (sec)'); ylabel('Amplitude'); axis tight;
axis tight;

subplot(312);
t = (0:length(speechScores)-1).*params.frame_shift;
plot(t, speechScores, 'b'); hold on;
plot(t, t*0, 'r'); 
xlabel('Time (sec)'); ylabel('LLR speech-to-nonspeech'); axis tight;
axis tight;

subplot(313);
spectrogram(s, hanning(200), 100, 512, fs, 'yaxis'); xlabel('Time (sec)'); axis tight;
axis tight;
colorbar('off')

% -------------------------------------------------------------------------
% The list of functions from the 'voicebox' toolbox
% (http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/doc/voicebox/index.html) 
% used in this package:
% - enframe
% - estnoiseg
% - irfft
% - rfft
% - specsub

