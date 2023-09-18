#!/bin/bash

#input file
input=$1
echo "your input file is $input"
# Extract the base filename without the extension
base_filename="${input%%.*}"
echo "your file name is $base_filename"
# Check the file extension and run the appropriate script
if [[ ${input} == *.vcf.gz || ${input} == *.vcf ]];then

    /usr/bin/bcftools filter -i "GT='1/1'" -O z ${input} | \
    /usr/bin/bcftools annotate -x ID,QUAL,FILTER,INFO,^FORMAT/GT -O z > ${base_filename}_hom_GT.vcf.gz
    #tabix -p vcf ${base_filename}_hom_GT.vcf.gz
    zcat ${base_filename}_hom_GT.vcf.gz | awk 'BEGIN {OFS="\t"} {print $1, $2, $4, $5, $10}' > ${base_filename}_hom.vcf
    grep -v '^##' ${base_filename}_hom.vcf | sed 's/#//g' > ${base_filename}_Hom.tsv
fi 
