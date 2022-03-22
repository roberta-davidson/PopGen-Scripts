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
echo ${L}

#remove vcf headers
awk 'NR>l {print $0}' l="${L}" ${VCF}.vcf > ${VCF}.nohead.vcf

#To create the .pos you do:
awk -v OFS='\t' '{print $1,$2}' ${VCF}.nohead.vcf > ${VCF}.pos

#To create the .snp you do:
awk -v OFS='\t' 'length($5)<2 && length($4)<2 {print $1"_"$2,$1,0,$2,$4,$5}' ${VCF}.nohead.vcf > ${VCF}.snp

#Create file correlating snpID with CHR_POS for safekeeping
awk -v OFS='\t' '{print $1"_"$2,$3}'  ${VCF}.nohead.vcf > ${VCF}.snp_names

#Create .BED file
awk -v OFS='\t' '{n=1;print $1,$2-n,$2}'  ${VCF}.nohead.vcf > ${VCF}.BED
