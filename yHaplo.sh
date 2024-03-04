#!/bin/bash
# To determine Y haplogroup from Y chromosome variants

## Requirements: Plink, Eigensoft, Yhaplo

#load modules
ml plink/1.90beta-4.4-21-May
yhaplo=/hpcfs/users/a1717363/Programs/yhaplo
in1=$1

# inputs VCF file (only Y chr sites)

#convert dataset from eig to plink using eigenstrat convertf
convertf -p <(echo "genotypename:	${in1}.geno
snpname:	${in1}.snp
indivname:	${in1}.ind
outputformat:	PACKEDPED
genotypeoutname:	${in1}.bed
snpoutname:	${in1}.bim
indivoutname:	${in1}.fam")

# Using Plink files get the Y vcf
plink --bfile ${in1} --chr Y --keep-allele-order --allow-no-sex --recode vcf-iid bgz --out ${in1}_Y
rm *nosex

# Run
yhaplo --input ${in1}_Y.vcf.gz \
  --all_aux_output