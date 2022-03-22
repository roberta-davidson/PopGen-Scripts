VCF=$1

#Need to create  .snp and .pos and .BED file. 
#.pos file looks like: 
#22      16050075
#22      16050115

#.snp file looks like it:
#rs587697622     22      0       16050075        A       G
#rs587755077     22      0       16050115        G       A

#.BED file looks like this:
#22      16050074     16050075
#22      16050114     16050115

#count header rows
L="$(grep "#" ${VCF}.vcf | wc -l)"
echo "Header rows - ${L}"

#remove vcf headers
awk 'NR>l {print $0}' l="${L}" ${VCF}.vcf > ${VCF}.nohead.vcf

#To create the .snp of only SNPs, remove longer variants and rename snpID to "CHR_SITE", you do:
awk -v OFS='\t' 'length($5)<2 && length($4)<2 {print $1"_"$2,$1,0,$2,$4,$5}' ${VCF}.nohead.vcf > ${VCF}.snp

#Create file correlating snpID with CHR_POS for safekeeping
awk -v OFS='\t' '{print $1"_"$2,$3}'  ${VCF}.nohead.vcf > ${VCF}.snp_names

#To create the .pos from snp sites you do:
awk -v OFS='\t' '{print $3,$4}' ${VCF}.snp > ${VCF}.pos

#Create .BED from snp sites file
awk -v OFS='\t' '{n=1;print $3,$4-n,$4}' ${VCF}.snp > ${VCF}.BED

# Clean up
rm ${VCF}.nohead.vcf
