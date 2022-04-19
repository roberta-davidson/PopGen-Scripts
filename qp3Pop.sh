#!/bin/bash

in1=$1

/hpcfs/users/a1717363/Programs/AdmixTools/bin/qp3Pop \
-p <(echo "genotypename:	${in1}.geno
snpname:	${in1}.snp
indivname:	${in1}.ind
popfilename: ${in1}.qp3.list") \
> ${in1}.qp3Pop.out
