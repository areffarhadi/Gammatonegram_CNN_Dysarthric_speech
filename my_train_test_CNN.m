% Transfer Learning Using AlexNet
% train and test ASR system for dysarthric speech usin CNN with alexnet
% architecture for 30 command. based on train and test data it can be used
% for gammatonegram and spectrogram. 

trainingImages = imageDatastore('.\UAdata_30comm_gammatonegram_B3\train',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');
validationImages = imageDatastore('.\UAdata_30comm_gammatonegram_B3\test',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

numTrainImages = numel(trainingImages.Labels);

%% Load Pretrained Network
%     load('alexnet.mat');
%     net = alexnet;
      load('255dys_11epoch.mat');
      net = netTransfer;



%% Transfer Layers to New Network


layersTransfer = net.Layers(1:end-3);
 numClasses = numel(categories(trainingImages.Labels));
 layers = [
     layersTransfer
     fullyConnectedLayer(numClasses,'WeightLearnRateFactor',1,'BiasLearnRateFactor',2)
     softmaxLayer
     classificationLayer];
 

%%

miniBatchSize = 128;
numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',30,...
    'InitialLearnRate',1e-4,...
    'Verbose',false,...
    'Plots','training-progress',...
    'ValidationData',validationImages,...
    'Shuffle', 'every-epoch', ...
    'ValidationFrequency',numIterationsPerEpoch);

%%
% Train the network that consists of the transferred and new layers.

 netTransfer = trainNetwork(trainingImages,layers,options);

save('netTransfer','netTransfer');
%% Classify Validation Images
% Classify the validation images using the fine-tuned network.
predictedLabels = classify(netTransfer,validationImages);

%%
% Calculate the classification accuracy on the validation set. Accuracy is
% the fraction of labels that the network predicts correctly.
valLabels = validationImages.Labels;
accuracy = mean(predictedLabels == valLabels);

