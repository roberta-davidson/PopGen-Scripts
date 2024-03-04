#!/bin/bash

module purge
ml arch/haswell
ml arch/arch/haswell
ml modulefiles/arch/haswell
ml plink/1.90beta-4.4-21-May
conda activate read

#requirements 
#python 2.7
#R


# READ input: PLINK .tped and .tfam files
# produce tped by --recode transpose

DATA=$1

#Prepare dataset

#flags: turn off plink auto-reorder of alleles, minor allele frequency, genotyping threshold, retain individuals without sex assigned 
plink --bfile ${DATA} --keep-allele-order --maf 0.01 --geno 0.999999 --mind 1.0 --allow-no-sex --recode transpose --out ${DATA}

rm ${DATA}.nosex

# Run READ
# READ output loads pdf viewer, so may not work on HPC environments without that capability
python /hpcfs/users/a1717363/Programs/read/READ.py ${DATA}
