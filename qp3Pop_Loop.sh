#!/bin/bash

#wrapper script to loop submissions of qp3Pop.sh across multiple "P2" populations
DATA=$1
#define pops
pops=$(awk '{print $3}' ${DATA}.ind | sort | uniq)s

#submit for each pop
for P2 in $pops; do
        sbatch qp3pop.sh ${DATA} ${P2}
done