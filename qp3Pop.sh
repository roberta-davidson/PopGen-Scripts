#!/bin/bash

#load modules (hpc)
ml GSL/2.5
ml OpenBLAS/0.3.1

# Script is for F3(Mbuti;P2,i) where P2 is pop of interest and i rotates among other populations
#set variables to call in the submission command. in1 is dataset and P2 is population to compare everything else against
in1=$1
P2=$2

# Automatically merge with Mbuti outgroup fileset

mergeit -p <(echo "geno1: ${in1}.geno
snp1:  ${in1}.snp
ind1:  ${in1}.ind
geno2: Mbuti.geno
snp2:  Mbuti.snp
ind2:  Mbuti.ind
genooutfilename:   ${in1}_Mbuti.geno
snpoutfilename:    ${in1}_Mbuti.snp
indoutfilename:    ${in1}_Mbuti.ind
outputformat:  EIGENSTRAT
docheck: YES
strandcheck:  YES
hashcheck: NO")

# for loops to write the qp3.list file as required, one triplet per line, in order (X,Test;Outgroup)
echo "writing list file"
pops=$(awk '{print $3}' ${in1}.ind | sort | uniq)

#remove old or failed list files
rm ${in1}.qp3.list

#write file
for i in ${pops}; do
        echo "${i} ${P2} Mbuti" >> ${in1}.qp3.list
done

# for log
cat ${in1}.qp3.list

echo "done
Running qp3Pop"

#run qp3
/hpcfs/users/a1717363/Programs/AdmixTools/bin/qp3Pop \
-p <(echo "genotypename:        ${in1}_Mbuti.geno
snpname:        ${in1}_Mbuti.snp
indivname:      ${in1}_Mbuti.ind
popfilename: ${in1}.qp3.list") \
> ${in1}_${P2}.qp3Pop.out

# for slurm
cat ${in1}.qp3Pop.out

#modify results output to ease R plotting
grep 'result:' ${in1}_${P2}.qp3Pop.out | awk '{print $2, $3, $4, $5, $6, $7, $8, $9}' > ${in1}_${P2}.R.qp3Pop.out