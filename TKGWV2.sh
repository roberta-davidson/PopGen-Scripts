#!/bin/bash
# TKGWV2 is An ancient DNA relatedness pipeline for ultra-low coverage whole genome shotgun data

#module setup
module purge
ml arch/haswell
ml arch/arch/haswell
ml modulefiles/arch/haswell
ml R/3.5.1

#requires R package data.table, hence this line for running on hpc
export R_LIBS_USER=/hpcfs/users/a1717363/local/RLibs
ml plink
#requires python 3, run appropriate environment with conda

#plink prefix name of population reference panel
POP_FRQ=SAmerge4

# filter missing SNPs (geno 0.9999) and fixed sites (maf 0.001) in ref dataset 
plink --bfile ${POP_FRQ} --keep-allele-order --maf 0.001 --geno 0.99999 --make-bed --out ${POP_FRQ}_maf

#call population allele frequencies from ref dataset
plink --bfile ${POP_FRQ}_maf --freq --out ${POP_FRQ}
rm *nosex

#rewrite .bim file so snp names are "CHR_POS"
awk '{print $1,$1"_"$4,$3,$4,$5,$6}' ${POP_FRQ}.bim > ${POP_FRQ}.2.bim
mv ${POP_FRQ}.2.bim ${POP_FRQ}.bim
sed -i 's/ /\t/g' ${POP_FRQ}.bim

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
