# Gammatonegram_CNN_Dysarthric_speech
MATLAB implementation for Dysarthric Speech Processing using Gammatonegram and Convolutional Neural Network (CNN) on the UA speech dataset.

**** **Trained models will be shared after acceptance of the paper** ****

in this implementation, we use two MATLAB toolbox:
* Gammatone toolbox By [Dan Ellis](https://www.ee.columbia.edu/~dpwe/resources/matlab/gammatonegram/)
* Murphy HMM toolbox

the dataset can be downloaded from [UA speech dataset link](http://www.isle.illinois.edu/sst/data/UASpeech/).
Using this package, you can use [a pre-trained CNN](https://www.mathworks.com/help/deeplearning/ug/pretrained-convolutional-neural-networks.html) (for instance: Alexnet) to retrain for a new scenario in dysarthric speech recognition, dysarthric speaker identification, and speech intelligibility assessment. 
In this repository, we use Gammatonegram as a new representation method for speech signal as a picture. Figure (1) shows the gammatonegram of two utterances of the isolated word "one" from the speaker F04 of the UA dataset with 62% speech intelligibility. 


 ![F04_B2_D1_M2](https://user-images.githubusercontent.com/93467718/182780335-a9cf3945-8fa6-4930-8289-a25145fde049.jpg)![F04_B2_D1_M8](https://user-images.githubusercontent.com/93467718/182780373-cd703c31-864d-4e6a-acdd-6a790dd479da.jpg)

 Figure (1). Gammatonegram representation


In the first step, you should save the data of each isolated word into separate folders and then run the proposed M-files.
To run the CNN-based approaches, all the Wav files must convert to Gammatonegram using my_dys_convert_to_image_all.m
based on the Murphy toolbox, there is a comparison between the proposed (Gammatonegram+CNN) and baseline (MFCC+HMM) methods.
To run the HMM, use the test2.m from the Murphy folder.
To run the Gammatonegram and Spectrogram-based systems in different scenarios my_train_test_CNN.m is ready. Using this M-file, all the speech recognition, speaker identification, and Intelligibility assessment systems can be trained.

In the last scenario, we proposed a Cascade two-step system for speech recognition that, in the first step, recognizes the speech intelligibility and, based on the intelligibility level, turns on one of the speech recognition systems. you can use test_ASR_cascade_2_class_intell.m to run this task.

<p align="center">
  <img src="https://user-images.githubusercontent.com/93467718/182784417-9a0b58ab-8120-4a02-8c3a-f5505480b3fc.gif">
 </p>
 <p align="center">
 Figure(2). Proposed cascade system for speech recognition
</p>




