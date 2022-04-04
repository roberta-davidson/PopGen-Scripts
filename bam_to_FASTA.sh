#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=00:20:00
#SBATCH --mem=4GB

#calling consensus using freebayes with stringent filter

#load modules
ml freebayes
ml BCFtools/1.9-foss-2016b

cd /bamdir/

for i in {1..96..1}; do
freebayes -0 -f ../ref_rCRS/RCRS.fasta S${i}_EI_MT_190521_MEM_REALN_MKDUP_RECAL.bam > vcf_fb/S${i}_fb_call.vcf
bgzip vcf_fb/S${i}_fb_call.vcf
tabix vcf_fb/S${i}_fb_call.vcf.gz
cat ../ref_rCRS/RCRS.fasta | bcftools consensus vcf_fb/S${i}_fb_call.vcf.gz | sed s/MT/S10_cns/g > fa_fb/S10.fa
done




##haplogrep
java -jar ../../haplogrep haplogrep-2.1.18.jar  --in sahul_EI_190521.fa  --format fasta --out sahul_EI_190521_haplogrep.txt
