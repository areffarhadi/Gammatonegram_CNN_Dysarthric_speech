# Gammatonegram_CNN_Dysarthric_speech
MATLAB implementation for Dysarthric Speech Processing using Gammatonegram and Convolutional Neural Network (CNN) on the UA speech dataset.
th this implementation we use two matlab toolbox
* Gammatonegram By Dan Elis
* Murphy HMM toolbox
the dataset can be downloaded form [UA speech dataset link](http://www.isle.illinois.edu/sst/data/UASpeech/).
using this package you can use [a pretrained CNN net](https://www.mathworks.com/help/deeplearning/ug/pretrained-convolutional-neural-networks.html) (for instance: Alexnet) to retrain for a new scenario in dysarthric peech recognition, dysarthric speaker identification and speech intelligibility assessment. 
in this repository we use Gammatonegram as new representation method for speech signal as a picture. Figure (1) shows gammatonegram of two utterances of isolated word "one" from the speaker F04 of UA dataset with 62% speech intelligibility. 

![F04_B2_D1_M2](https://user-images.githubusercontent.com/93467718/182780335-a9cf3945-8fa6-4930-8289-a25145fde049.jpg)![F04_B2_D1_M8](https://user-images.githubusercontent.com/93467718/182780373-cd703c31-864d-4e6a-acdd-6a790dd479da.jpg)

Figure (1). Gammatonegram representation
in the first step you should save data of each isolated words into separate folders and then run the proposed M-files.
to run the CNN based approaches all the Wav files must convert to Gammatonegram using my_dys_convert_to_image_all.m
based on Murphy toolbox, there is a compertion between the proposed (Gammatonegram+CNN) and baseline (MFCC+HMM) methods.
to run the HMM just use the test2.m from Murphy folder.
to run the Gammatonegram and Spectrogram based systems in different scenarios my_train_test_CNN.m is ready. using this M-file all the speech recognition, speaker identification and Intelligibility assessment system can be trained.

in the last scenario, we proposed a Cascade two-step system for speech recognition that in the first step recognize the speech intelligibility and based on the intelligibility level, turns on one of the speech recognition systems.

![Drawing2](https://user-images.githubusercontent.com/93467718/182784417-9a0b58ab-8120-4a02-8c3a-f5505480b3fc.gif)

Figure(2). Proposed cascade system for speech recognition

