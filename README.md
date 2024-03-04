# PopGen-Scripts
Miscellaneous scripts I have used in ancient DNA and popgen. Take with a grain of salt.

## ADMIXTOOLS
https://github.com/DReichLab/AdmixTools \

## F Statistics
https://bodkan.net/admixr/articles/tutorial.html 

## qpWave and qpAdm
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
**qpAdm** then finds the weight of admixture from the rightpop to leftppop (target).

## Pairwise individual comparisons with qpWave to find populations
To test if each pair of individuals forms a clade relative to outgroups. Outgroup matters - if you use africa then everything will be a clade relatively, if you use something too similar then nothing will be a clade. 

- Use the `qpWave.sh` script to run qpwave for every pair ina target population. Requires eigenstrat dataset containing the target population and outgroup population. 
- Use `qpWaveLoop.sh` if you want to run pairwise qpwave for multiple populations in your dataset, it submits batch jobs for each specified population in a loop. 
- Download the data and plot in R with `qpWave_Pairwise.R` to get a plot like this, where darker blocks are "populations" because the do not have significant values for being a clade relative to the outgroup:
<img width="700" alt="image" src="https://user-images.githubusercontent.com/78726635/178389774-1db5eb26-fde1-4c68-a326-321b101af1c4.png">

Style inspired by this paper https://www.nature.com/articles/s41559-020-1102-0

## Outgroup F3 tests
Tests of this tree: \
<img width="250" alt="image" src="https://user-images.githubusercontent.com/78726635/178389363-0c5c71c6-41b5-4513-8695-b94bf4f22bf6.png">

F3 is a measure of the branch length of the blue, therefore higher F3 means closer related X and Test.

- Use `qp3Pop.sh` to run outgroup F3 on a dataset, specifying the Test populaiton, and the script will rotate X as all other populations in the dataset.
- Use `qp3Pop_Loop.sh` if you want to submit a job of `qp3Pop.sh` for each test population. i.e, to run every combination in your dataset.
- Use `F3_plot.R` to plot in R, like this:

<img width="700" alt="image" src="https://user-images.githubusercontent.com/78726635/178390806-ead79783-21f8-4ea0-a79c-aa32a6598317.png">


## F4 Stats


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
