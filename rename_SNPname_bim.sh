#!/bin/bash
#if you hate rsID and want to work with "CHR_POS" as your SNP IDs, here you go:
PREFIX=${1}

awk '{print $1,$1"_"$4,$3,$4,$5,$6}' ${PREFIX}.bim > ${PREFIX}.2.bim
mv ${PREFIX}.2.bim ${PREFIX}.bim
sed -i 's/ /\t/g' ${PREFIX}.bim
