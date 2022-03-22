IN1=$1
IN2=$2
OUT=$3

#merge IN1 with IN2
cat ${IN1}.bed ${IN2}.bed >> ${OUT}.bed

#change colon for tab
sed -i 's/:/\t/g' ${OUT}.bed

#change slash for tab
sed -i 's/\//\'$'\t/g' ${OUT}.bed

#change arrow for tab
sed -i 's/->/\t/g' ${OUT}.bed

#remove the word chr
sed -i 's/chr//g' ${OUT}.bed

#change SNP name for ChrNumber_pos
awk '{print $1,$2,$3,$1"_"$3,$5,$6}' ${OUT}.bed >> ${OUT}_2.bed

#remove duplicates
awk '!seen[$4]++' ${OUT}_2.bed > ${OUT}_3.bed

#sort file by chr and pos
sort -V -k1 -k2 ${OUT}_3.bed > ${OUT}_sorted.bed

#rm intermediates
rm ${OUT}_2.bed ${OUT}_3.bed ${OUT}.bed

#CREATE POS FILE
awk '{print $1,$3}' ${OUT}_sorted.bed > ${OUT}_sorted.pos

#CREATE SNP FILE
awk '{print $4,$1,"0.0",$3,$5,$6}' ${OUT}_sorted.bed > ${OUT}_sorted..snp
