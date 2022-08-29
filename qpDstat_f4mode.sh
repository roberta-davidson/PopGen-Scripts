#!/bin/bash

#load modules on hpc
ml GSL/2.5
ml OpenBLAS/0.3.1

#assign variable to dataset called in command
in1=$1
in2=$2

# Automatically merge target dataset with reference fileset

mergeit -p <(echo "geno1: ${in1}.geno
snp1:  ${in1}.snp
ind1:  ${in1}.ind
geno2: ${in2}.geno
snp2:  ${in2}.snp
ind2:  ${in2}.ind
genooutfilename:   ${in1}_ref.geno
snpoutfilename:    ${in1}_ref.snp
indoutfilename:    ${in1}_ref.ind
outputformat:  EIGENSTRAT
docheck: YES
strandcheck:  YES
hashcheck: NO")


# Automatically merge with Mbuti outgroup fileset

mergeit -p <(echo "geno1: ${in1}_ref.geno
snp1:  ${in1}_ref.snp
ind1:  ${in1}_ref.ind
geno2: Mbuti.geno
snp2:  Mbuti.snp
ind2:  Mbuti.ind
genooutfilename:   ${in1}_ref_Mbuti.geno
snpoutfilename:    ${in1}_ref_Mbuti.snp
indoutfilename:    ${in1}_ref_Mbuti.ind
outputformat:  EIGENSTRAT
docheck: YES
strandcheck:  YES
hashcheck: NO")

#auto list all pops in input data for poplist file
awk '{print $3}' ${in1}_ref_Mbuti.ind | sort | uniq > ${in1}.poplist.txt

#write popfile *.trees.txt to specify quadruples to be tested
#of the form: Mbuti SAgroup Chono1 Chono2

echo "writing popfile with trees to test"
targetpops=$(awk '{print $3}' ${in1}.ind | sort | uniq)
refpops=$(awk '{print $3}' ${in2}.ind | sort | uniq)

rm ${in1}.trees.txt

for X in ${refpops}; do
  for Y in ${targetpops}; do
    for Z in ${targetpops}; do
        echo "Mbuti ${X} ${Y} ${Z} Mbuti" >> ${in1}.trees.txt
    done
  done
done

# for slurm
cat ${in1}.trees.txt

echo "done
Running f4 tests"

#Run on every quadruple combination
/hpcfs/users/a1717363/Programs/AdmixTools/bin/qpDstat \
-p <(echo "indivname:    ${in1}.ind  
snpname:      ${in1}.snp
genotypename: ${in1}.geno
poplistname: ${in1}.poplist.txt
popfilename: ${in1}.trees.txt
f4mode:   YES") \
> ${in1}.qpDstat_f4.out

#clean up output file for R
grep "result" ${in1}.qpDstat_f4.out | awk '{print $2,$3,$4,$5,$6,$7,$8,$9,$10}' > ${in1}.qpDstat_f4.R.out
