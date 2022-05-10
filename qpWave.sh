#!/bin/bash

#load modules
ml GSL/2.5
ml OpenBLAS/0.3.1

#set input dataset and population to investigate
in1=$1
Pop=$2

echo "setting variables"
#set populations as a variable
pops=(awk '{print $3}' ${in1}.ind)
#set individuals in target population as a variable
inds=(if $3=="${pop}", then awk '{print $1}' ${in1}.ind)
echo "DONE"

echo "writing left and right files"

#set up listfiles for pairwise comparison of all indiviuals
#rename pops so every individual is "ID_POP"
awk '{print $1, $2, $1"_"$3}' ${in1}.ind > ${in1}_${pop}.ind
#set individuals as a variable to write files
echo "writing list file"


##NEED:
#popleft loops pairwise individuals from population of interest
#popright populations of reference (eg typical nakatsuka ones for SA)





#Setting inds as a variable
#inds=$(awk '{print $3}' ${in1}_ind.ind)

#writing left & right files for pairwise comparison of individuals
awk '{print $3}' ${in1}_ind.ind > ${in1}.left
echo "TW059_Tiwanaku" > ${in1}.right

#run qpwave
/hpcfs/users/a1717363/Programs/AdmixTools/bin/qpWave \
-p <(echo "genotypename:        ${in1}.geno
snpname:        ${in1}.snp
indivname:      ${in1}_ind.ind
popleft:        ${in1}.left
popright:       ${in1}.right
details:        YES") \
> ${in1}.qpWave.out
