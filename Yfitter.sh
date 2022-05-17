#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1 #nodes
#SBATCH -n 4 #cores
#SBATCH --time=02:00:00 #hh:mm::ss
#SBATCH --mem=12GB #RAM requested

# Notification configuration
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=roberta.davidson@adelaide.edu.au

#load modules
ml plink/1.90beta-4.4-21-May

#set variables
in1=$1
Yfitter=/hpcfs/users/a1717363/Programs/Yfitter_0.3

# Y chromosome haplogroup fitter for low-cov data

#convert dataset from eig to plink
convertf -p <(echo "genotypename:	${in1}.geno
snpname:	${in1}.snp
indivname:	${in1}.ind
outputformat:	PACKEDPED
genotypeoutname:	${in1}.bed
snpoutname:	${in1}.bim
indivoutname:	${in1}.fam")

# Using Plink files get the Y
plink --bfile ${in1} --chr Y --allow-no-sex --recode transpose --out ${in1}_Y
rm *nosex

# get qcall
python2 ${Yfitter}/tped2qcall.py ${in1}_Y > ${in1}_Y.qcall

#run Yfitter
${Yfitter}/Yfitter -m -s karafet_tree_b37.xml ${in1}_Y.qcall > ${in1}.Yfitter.out

#-m # multiple samples in file
#-s # print negative log likelihoods - useful for QC
#-q #sets difference in log likelihood that defines confidence haplogroup. Default 8.685
