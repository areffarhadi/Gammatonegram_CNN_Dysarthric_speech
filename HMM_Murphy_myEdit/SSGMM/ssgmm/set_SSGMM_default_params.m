%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function params = set_SSGMM_default_params(target_fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params.frame_len                = 0.0200; % Frame duration, seconds
params.frame_shift              = 0.0100; % Frame hop, seconds

% Define VAD parameters (could we have a few more of them, please?)
params.dither                   = true; % Add neglible small-amplitude Gaussian noise to avoid duplicated MFCC vectors in zero-only parts
params.clean_energy             = true; % Apply spectral subtraction on energy VAD values ?
params.clean_MFCCs              = false; % Apply spectral subtraction also to MFCCs ?
params.min_energy               = -75; % Minimum-energy constraint, dB 

params.vq_size                  = 8; % Number of components in GMM

params.target_fs                = target_fs;
params.num_filters              = 27; % Number of mel bands

params.num_cep                  = 12; % Number of MFCCs

params.include_C0               = true; % Include c0
params.NFFT                     = 512;
params.Fmin_Hz                  = 0;
params.Fmax_Hz                  = 4000;
params.include_deltas           = false;
params.include_double_deltas    = false;
params.use_cms                  = false; % Apply Cepstral Mean Subtraction (CMS)
params.use_cvn                  = false; % Apply Cepstral Variance Normalization (CVN)

params.VQ                       = false; % Use codebooks (vector quantization) instead of GMMs
params.semisupervised           = true; 

params.covtype                  = 'full';
params.sharedcov                = false;
params.use_pitch                = true; % Use F0-detector to enhance speech model
params.rasta                    = true;

params.energy_fraction          = 0.10; % Fraction of high/low energy frames picked for speech/nonspeech model training
%params.num_init_frames          = (params.num_cep+2)*params.vq_size;

