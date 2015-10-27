#!/bin/bash

classes_2=(VA VQ PF FU CP CV DC SP CN FN OK CF BS PR NU FM TT BN MC ST)
classnum=( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20)

echo "Creating Master label file ..."

cd data
mkdir train_labels

#create label files 
echo "#!MLF!#" >> train_MLF.mlf 

for x in train/*;
do
	echo '"'*/${x:6:24}.lab'"' >>  train_MLF.mlf #./train_labels/${x:6:23}.lab
	
	#./train_labels
	#echo ${x:6:23} ${x:28:2}
	#echo ${x:5:24} ${x:27:2}
	#echo ${x:28:2}
	# find the class num .. 
	count=0
	for y in ${classnum[@]}; 
	do
		if [ $y -eq ${x:28:2} ]; then
			echo ${classes_2[$count]} >> ./train_labels/${x:6:24}.lab
			echo ${classes_2[$count]} >> train_MLF.mlf
			echo ${classes_2[$count]}
			echo ./train_labels/${x:6:24}.lab
			break
		fi
		let count++	
	done
	
	echo '.' >> train_MLF.mlf
done

