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
for i1 in $inds; do 
  for i2 in $inds; do
   echo "${i1}\n${i2}" > ${in1}_${i1}_${i2}.left
  done
done

#write popright file with populations other than target population
awk '{if ($3!="${pop}") print $3}' ${in1}.ind | sort | uniq > ${in1}.right
echo "DONE"

#run qpwave
for left in ${in1}*.left; do
/hpcfs/users/a1717363/Programs/AdmixTools/bin/qpWave \
-p <(echo "genotypename:        ${in1}.geno
snpname:        ${in1}.snp
indivname:      ${in1}_${pop}.ind
popleft:        ${left}
popright:       ${in1}.right
details:        YES") \
> ${in1}.${left}.qpWave.out
done

#some code to consolidate output files for R
grep "f4rank" ${in1}*.qpWave.out | awk '{print $1,$2,$8}' > ${in1}_${pop}_summary.qpWave.out
sed -i 's/.qpWave.out:f4rank://g' ${in1}_${pop}_summary.qpWave.out
