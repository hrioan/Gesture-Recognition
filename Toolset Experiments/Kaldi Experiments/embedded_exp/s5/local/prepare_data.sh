#!/bin/bash

mkdir -p data/local
local=`pwd`/local
scripts=`pwd`/scripts

export PATH=$PATH:/home/scaler13/Desktop/Development/Kaldi_speech/kaldi-trunk/tools/irstlm/bin

echo "Preparing train and test data"

train_base_name=train_gestures
test_base_name=test_gestures
ges_dir=$1

cd data/local

ls -1 ../../$ges_dir > gestures_all.list
# distribute 60% of the data as train and the other 40% as test data
../../local/create_gestures_test_train.pl gestures_all.list gestures.test gestures.train

# extract the paths of test gestures
../../local/create_gestures_scp.pl ${ges_dir} gestures.test > ${test_base_name}_txt.scp

../../local/create_gestures_scp.pl ${ges_dir} gestures.train > ${train_base_name}_txt.scp

../../local/create_gestures_txt.pl gestures.test > ${test_base_name}.txt

../../local/create_gestures_txt.pl gestures.train > ${train_base_name}.txt

cp ../../input/task.arpabo lm_tg.arpa

cd ../..


# This stage was copied from WSJ example
for x in train_gestures test_gestures; do 
  mkdir -p data/$x
  cp data/local/${x}_txt.scp data/$x/wav.scp
  cp data/local/$x.txt data/$x/text
  cat data/$x/text | awk '{printf("%s global\n", $1);}' > data/$x/utt2spk
  utils/utt2spk_to_spk2utt.pl <data/$x/utt2spk >data/$x/spk2utt
done

