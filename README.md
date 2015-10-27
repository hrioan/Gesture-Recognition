# Gesture-Recognition
Gesture Recognition using Kinect data - Chalearn challenge 2013

**Outline**

This repository contains all the scipts and experiments conducted during my diploma thesis for the 
Diploma degree in the Department of Electrical and Computer Engineering, University of Thessaly 

**Abstract**
The thesis focuses on the utilization of depth sensors to build a classifier that can reliably
detect a number of gestures.  The database, originally introduced in Chalearn Gesture
Challenge  2013,  consists  of  a  vocabulary  of  20  gestures  and  was  built  using  a  Kinect
sensor  to  capture  audio,  video,  the  body's  skeleton  joints  and  depth  information.   In
this thesis we primarily make use of the skeleton modalities to track the movement of
the hand and body joints over time and create models that can effectively recognize the
given gestures.  This is achieved through the creation of a pose descriptor that contains
the angles that the bone vectors form with each other and their distances from the torso.
By calculating these metrics we can get a virtual map of the human posture in every
video frame.
The classification procedure makes use of the above features to recognize gestures as a
sequence of body postures.  We primarily emphasize on two classifiers that both train
Hidden Markov Models.  The worst model makes use of GMMs to model the class con-
ditional  probabilities,  while  the  other  is  modeled  with  DNNs.   The  tools  used  in  this
procedure are the HTK and Kaldi toolkits.

**Repository Information**

The following notes explain the scripts of the repository in more detail

1. 'Feature Extraction' holds the Matlab scripts that are used to extract features from the dataset.
2. 'Toolset Experiments' contains the scripts of the experiments in Kaldi and HTK toolkits. For Kaldi 
Experiments, copy the two folders inside the Kaldi's recipie folder (default is Kaldisource/egs/). For 
HTK experiments, copy the respective folders a lever above the HTK source files.
3. 'Documents' contains the thesis and presentation files (per request)
4. 'dataViewer' contains the Matlab scripts to unpack the dataset used in Chalerean Gesture Challenge
2013. An additional script has been added to unzip multiple zip files.

** Installation notes **

* To extract your own features. Study and execute the scripts in the following order:
	- 'extract_many_zips' to extract the features in each video
	- 'feature_extraction'
	- 'generate_txt'
* For Kaldi experiments:
	- The experiments iside the folders contain only the script files.  In order to run the experiments you
	you need to generate the features AllSamples.txt and Test_coeffs.txt that contain the test and train
	features respectively. In Addition, the folder 'Gesture_data_info' should contain the Label files of 
        the feature matrices you parse. Finally, make sure to create links to the folders utils and steps that 
        point to Kaldi's scripts. Copy the folders (or links) from the 'rm' recipe inside Kaldisource/egs

