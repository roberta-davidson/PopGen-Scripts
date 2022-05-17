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


### qpWave and qpAdm
https://github.com/DReichLab/AdmixTools/blob/master/README.QpWave \
Both take the same input parameter file: 
```
genotypename:   input genotype file (in eigenstrat or packedancestrymap r format)
snpname:       input snp file      (in eigenstrat format)
indivname:     input indiv file    (in eigenstrat format)
popleft:       left population list (1 per line) 
popright:      right population list (1 per line) 
details:       YES 
```
**qpWave** finds out how many admixture events are betwee the left and right populations. usually this should be run before qpAdm \
**qpAdm** finds the weight of admixture from the rightpop to leftppop (target).

### Pairwise individual comparisons with qpWave to find populations
Loop script to submit qpWave.sh for populations of interest:
```
#!/bin/bash

# Notification configuration
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=roberta.davidson@adelaide.edu.au

# for loop to write qpwave submission script for each populaiton in set
for i in MachuPicchu Peru
	do
	sed "s/TargetPop/$i/g" qpWave.sh > qpWave_${i}.sh
	sbatch qpWave_${i}.sh
done
```
General submission script that reads dataset and rights lift and right files, runs qpWave and summarises output statistics into a matrix for R:
```
#!/bin/bash

#load modules
ml GSL/2.5
ml OpenBLAS/0.3.1

#input dataset in eigenstrat format containing individuals from target population and refernce populations
#set input dataset and population to investigate
in1=data18
pop=TargetPop
## MUST change pop in awk commands (awk cannot call variavle in search)

#make directory
mkdir ${in1}_${pop}_qpWave
cd ${in1}_${pop}_qpWave

#copy files
cp ../${in1}.geno .
cp ../${in1}.snp .
cp ../${in1}.ind .

echo "setting variables"
#set non-target populations as a variable for popright
pops="$(awk '{if ($3!="TargetPop") print $3}' ${in1}.ind | sort | uniq)"

#set individuals in target population as a variable
inds="$(awk '{if ($3=="TargetPop") print $1"_"$3}' ${in1}.ind)"

#check
echo "POPS:
$pops
==========
INDS:
$inds
==========
DONE"

echo "preparing ind file"
#write ind file with "ID_POP" in pop column for target pop of interest
awk '{OFS="\t"} {if ($3=="TargetPop") print $1,$2,$1"_"$3; else print $1,$2,$3}' ${in1}.ind > ${in1}_${pop}.ind
echo "DONE"


echo "writing left and right files"
#write popleft file with individuals from target population
for i1 in $inds; do 
  for i2 in $inds; do
   printf "${i1}\n${i2}" > ${in1}_${i1}_${i2}.left
  done
done

##remove left files that have same individual twice
#remove duplicate rows in all left files
for file in ${in1}_*.left; do
	awk '!seen[$1]++' ${file} > ${file}_2
	mv ${file}_2 ${file}
done
#qpWave will auto abort on left files that only have one line and move to the next :)


#write popright file with populations other than target population
awk '{if ($3!="TargetPop") print $3}' ${in1}.ind | sort | uniq > ${in1}_${pop}.right
echo "DONE"

#run qpWave in a parallel loop of N-process batches for each pairwise combo
echo "running qpWave"
N=12
(
for pair in ${in1}_*.left; do
	((i=i%N)); ((i++==0)) && wait
	/hpcfs/users/a1717363/Programs/AdmixTools/bin/qpWave \
	-p <(echo "genotypename:        ${in1}.geno
	snpname:        ${in1}.snp
	indivname:      ${in1}_${pop}.ind
	popleft:        ${pair}
	popright:       ${in1}_${pop}.right
	details:        YES") \
	> ${pair}.qpWave.out &
done
)
echo "DONE"

#collate output stats for R
echo "writing stats summary table"
grep "f4rank: 0" *.left.qpWave.out | awk '{print $1,$2,$8}' > ${in1}_${pop}_summary.qpWave.out
sed -i "s/${in1}_//g" ${in1}_${pop}_summary.qpWave.out
sed -i "s/_${pop}.left.qpWave.out:f4rank://g" ${in1}_${pop}_summary.qpWave.out
sed -i "s/_${pop}_/ /g" ${in1}_${pop}_summary.qpWave.out
echo "DONE"
```

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
