#!/bin/bash

DATA=$1
ml
source activate py2env

# Input File: PLINK tped/tfam format
# Convert PLINK BED file to TPED (don't use file filtered for LD or haploidized using adpipe.py)
singularity exec -B /hpcfs/ /hpcfs/groups/acad_users/containers/plink_1.90b6.21--h031d066_5.sif plink --bfile ${DATA} --keep-allele-order --allow-no-sex --recode transpose --out ${DATA}

#update pop names in tfam
awk '{print $3}' ${DATA}.ind > ${DATA}.ID.txt
awk '{print $2,$3,$4,$5}' ${DATA}.tfam > ${DATA}.some.fam
paste ${DATA}.ID.txt ${DATA}.some.fam > ${DATA}.tfam
rm ${DATA}.ID.txt ${DATA}.some.fam
head ${DATA}.tfam

#run
pops=$(awk '{print $1}' ${DATA}.tfam | sort | uniq)
rm ${DATA}*_output.txt
echo $pops
for pop in $pops; do
	python2 /hpcfs/users/a1717363/Programs/popstats_pontus/popstats.py --file ${DATA} --pops ${pop},${pop},${pop},${pop} --pi >> ${DATA}_output.txt
done
