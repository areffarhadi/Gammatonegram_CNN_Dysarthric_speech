% ASR in cascade with intelligibility assessment

%%load pretrained nets
load ('net_intell_2class_B3.mat');
net_inteli=net;
load('net_high_ASR_B3.mat');
net_high=netTransfer;
load('net_low_ASR_B3.mat');
net_low=netTransfer;


%% File adresses
validationImages1=imageDatastore('.\UAdata_30comm_gammatonegram\test',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');


numTestImages = numel(validationImages1.Labels);
Result=[];
Result=categorical(Result);

 predictedLabels1 = classify(net_inteli,validationImages1);
VALdata=validationImages1;

for i=1:numTestImages
%% intelligibility estimation

VALdata.Files=validationImages1.Files{i,1};

%% speech recognition

if  predictedLabels1(i,1)=='HIGH'
    predictedLabels = classify(net_high,VALdata);
elseif predictedLabels1(i,1)=='LOW'
    predictedLabels = classify(net_low,VALdata);
end
Result(i,1)=predictedLabels1(i,1);
Result(i,2)=predictedLabels;

disp(['processed images: ',num2str(i)])
end


valLabels = validationImages1.Labels;
predictedLabels=Result(:,2);
accuracy = mean(predictedLabels == valLabels);

a=Result(:,1);a=sort(a);