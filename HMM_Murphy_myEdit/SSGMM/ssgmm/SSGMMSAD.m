function speechScores = SSGMMSAD(s, fs, params)
% Speech activity detector (SAD) presented in,
% 
% [1]   Alexey Sholokhov, Md Sahidullah and Tomi Kinnunen, "Semi-Supervised Speech 
%       Activity Detection with an Application to Automatic Speaker Verification", 
%       to appear in Computer Speech & Language.
% [2]   Tomi Kinnunen and Padmanabhan Rajan, "A practical, self-adaptive voice 
%       activity detector for speaker verification with noisy telephone and
%       microphone data", in proc. of ICASSP 2013, Vancouver.
%
% Inputs: 
% 
%   s              Column vector of PCM signal samples as obtained through "audioread"
%                  function of MATLAB.
%   fs             Sampling rate in Hertz
%   params         Optional struct of control parameters. These parameters are
%                  set by "set_SSGMM_default_params" function.
%
%                  Especially the minimum energy threshold (params.min_energy) may
%                  require some fine-tuning depending on whether you work on telephone
%                  or microphone data. According to our experience with NIST
%                  speaker recognition data, values in the range [-75 dB ..-55 dB]
%                  seem to give reasonable results on "typical" NIST SRE data. 
%
%
% Outputs:      
%
%   speechScores   Log-likelihood ratios
%
%
% NOTE!            This code should be otherwise self-contained, but it does
%                  use the spectral subtraction routines from Voicebox 
%                  (http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html)
%                  So download Voicebox and add to your Matlab path.
%
% (C) Copyright School of Computing (SoC), University of Eastern Finland (UEF)
% Use this code completely at your own risk. 
%
% Feedback is always welcomed!
% E-mail: sholok@cs.uef.fi, sahid@cs.uef.fi, tkinnu@cs.uef.fi


% Compute value from s that we will use to initialize random number
% generation, to make sure we get the SAME result if we repeat this twice
% for the same signal. Making the seed dependent on signal on the other
% makes sure that different signals get different noises added
seed = floor(max(abs(s)) * length(s) + abs(min(s))) + 1;
rng(seed);

% Convert framing parameters from seconds into samples, for this
% samplerate.
frame_len_samp   = round(params.frame_len   * fs);
frame_shift_samp = round(params.frame_shift * fs);

% Check that we don't accidentally feed in stereo data
if size(s, 2) > 1
    speechScores = [];
    return;
end;

% Dithering to avoid having identical vectors in our speech and nonspeech
% codebooks (yes, it actually is a problem if not done!)
if params.dither
    s = s + (1e-09).*randn(length(s), 1);
end;

% Optional speech cleaning to enhance energy SAD initialization
if params.clean_energy
    % Define Wiener filter parameters
    pp.g      = 2;
    pp.e      = 2;
    pp.ne     = 1;
    pp.am     = 10; % allow aggressive oversubtraction
    s_cleaned = specsub(s, fs, pp);
 
    % Extract frame energy values from cleaned frames
    frames = enframe(s_cleaned, boxcar(frame_len_samp), frame_shift_samp);
    energy = 20*log10(std(frames,[],2)'+eps);
else
    % Extract frame energy values from original (noisy) frames
    frames = enframe(s, boxcar(frame_len_samp), frame_shift_samp);
    energy = 20*log10(std(frames,[],2)'+eps);
end;

% Extract MFCCs either from cleaned or original (noisy) signal
if params.clean_MFCCs
    Cep = compute_MFCCs(s_cleaned, fs, params);
else
    Cep = compute_MFCCs(s, fs, params);
end;

% RASTA filtering
if params.rasta
    Cep = rastafilt(Cep')';   
end


[n, dim] = size(Cep);

% For numerical stability make sure that (dim+1) points are available for each mixture component
if n < 2*(dim+1)*params.vq_size 
   error('[SAD]: Not enough data! n = %i, dim = %i.', n, dim); 
end

n_init = ceil(n * params.energy_fraction);
n_init = max(dim+1, n_init);

    
% Energy_fraction cannot be more than 50% if init is not Oracle
n_init = min(n_init, floor(n/2));

if params.use_pitch
    % Detect pitch
    [~, pv01] = detect_pitch(s, fs, params, n);
else
    pv01 = zeros(n, 1);
end

% Rank all frame energies and determine the lowest and highest energy frames.
n_pitch = sum(pv01);
n_nonpitch = length(pv01) - n_pitch;

[~, frame_idx] = sort(energy);
pv01_sorted = pv01(frame_idx);

idx_pitch = frame_idx(pv01_sorted > 0.5);
idx_nonpitch = frame_idx(pv01_sorted < 0.5);

% Non-speech model
if n_nonpitch >= n_init % more than required
    % Choose the subset with the lowest energy
    nonspeech_frames = idx_nonpitch(1:n_init);       
elseif n_nonpitch>0 % less than required
    % Use all
    nonspeech_frames = [idx_nonpitch idx_pitch(1:n_init-n_nonpitch)];        
else % Use pitch with the lowest energy
    nonspeech_frames = idx_pitch(1:n_init);
end

% Speech model
if n_pitch >= n_init % more than required
    % Choose the subset with the highest energy
    speech_frames = idx_pitch(end-n_init+1:end);
elseif n_pitch>0 % less than required
    % Use all
    speech_frames = [idx_pitch idx_nonpitch(end-(n_init-n_pitch)+1:end)];      
else % Use non-pitch with the highest energy
    speech_frames = idx_nonpitch(end-n_init+1:end);
end

%AREF
% if length(speech_frames)    < 30 ||...
%    length(nonspeech_frames) < 30
% % if length(speech_frames)    < (dim+1)*params.vq_size ||...
% %    length(nonspeech_frames) < (dim+1)*params.vq_size
%    error('[SAD]: Not enough frames to train models! speech = %i, nonspeech = %i.',...
%    length(speech_frames), length(nonspeech_frames));
% end

% Train the speech and nonspeech models from the MFCC vectors corresponding
% to the highest and lowest frame energies, respectively
if params.VQ
    [~,speech_model]    = kmeans(Cep(speech_frames, :), params.vq_size);
    [~,nonspeech_model] = kmeans(Cep(nonspeech_frames, :), params.vq_size);
    % Convert these into LLR-like scores
    D_speech    = VQ_distance(Cep, speech_model);
    D_nonspeech = VQ_distance(Cep, nonspeech_model);
    LLR = min(D_nonspeech, [], 2)' - min(D_speech, [], 2)';
else
    if params.semisupervised
        labels = zeros(n, 1);
    else
        labels = zeros(n, 1) - 1; 
    end
    labels(speech_frames) = 2;
    labels(nonspeech_frames) = 1;    

    if params.semisupervised % SSGMM
        [~, LLR, ~] = ssgmm(Cep, labels, 'initIter', 1, 'numComp', [params.vq_size params.vq_size],...
        'covType', params.covtype, 'numIter', 20, 'sharedCov', params.sharedcov);
    else % GMM
        options = statset('MaxIter', 20);
        speech_model = gmdistribution.fit(Cep(labels==2,:), params.vq_size, 'CovType', params.covtype,...
            'sharedCov', params.sharedcov, 'Regularize', 0.001, 'Options',options);
        nonspeech_model = gmdistribution.fit(Cep(labels==1,:), params.vq_size, 'CovType', params.covtype,...
            'sharedCov', params.sharedcov,  'Regularize', 0.001, 'Options',options);
        D_speech    = gmm_loglikelihood(speech_model, Cep);
        D_nonspeech = gmm_loglikelihood(nonspeech_model, Cep);
        LLR = D_speech - D_nonspeech;
    end
end

% Accept ONLY if the energies are also high enough
energy_mask = (energy >= params.min_energy);

speechScores = -inf(n,1);
speechScores(energy_mask) = LLR(energy_mask);


