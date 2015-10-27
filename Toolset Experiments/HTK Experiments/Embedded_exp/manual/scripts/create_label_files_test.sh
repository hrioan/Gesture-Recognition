#!/bin/bash

classes_2=(VA VQ PF FU CP CV DC SP CN FN OK CF BS PR NU FM TT BN MC ST)
classnum=( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20)

echo "Creating Master label file ..."

cd data

rm -rf test_MLF.mlf test_labels
 
mkdir test_labels

#create label files 
echo "#!MLF!#" >> test_MLF.mlf 

for x in test/*;
do
	#echo '"'*/${x:5:24}.lab'"'	
	echo '"'*/${x:5}.lab'"' >>  test_MLF.mlf #./test_labels/${x:6:23}.lab
	
	#./test_labels
	
	# find the class num .. 
	count=0
	for y in ${classnum[@]}; 
	do
		#echo ${x:27:2}
		if [ $y -eq ${x:27:2} ]; then
			echo ${classes_2[$count]} >> ./test_labels/${x:5}.lab
			echo ${classes_2[$count]} >> test_MLF.mlf
			break
		fi
		let count++	
	done
	
	echo '.' >> test_MLF.mlf
done
