#!/bin/bash

htk_dir=/home/scaler13/Desktop/Development/kostHTK/htk

# Prepare test data
echo "1. Prepare testHMM.scp"
cd ../../data/
work_dir=$(pwd)

rm ../../testHMM.scp ../../data/test_labels ../../data/test_MLF.mlf

for x in test/*; do
	echo $work_dir/$x >> testHMM.scp
done

mv testHMM.scp ../testHMM.scp
cd ..

################################################################################
# label Files - For Embedded testing we make use of the HTKLAB files (unknown labels)
#./manual/scripts/create_label_files_test.sh
for f in ./HTKLAB/*; do

echo $f
cp $f data/test_labels
done
mv data/test_labels/test_MLF.mlf data/test_MLF.mlf
################################################################################

echo $(pwd)

################################################################################-p 0.0 
# A. Perform the test using hmm9
echo "Testing hmm9 1GMM"
$htk_dir/bin/HVite -A -D -T 1 -H hmm9/macros -H hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p -100.0  -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf



