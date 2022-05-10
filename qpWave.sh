#!/bin/bash

#load modules
ml GSL/2.5
ml OpenBLAS/0.3.1

#input dataset in eigenstrat format containing individuals from target population and refernce populations
#set input dataset and population to investigate
in1=$1
Pop=$2

echo "setting variables"
#set populations as a variable
pops=(awk '{print $3}' ${in1}.ind)
#set individuals in target population as a variable
inds=(awk '{if ($3=="${pop}") print $1"_"$3}' ${in1}.ind)
echo "DONE"

echo "preparing ind file"
#write ind file with "ID_POP" in pop column for target pop of interest
awk '{if ($3=="${pop}") print $1, $2, $1"_"$3; else print $0}' ${in1}.ind > ${in1}_${pop}.ind
echo "DONE"

echo "writing left and right files"
#write popleft file with individuals from target population
for i in inds; do 
  * code to loop right all pairwise combos*
done
#write popright file with populations other than target population
awk '{if ($3!="${pop}") print $3}' ${in1}.ind | sort | uniq > ${in1}.right
echo "DONE"

#run qpwave
/hpcfs/users/a1717363/Programs/AdmixTools/bin/qpWave \
-p <(echo "genotypename:        ${in1}.geno
snpname:        ${in1}.snp
indivname:      ${in1}_${pop}.ind
popleft:        ${in1}.left
popright:       ${in1}.right
details:        YES") \
> ${in1}.qpWave.out

#some code to consolidate output files for R
