# PopGen-Scripts

## ADMIXTOOLS
https://github.com/DReichLab/AdmixTools \
Install on HPC:
```
git clone https://github.com/DReichLab/AdmixTools.git
```
```
ml gslib/90-GCC-4.9.3-binutils-2.25
```
```
ml OpenBLAS/0.3.1
```
```
ml GSL/2.5
```
```
cd src
```
```
make clobber
```
```
make install
```

### F Statistics
https://bodkan.net/admixr/articles/tutorial.html 

### Outgroup F3
Command line: `qp3pop -p parfile` where parfile has format:

```
genotypename:   input genotype file (in eigenstrat format)
snpname:        input snp file      (in eigenstrat format)
indivname:      input indiv file    (in eigenstrat format)
popfilename:    a file containing rows with three populations on each line A, B and C.
inbreed: YES #used if pseudodiploid or if target pop IS inbred
```
Bash submission script:
```
in1=$1

/hpcfs/users/a1717363/Programs/AdmixTools/bin/qp3Pop \
-p <(echo "genotypename:	${in1}.geno
snpname:	${in1}.snp
indivname:	${in1}.ind
popfilename: ${in1}.qp3.list") \
> ${in1}.qp3Pop.out
```

### F4 Stats
Command line: `qp3pop -p parfile` where parfile has format:
```
genotypename:   input genotype file (in eigenstrat format)
snpname:        input snp file      (in eigenstrat format)
indivname:      input indiv file    (in eigenstrat format)
popfilename:    a file containing rows with three populations on each line A, B and C.
f4mode: YES
```
# Kinship Analyses
## READ
The kinship analysis in READ is one-liners in plink to prune the data then one-liner for READ … “python ./READ.py dataprefix”. 
READ: https://bitbucket.org/tguenther/read/src/master/ 

Prepare dataset:
```
plink --bfile ${DATA} --keep-allele-order --maf 0.01 --geno 0.999999 --mind 1.0 --allow-no-sex --recode transpose --out ${DATA}
```
READ requires R so I've been downloading and running locally:
Run READ:
```
python READ.py <dataprefix>
```
## TKGWV2
Paper:https://www.biorxiv.org/content/10.1101/2021.06.22.449449v1 \
GitHub: https://github.com/danimfernandes/tkgwv2 \
Slurm submition script prepares input files from reference panel set in binary plink: 
```
module purge
ml arch/haswell
ml arch/arch/haswell
ml modulefiles/arch/haswell
ml R/3.5.1
export R_LIBS_USER=/hpcfs/users/a1717363/local/RLibs
ml plink
#requires python 3

#plink prefix name of population reference panel
POP_FRQ=SAmerge4

# filter missing SNPs (geno 0.9999) and fixed sites (maf 0.001) in ref dataset 
plink --bfile ${POP_FRQ} --keep-allele-order --maf 0.001 --geno 0.99999 --make-bed --out ${POP_FRQ}_maf

#call population allele frequencies from ref dataset
plink --bfile ${POP_FRQ}_maf --freq --out ${POP_FRQ}
rm *nosex

#write BED file of sites in .frq file (CHR pos0 pos1). 
 # NB This works where the SNP name has been changed to "CHR_POS" previous to generating the .frq file
awk 'NR>1 {print $1,$2}' ${POP_FRQ}.frq > ${POP_FRQ}.1.BED 
sed -i 's/_/\t/g' ${POP_FRQ}.1.BED
awk '{n=1; print $1,$3-n,$3}' ${POP_FRQ}.1.BED > ${POP_FRQ}.BED
rm ${POP_FRQ}.1.BED

# Run TKGWV2
# Starting from BAM files and running 'bam2plink' and then 'plink2tkrelated':
# Will run bam2plink and plink2related on run directory, so move bams into rundir
/hpcfs/users/a1717363/Programs/tkgwv2-master/TKGWV2.py bam2plink \
	--referenceGenome /hpcfs/users/a1717363/mapping_resources/GRCh37/human_g1k_v37_decoy.fasta \
	--gwvList ./${POP_FRQ}.BED \
	--gwvPlink ./${POP_FRQ}_maf \
	--bamExtension libmerged.trimmed.bam \
	plink2tkrelated \
	--freqFile ./${POP_FRQ}.frq \
	--dyads Priestess.dyads
```
Phoenix Wiki for using Python virtual envs inside slurm script: https://wiki.adelaide.edu.au/hpc/Python_virtual_environment

# Identity By Descent (IBD)
## hapROH
- VCF input (I think)
- can test close-kin unions & background relatedness
- primed for pseudohaploid 1240k data \
https://github.com/hringbauer/hapROH \
https://pypi.org/project/hapROH/ 
