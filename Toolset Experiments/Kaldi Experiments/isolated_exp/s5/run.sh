#!/bin/bash

train_cmd="utils/run.pl"
decode_cmd="utils/run.pl"

# We assume that the folder Gesture_data_info exists in the path 
# git hub link will be provided later 

train_yesno=train_gestures
test_base_name=test_gestures

# erase any previous data from prior execution 
rm -rf data exp mfcc

############################### Data preparation ###############################
echo "------------------ Data preparation ----------------"
local/prepare_data.sh Gesture_data_info
local/prepare_dict.sh
utils/prepare_lang.sh --position-dependent-phones false --num-nonsil-states 5  data/local/dict "<SIL>" data/local/lang data/lang
local/prepare_lm.sh

#--num-nonsil-states 50 --num-nonsil-states 20 
############################## Feature Extraction ##############################
# Features are already computed through Matlab and their coefficients are
# in Gesture_data_info directory. 
work_dir=$(pwd)
mkdir mfcc

echo $work_dir
echo "------------------ Feature Extraction ----------------\n\n"
##################
## Training set ##
##################
# We already have the .txt files in Gesture_data_info that point to the 'data' files 
# AllSamples file has all the coefficients of the test set in one txt file 

 ../../../src/bin/copy-matrix ark,t:AllSamples.txt ark:mfcc/raw_coeffs_train_gestures.ark 
 
 #create the .scp files
 ../../../src/featbin/copy-feats ark:$work_dir/mfcc/raw_coeffs_train_gestures.ark ark,scp:$work_dir/mfcc/train_set.ark,$work_dir/mfcc/raw_coeffs_gesture_train.scp

sort -k1 ./mfcc/raw_coeffs_gesture_train.scp >> ./mfcc/raw_coeffs_gesture_train_temp.scp
rm ./mfcc/raw_coeffs_gesture_train.scp
mv ./mfcc/raw_coeffs_gesture_train_temp.scp ./mfcc/raw_coeffs_gesture_train.scp

cp ./mfcc/raw_coeffs_gesture_train.scp ./data/train_gestures
mv ./data/train_gestures/raw_coeffs_gesture_train.scp ./data/train_gestures/feats.scp

# CMVN feats 
# Compute Cepstral mean and apply vector normalization (VM already done) 
steps/compute_cmvn_stats.sh  data/train_gestures exp/make_mfccs mfcc
##############
## Test Set ##
############## 
../../../src/bin/copy-matrix ark,t:Test_coeffs.txt ark:mfcc/raw_coeffs_test_gestures.ark 
 
#create the .scp files
../../../src/featbin/copy-feats ark:$work_dir/mfcc/raw_coeffs_test_gestures.ark ark,scp:$work_dir/mfcc/test_set.ark,$work_dir/mfcc/raw_coeffs_gesture_test.scp

sort -k1 ./mfcc/raw_coeffs_gesture_test.scp >> ./mfcc/raw_coeffs_gesture_test_temp.scp
rm ./mfcc/raw_coeffs_gesture_test.scp
mv ./mfcc/raw_coeffs_gesture_test_temp.scp ./mfcc/raw_coeffs_gesture_test.scp

cp ./mfcc/raw_coeffs_gesture_test.scp ./data/test_gestures
mv ./data/test_gestures/raw_coeffs_gesture_test.scp ./data/test_gestures/feats.scp

# remove temp files
rm ./mfcc/raw_coeffs_test_gestures.ark ./mfcc/raw_coeffs_train_gestures.ark 

# CMVN feats 
# Compute Cepstral mean and apply vector normalization (VM already done) 
steps/compute_cmvn_stats.sh  data/test_gestures exp/make_mfccs mfcc

################################  Training & Testing ###########################

echo "------------------ Mono Training ----------------"

steps/train_mono.sh --nj 1 --cmd "$train_cmd" \
  --totgauss 400 \
  --num_iters 40 \
  data/train_gestures data/lang exp/mono0a 

#steps/train_deltas.sh 2000 400 data/train_gestures data/lang exp/mono0a exp/tril
  
echo "--------------- Graph compilation ---------------"
# Make the HCLG graph  
utils/mkgraph.sh --mono data/lang_test_tg exp/mono0a exp/mono0a/graph_tgpr
  
echo "-------------------- Decoding -------------------" 
#
cp ./mfcc/train_set.ark ./exp/mono0a/
cp ./mfcc/test_set.ark ./exp/mono0a/
cp ./mfcc/cmvn_test_gestures.ark ./exp/mono0a/
cp ./mfcc/cmvn_train_gestures.ark ./exp/mono0a/
#
steps/decode.sh --nj 1 --cmd "$decode_cmd"  \
    exp/mono0a/graph_tgpr data/test_gestures exp/mono0a/decode_test_gestures
    
echo "-------------------- Output ---------------------"
for x in exp/*/decode*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done

# Deep neural networks ############################################################

steps/nnet2/train_pnorm_fast.sh  data/train_gestures data/lang exp/mono0a exp/dnn
steps/nnet2/decode.sh --nj 1 --cmd "utils/run.pl" exp/mono0a/graph_tgpr data/test_gestures exp/dnn/decode_tree


steps/nnet2/train_pnorm_fast.sh --num-hidden-layers 3  data/train_gestures data/lang exp/mono0a exp/dnn2
steps/nnet2/decode.sh --nj 1 --cmd "utils/run.pl" exp/mono0a/graph_tgpr data/test_gestures exp/dnn2/decode_tree


steps/nnet2/train_pnorm_fast.sh --num-epochs 7 --num-hidden-layers 2 --num-epochs-extra 3  data/train_gestures data/lang exp/mono0a exp/dnn3
steps/nnet2/decode.sh --nj 1 --cmd "utils/run.pl" exp/mono0a/graph_tgpr data/test_gestures exp/dnn3/decode_tree


steps/nnet2/train_pnorm_fast.sh --num-epochs 3 --num-hidden-layers 2 --num-epochs-extra 2  data/train_gestures data/lang exp/mono0a exp/dnn4
steps/nnet2/decode.sh --nj 1 --cmd "utils/run.pl" exp/mono0a/graph_tgpr data/test_gestures exp/dnn4/decode_tree


steps/nnet2/train_pnorm_fast.sh --num-epochs 3 --num-hidden-layers 1 --num-epochs-extra 2  data/train_gestures data/lang exp/mono0a exp/dnn5
steps/nnet2/decode.sh --nj 1 --cmd "utils/run.pl" exp/mono0a/graph_tgpr data/test_gestures exp/dnn5/decode_tree

# Deeper nnets (more options)

#steps/nnet2/train_pnorm_fast.sh --final-learning-rate 0.001  data/train_gestures data/lang exp/mono0a exp/dnn_enh1
#steps/nnet2/decode.sh --nj 1 --cmd "utils/run.pl" exp/mono0a/graph_tgpr data/test_gestures exp/dnn_enh1/decode_tree

# Deeper nnets (more options)
#steps/nnet2/train_pnorm_fast.sh --final-learning-rate 0.001 --num-epochs 20 --num-epochs-extra 5 data/train_gestures data/lang exp/mono0a exp/dnn_enh2
#steps/nnet2/decode.sh --nj 1 --cmd "utils/run.pl" exp/mono0a/graph_tgpr data/test_gestures exp/dnn_enh2/decode_tree





