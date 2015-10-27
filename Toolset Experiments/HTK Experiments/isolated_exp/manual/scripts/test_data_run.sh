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
# label Files - Test
./manual/scripts/create_label_files_test.sh

echo $(pwd)

################################################################################
# A. Perform the test using hmm9
echo "Testing hmm9 1GMM"
$htk_dir/bin/HVite -A -D -T 1 -H hmm9/macros -H hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p 0.0 -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf

# B. Perform the test using hmms-2GMM/hmm9
echo "Testing hmm9 2GMM"
$htk_dir/bin/HVite -A -D -T 1 -H hmms-2GMM/hmm9/macros -H hmms-2GMM/hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p 0.0 -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf

# B. Perform the test using hmms-4GMM/hmm9

$htk_dir/bin/HVite -A -D -T 1 -H hmms-4GMM/hmm9/macros -H hmms-4GMM/hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p 0.0 -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf

# C. Perform the test using hmms-8GMM/hmm9

$htk_dir/bin/HVite -A -D -T 1 -H hmms-8GMM/hmm9/macros -H hmms-8GMM/hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p 0.0 -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf

# D. Perform the test using hmms-16GMM/hmm9

$htk_dir/bin/HVite -A -D -T 1 -H hmms-16GMM/hmm9/macros -H hmms-16GMM/hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p 0.0 -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf

# E. Perform the test using hmms-32GMM/hmm9

$htk_dir/bin/HVite -A -D -T 1 -H hmms-32GMM/hmm9/macros -H hmms-32GMM/hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p 0.0 -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf

# F. Perform the test using hmms-64GMM/hmm9

$htk_dir/bin/HVite -A -D -T 1 -H hmms-64GMM/hmm9/macros -H hmms-64GMM/hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p 0.0 -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf
	
# G. Perform the test using hmms-128GMM/hmm9

$htk_dir/bin/HVite -A -D -T 1 -H hmms-128GMM/hmm9/macros -H hmms-128GMM/hmm9/hmmdefs -C config -S testHMM.scp -l '*' -i data/recout.mlf -w manual/wdnet -p 0.0 -s 5.0 manual/gesture_lexicon manual/tiedlist	

$htk_dir/bin/HResults -I data/test_MLF.mlf manual/tiedlist data/recout.mlf
