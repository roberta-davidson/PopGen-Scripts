#!/bin/bash

DATA=$1
#define pops
pops=$(awk '{print $3}' ${DATA}.ind | sort | uniq)

#submit for each pop
for P2 in $pops; do
        sbatch qp3pop_offtarget.sh ${DATA} ${P2}
done
