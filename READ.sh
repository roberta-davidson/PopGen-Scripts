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
# prodece tped by --recode transpose

DATA=$1

#Prepare dataset

plink --bfile ${DATA} --keep-allele-order --maf 0.01 --geno 0.999999 --mind 1.0 --allow-no-sex --recode transpose --out ${DATA}

rm ${DATA}.nosex

# Run READ
python /hpcfs/users/a1717363/Programs/read/READ.py ${DATA}
