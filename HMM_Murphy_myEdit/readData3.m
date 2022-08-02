function data= readData2(dir,fl,num)
dataStruct= struct('alld',[]);
data=repmat(dataStruct,length(fl),1);
FeatureStruct=struct('feature',[]);
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
    for i =1:length(fl)
        count=1;
        path= strcat(dir, fl{i});
        path=strcat(path,'\');
        currentData={};
        
        for j=1:num(i)
              path2= strcat(path,'1 (');
              path2= strcat(path2, num2str(j));
             path2= strcat(path2, ').wav');
            % m=MFCC(path2);
            wr=audioread(path2);  %AREF
            wr=wr(:,1);
        [n,~]=size(wr);
%         VAD=my_vad(wr,16000,'a');
%         c=[];
%          for ii=1:n
%            if VAD(ii,1)~=0
%             c=cat(1,c,wr(ii,1));
%            end
%          end


%%%%%%%%% GMMVAD
speechScores = SSGMMSAD(wr, fs, params);
    speechInd = speechScores > 0;

    % Some stats
    % proc_time        = toc;
    speech_frames    = find(speechInd);
    nonspeech_frames = find(~speechInd);
    n_speech         = length(speech_frames);
    n_nonspeech      = length(nonspeech_frames);

    n_frame=n_nonspeech+n_speech;
% tic
    for i=1:n_frame
    s(((i-1)*160)+1:(i*160),1)=(s(((i-1)*160)+1:(i*160),1))*speechInd(i,1);
    end
    wr=nonzeros(s);

%%%%%
            m=melcepst(wr,16000,'E''d''D');   %AREF
            %if(size(m,2)==299)
                currentData{count}(:,:)=m';   
              count=count+1;
            % end
            i
            j
        end
        data(i).alld=(currentData);
    end
end
function l= normalize(l)
    for i=1:size(l,2)
        l(:,i)=(l(:,i)-mean(l(:,i)))/sqrt(var(l(:,i)));
    end
end