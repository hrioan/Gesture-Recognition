#!/bin/bash

classes=(BN BS CF CN CP CV DC FM FN FU MC NU OK PF PR SP ST TT VA VQ)
#echo ${classes[8]}

htk_dir=/home/scaler13/Desktop/Development/kostHTK/htk

# remove procedurally generated files
rm -rf ../../hmm0  ../../trainHMM.scp ../../data/train_labels ../../data/train_MLF.mlf

## Training Phase ##
echo "1. Prepare trainHMM.scp"
cd ../../data/
work_dir=$(pwd)

rm trainHMM.scp

for x in train/*; do
	echo $work_dir/$x >> trainHMM.scp
done

mv trainHMM.scp ../trainHMM.scp

##
cd ..
# Initialize HMM with dataset
mkdir hmm0
$htk_dir/bin/HCompV -A -D -T 1 -C config -f 0.01 -m -S trainHMM.scp -M hmm0 prototype	

# create hmmdefs and monophones0 file
cd hmm0
for x in ${classes[@]}; 
do
	echo $x >> mono_temp
	echo ~h '"'$x'"' >> hmmdefs
	
	FILENAME=prototype
	count=0
	cat $FILENAME | while read LINE
	do
		let count++
		
		if [ $count -ge 5 ]; then
		echo "    $LINE" >> hmmdefs
		fi
	done
done

sort mono_temp >> monophones0
rm mono_temp

# create macros file
FILENAME=prototype
count=0
cat $FILENAME | while read LINE
do
	let count++
	if [ $count -lt 3 ]; then
		echo "$LINE" >> macros
	fi
	
	if [ $count -eq 3 ]; then
		echo "$LINE" >> macros
	fi	
done
FILENAME=vFloors
cat $FILENAME | while read LINE
do
	echo "$LINE" >> macros	
done
cd ..

# label Files - Train
./manual/scripts/create_label_files.sh

################################################################################
# Train
################################################################################
rm -rf hmm1 hmm2 hmm3 hmm4 hmm5 hmm6 hmm7 hmm8 hmm9	# remove proc gen files

mkdir hmm1
$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 hmm0/monophones0	

# train a new hmm fo another 8 times until we have hmm9 
count=1

while [ $count -lt 9 ] 
do
	prvcnt=$count  
	let count++
	
	#hmname="hmm$prvcnt"
	
	mkdir hmm$count
	$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmm${prvcnt}/macros -H hmm${prvcnt}/hmmdefs -M 	hmm$count hmm0/monophones0
done

# silence models?
# Data re-estimation?
# Tied state triphones?

echo "HMM (1 GMM) Training Finished"
################################################################################
# Train models with 2|4|8 gaussians 'split.hed file is required'
rm -rf hmms-2GMM 
mkdir hmms-2GMM 
mkdir hmms-2GMM/hmm1

$htk_dir/bin/HHEd -H hmm9/macros -H hmm9/hmmdefs -M hmms-2GMM/hmm1 split.hed manual/tiedlist

# start training 2GMM-hmms:
count=1

while [ $count -lt 9 ] 
do
	prvcnt=$count  
	let count++
	
	#hmname="hmm$prvcnt"
	
	mkdir hmms-2GMM/hmm$count
	$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmms-2GMM/hmm${prvcnt}/macros -H hmms-2GMM/hmm${prvcnt}/hmmdefs -M 	hmms-2GMM/hmm$count  hmm0/monophones0
done

echo "HMM (2 GMMs) Training Finished"

################################################################################
# Train models with 4 gaussians 'split.hed file is required'
# Train models with 2|4|8 gaussians 'split.hed file is required'
rm -rf hmms-4GMM 
mkdir hmms-4GMM 
mkdir hmms-4GMM/hmm1

$htk_dir/bin/HHEd -H hmms-2GMM/hmm9/macros -H hmms-2GMM/hmm9/hmmdefs -M hmms-4GMM/hmm1 split.hed manual/tiedlist

# start training 4GMM-hmms:
count=1

while [ $count -lt 9 ] 
do
	prvcnt=$count  
	let count++
	
	#hmname="hmm$prvcnt"
	
	mkdir hmms-4GMM/hmm$count
	$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmms-4GMM/hmm${prvcnt}/macros -H hmms-4GMM/hmm${prvcnt}/hmmdefs -M 	hmms-4GMM/hmm$count  hmm0/monophones0
done

echo "HMM (4 GMMs) Training Finished"

################################################################################
# Train models with 4 gaussians 'split.hed file is required'
# Train models with 2|4|8 gaussians 'split.hed file is required'
rm -rf hmms-8GMM 
mkdir hmms-8GMM 
mkdir hmms-8GMM/hmm1

$htk_dir/bin/HHEd -H hmms-4GMM/hmm9/macros -H hmms-4GMM/hmm9/hmmdefs -M hmms-8GMM/hmm1 split.hed manual/tiedlist

# start training 4GMM-hmms:
count=1

while [ $count -lt 9 ] 
do
	prvcnt=$count  
	let count++
	
	#hmname="hmm$prvcnt"
	
	mkdir hmms-8GMM/hmm$count
	$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmms-8GMM/hmm${prvcnt}/macros -H hmms-8GMM/hmm${prvcnt}/hmmdefs -M 	hmms-8GMM/hmm$count  hmm0/monophones0
done

echo "HMM (8 GMMs) Training Finished"
################################################################################
# Train models with 4 gaussians 'split.hed file is required'
# Train models with 2|4|8 gaussians 'split.hed file is required'
rm -rf hmms-16GMM 
mkdir hmms-16GMM 
mkdir hmms-16GMM/hmm1

$htk_dir/bin/HHEd -H hmms-8GMM/hmm9/macros -H hmms-8GMM/hmm9/hmmdefs -M hmms-16GMM/hmm1 split.hed manual/tiedlist

# start training 4GMM-hmms:
count=1

while [ $count -lt 9 ] 
do
	prvcnt=$count  
	let count++
	
	#hmname="hmm$prvcnt"
	
	mkdir hmms-16GMM/hmm$count
	$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmms-16GMM/hmm${prvcnt}/macros -H hmms-16GMM/hmm${prvcnt}/hmmdefs -M 	hmms-16GMM/hmm$count  hmm0/monophones0
done

echo "HMM (16 GMMs) Training Finished"

################################################################################
# Train models with 4 gaussians 'split.hed file is required'
# Train models with 2|4|8 gaussians 'split.hed file is required'
rm -rf hmms-32GMM 
mkdir hmms-32GMM 
mkdir hmms-32GMM/hmm1

$htk_dir/bin/HHEd -H hmms-16GMM/hmm9/macros -H hmms-16GMM/hmm9/hmmdefs -M hmms-32GMM/hmm1 split.hed manual/tiedlist

# start training 4GMM-hmms:
count=1

while [ $count -lt 9 ] 
do
	prvcnt=$count  
	let count++
	
	#hmname="hmm$prvcnt"
	
	mkdir hmms-32GMM/hmm$count
	$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmms-32GMM/hmm${prvcnt}/macros -H hmms-32GMM/hmm${prvcnt}/hmmdefs -M 	hmms-32GMM/hmm$count  hmm0/monophones0
done

echo "HMM (32 GMMs) Training Finished"
################################################################################
# Train models with 4 gaussians 'split.hed file is required'
# Train models with 2|4|8 gaussians 'split.hed file is required'
rm -rf hmms-64GMM 
mkdir hmms-64GMM 
mkdir hmms-64GMM/hmm1

$htk_dir/bin/HHEd -H hmms-32GMM/hmm9/macros -H hmms-32GMM/hmm9/hmmdefs -M hmms-64GMM/hmm1 split.hed manual/tiedlist

# start training 64GMM-hmms:
count=1

while [ $count -lt 9 ] 
do
	prvcnt=$count  
	let count++
	
	#hmname="hmm$prvcnt"
	
	mkdir hmms-64GMM/hmm$count
	$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmms-64GMM/hmm${prvcnt}/macros -H hmms-64GMM/hmm${prvcnt}/hmmdefs -M 	hmms-64GMM/hmm$count  hmm0/monophones0
done

echo "HMM (64 GMMs) Training Finished"

################################################################################
# Train models with 128 gaussians 'split.hed file is required'
# Train models with 2|4|8 gaussians 'split.hed file is required'
rm -rf hmms-128GMM 
mkdir hmms-128GMM 
mkdir hmms-128GMM/hmm1

$htk_dir/bin/HHEd -H hmms-64GMM/hmm9/macros -H hmms-64GMM/hmm9/hmmdefs -M hmms-128GMM/hmm1 split.hed manual/tiedlist

# start training 128GMM-hmms:
count=1

while [ $count -lt 9 ] 
do
	prvcnt=$count  
	let count++
	
	#hmname="hmm$prvcnt"
	
	mkdir hmms-128GMM/hmm$count
	$htk_dir/bin/HERest -A -D -T 1 -C config -I data/train_MLF.mlf -S trainHMM.scp -H hmms-128GMM/hmm${prvcnt}/macros -H hmms-128GMM/hmm${prvcnt}/hmmdefs -M 	hmms-128GMM/hmm$count  hmm0/monophones0
done

echo "HMM (128 GMMs) Training Finished"
################################################################################



