#!/bin/bash

#load modules on hpc
ml GSL/2.5
ml OpenBLAS/0.3.1

#assign variable to dataset called in command
in1=$1

#write pops file of every pop in dataset
awk '{print $3}' ${in1}.ind | sort | uniq > ${in1}.poplist.txt

#Run on every quadruple combination
/hpcfs/users/a1717363/Programs/AdmixTools/bin/qpDstat \
-p <(echo "indivname:    ${in1}.ind  
snpname:      ${in1}.snp
genotypename: ${in1}.geno
poplistname: ${in1}.poplist.txt
f4mode:   YES") \
> ${in1}.qpDstat_f4.out

#clean up output file for R
grep "result" ${in1}.qpDstat_f4.out | awk '{print $2,$3,$4,$5,$6,$7,$8,$9,$10}' > ${in1}.qpDstat_f4.R.out
