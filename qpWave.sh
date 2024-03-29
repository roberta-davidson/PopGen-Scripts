#!/bin/bash

#load modules
ml GSL/2.5
ml OpenBLAS/0.3.1

#input dataset in eigenstrat format containing individuals from target population and refernce populations
#set input dataset and population to investigate
in1=data18
pop=TargetPop
## MUST change pop in awk commands below (awk cannot call variable in search)

#make directory
mkdir ${in1}_${pop}_qpWave
cd ${in1}_${pop}_qpWave

#copy files
cp ../${in1}.geno .
cp ../${in1}.snp .
cp ../${in1}.ind .

echo "setting variables"
#set non-target populations as a variable for popright
pops="$(awk '{if ($3!="TargetPop") print $3}' ${in1}.ind | sort | uniq)"

#set individuals in target population as a variable
inds="$(awk '{if ($3=="TargetPop") print $1"_"$3}' ${in1}.ind)"

#check
echo "POPS:
$pops
==========
INDS:
$inds
==========
DONE"

echo "preparing ind file"
#write ind file with "ID_POP" in pop column for target pop of interest so each individual is treated seperately rather than as one population
awk '{OFS="\t"} {if ($3=="TargetPop") print $1,$2,$1"_"$3; else print $1,$2,$3}' ${in1}.ind > ${in1}_${pop}.ind
echo "DONE"


echo "writing left and right files"
#write popleft files with individuals from target population (one file per pair, one individual per line)
for i1 in $inds; do 
  for i2 in $inds; do
   printf "${i1}\n${i2}" > ${in1}_${i1}_${i2}.left
  done
done

#remove duplicate rows in all left files
for file in ${in1}_*.left; do
	awk '!seen[$1]++' ${file} > ${file}_2
	mv ${file}_2 ${file}
done
#qpWave will auto abort on left files that only have one line and move to the next left file :)

#write popright file with populations other than target population
awk '{if ($3!="TargetPop") print $3}' ${in1}.ind | sort | uniq > ${in1}_${pop}.right
echo "DONE"

#run qpWave in a parallel loop of N-process batches for each pairwise combo
echo "running qpWave"
N=12
(
for pair in ${in1}_*.left; do
	((i=i%N)); ((i++==0)) && wait
	/hpcfs/users/a1717363/Programs/AdmixTools/bin/qpWave \
	-p <(echo "genotypename:        ${in1}.geno
	snpname:        ${in1}.snp
	indivname:      ${in1}_${pop}.ind
	popleft:        ${pair}
	popright:       ${in1}_${pop}.right
	details:        YES") \
	> ${pair}.qpWave.out &
done
)
echo "DONE"

#collate output stats for R plotting - (can't remember if this works or might need some fixing)
echo "writing stats summary table"
grep "f4rank: 0" *.left.qpWave.out | awk '{print $1,$2,$8}' > ${in1}_${pop}_summary.qpWave.out
sed -i "s/${in1}_//g" ${in1}_${pop}_summary.qpWave.out
sed -i "s/_${pop}.left.qpWave.out:f4rank://g" ${in1}_${pop}_summary.qpWave.out
sed -i "s/_${pop}_/ /g" ${in1}_${pop}_summary.qpWave.out
echo "DONE"
