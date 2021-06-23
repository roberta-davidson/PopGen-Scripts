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

# Identity By Descent (IBD)
## hapROH
- VCF input (I think)
- can test close-kin unions & background relatedness
- primed for pseudohaploid 1240k data \
https://github.com/hringbauer/hapROH \
https://pypi.org/project/hapROH/ 
