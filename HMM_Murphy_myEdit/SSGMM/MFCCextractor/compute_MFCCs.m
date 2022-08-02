%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Cep, frames] = compute_MFCCs(s, fs, params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MFCC params
frame_len       = round(params.frame_len * fs);
frame_shift     = round(params.frame_shift * fs);

target_fs       = params.target_fs;
num_filters     = params.num_filters;
num_cep         = params.num_cep;
NFFT            = params.NFFT;
Fmin_Hz         = params.Fmin_Hz;
Fmax_Hz         = params.Fmax_Hz;
use_cms         = params.use_cms;
use_cvn         = params.use_cvn;
include_C0      = params.include_C0;

% Extract base MFCCs
[FB, ~]         = MyFilterBank(num_filters, target_fs, Fmin_Hz, Fmax_Hz, NFFT, 'mel', 0);
win_fun         = hamming(frame_len);
frames          = enframe(s, boxcar(frame_len), frame_shift);
windowed_frames = frames .* repmat(win_fun', size(frames,1),1);
Cep             = ComputeFFTCepstrum(windowed_frames, FB', num_cep, NFFT, include_C0);

% Optional delta and double delta features
if params.include_deltas
    D = conv2(Cep,  [1; 0; -1], 'same');
    Cep = [Cep, D];
    if params.include_double_deltas
        DD = conv2(D,   [1; 0; -1], 'same');
        Cep = [Cep, DD];
    end;
end;

% Optional feature normalization
if use_cms
    Cep = Cep - repmat(mean(Cep), size(Cep, 1), 1);
end;
if use_cvn
    Cep = Cep ./ repmat(std(Cep), size(Cep, 1), 1);
end;

