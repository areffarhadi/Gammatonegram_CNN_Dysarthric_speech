
% clear
addpath('VOICEBOX')
addpath('MFCCextractor')
addpath('getf0s_matlab')
addpath(genpath('ssgmm'))
b=0;
fs=16000;
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
 load('24Word_addres.mat','a');
for ij=2:28
%     load('24Word_addres.mat',a{1, ij});
    
    outDir='E:\My Projects\Dysarthria with CNN\gammatonegram\SSGMM';
%     X=LD;
%     [num,~]=size(X);
for ii=1
%      filename=X{ii,1};
     filename='E:\My Projects\Dysarthria with CNN\gammatonegram\SSGMM\F02_B1_C1_M2_3.wav';
    filename = multimedia.internal.io.absolutePathForReading(...
    filename, ...
    'MATLAB:audiovideo:audioread:fileNotFound', ...
    'MATLAB:audiovideo:audioread:filePermissionDenied');

import multimedia.internal.audio.file.PluginManager;

try
    readPlugin = PluginManager.getInstance.getPluginForRead(filename);
    [d,sr]=audioread(filename);
%     b=b+1;
    s = d(:,1);
    speechScores = SSGMMSAD(s, fs, params);
    speechInd = speechScores > 0;

    % Some stats
    % proc_time        = toc;
    speech_frames    = find(speechInd);
    nonspeech_frames = find(~speechInd);
    n_speech         = length(speech_frames);
    n_nonspeech      = length(nonspeech_frames);

    n_frame=n_nonspeech+n_speech;
% tic
[aa,bb]=size(s);
ind=ones(aa,1);
    for i=1:n_frame
    s(((i-1)*160)+1:(i*160),1)=(s(((i-1)*160)+1:(i*160),1))*speechInd(i,1);
    ind(((i-1)*160)+1:(i*160),1)=(ind(((i-1)*160)+1:(i*160),1))*speechInd(i,1)*0.4;
    
    end
    figure;plot(d(1:end-200,:));
    hold on
    plot(ind(1:end-200,:))
    
    S_VAD=nonzeros(s);
%     S_VAD=d;
    [D2,F2] = gammatonegram(S_VAD,sr,0.0125,0.00625,256,50,sr/2,0);
    imagesc(20*log10(D2)); axis xy
    axis off
    b=X{ii,1}(18:end-4);  %b=a(1:end-4);
    im=strcat(outDir,b,'.jpg');
    saveas(gcf,im);
    close
%     imwrite(ind2rgb(im2uint8(mat2gray(D2)),parula(256)),'aaaaa.jpg')
%imwrite(ind2rgb(im2uint8(mat2gray(D2)),parula(64)),'a6.jpg')
%     imwrite(outputImage,images2.Files{i,1});
end
end
end