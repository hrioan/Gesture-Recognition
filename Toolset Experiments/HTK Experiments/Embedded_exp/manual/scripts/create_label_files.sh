#!/bin/bash

classes_2=(VA VQ PF FU CP CV DC SP CN FN OK CF BS PR NU FM TT BN MC ST sil sp)
classnum=( '01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22')

echo "Creating Master label file ..."

cd data
mkdir train_labels
rm f1 f2
#create label files 
echo "#!MLF!#" >> train_MLF.mlf 
echo BEGIN Label File Creation

for x in train/*;
do
	#echo $x
	x=${x%.*} 
	echo '"'*/${x:6}.lab'"' >>  train_MLF.mlf #./train_labels/${x:6:23}.lab
	echo ${x:19} > f1
	
	#echo MALAKIES ${x:19}
	
	#get all class tags 
	#arr=$(echo ${x:19} | tr "_[:alpha:]."  "\n"  )
	tr "_[:alpha:]."  "\n" < f1 > f2

	#for y in ${arr[@]};
	#do
	#	let y--
	#	echo ${classes_2[$y]} >> ./train_labels/${x:6}.lab
	#	echo ${classes_2[$y]} >> train_MLF.mlf
	#	echo ${classes_2[$y]}
	#done

	cat 'f2' | while read LINE
	do
		# find the class num .. 
		count=0
		for i in ${classnum[@]}; 
		do
			#echo $LINE $i
			if [[ $i = ${LINE:0:2} ]]; then
				echo ${classes_2[$count]} >> ./train_labels/${x:6}.lab
				echo ${classes_2[$count]} >> train_MLF.mlf
				break
			
			#else if [[ 20 ]]; then
		 
			#	echo sil >> ./train_labels/${x:6}.lab
			#	echo sil >> train_MLF.mlf
			#	echo BITCH PLEASE !!! $x --- $LINE
			#	break
			fi
			
			let count++	
		done
	done
	
	echo '.' >> train_MLF.mlf
done

rm f1 f2 arr
cd ..
echo $(pwd)


