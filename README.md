# PopGen-Scripts

# F Statistics
https://bodkan.net/admixr/articles/tutorial.html 

## Outgroup F3
Command line: `qp3pop -p parfile` where parfile has format:

```
genotypename:   input genotype file (in eigenstrat format)
snpname:        input snp file      (in eigenstrat format)
indivname:      input indiv file    (in eigenstrat format)
popfilename:    a file containing rows with three populations on each line A, B and C.
inbreed: YES #used if pseudodiploid
```
## F4 Stats
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

## hapROH
Paper:https://www.biorxiv.org/content/10.1101/2021.06.22.449449v1 \
GitHub: https://github.com/danimfernandes/tkgwv2 \
Slurm submition script: (Doesn't work yet)
```
ml plink/1.90beta-4.4-21-May
ml R/3.6.3
ml Python/3.6.6
source /hpcfs/users/a1717363/local/virtualenvs/tkgwv2/bin/activate

cd /hpcfs/users/a1717363/IncaModern/07-indelRealign/

python /hpcfs/users/a1717363/tkgwv2-master/TKGWV2.py \
 bam2plink --referenceGenome /hpcfs/users/a1717363/mapping_resources/GRCh37/ \
 --gwvList /hpcfs/users/a1717363/InkaAncestryProj/Analyses/Low-cov_kinship/HumOrg_Extra_NOADMIXTURE.BED \
 --bamExtension indelReal.bam \
 --gwvPlink /hpcfs/users/a1717363/InkaAncestryProj/Analyses/Low-cov_kinship/HumOrg_Extra_NOADMIXTURE \
 plink2tkrelated --freqFile /hpcfs/users/a1717363/InkaAncestryProj/Analyses/Low-cov_kinship/HumOrg_Extra_NOADMIXTURE.frq \
deactivate
```
Phoenix Wiki for using Python virtual envs inside slurm script: https://wiki.adelaide.edu.au/hpc/Python_virtual_environment

# Identity By Descent (IBD)
## hapROH
- VCF input (I think)
- can test close-kin unions & background relatedness
- primed for pseudohaploid 1240k data \
https://github.com/hringbauer/hapROH \
https://pypi.org/project/hapROH/ 
