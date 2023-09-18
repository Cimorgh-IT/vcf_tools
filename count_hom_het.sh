#!/bin/bash

#input file 
input=$1
echo "your input file is $input"
# Extract the base filename without the extension
base_filename="${input%%.*}"
echo "your file name is $base_filename"
# Check the file extension and run the appropriate script
if [[ ${input} == *.vcf.gz || ${input} == *.vcf ]]
then
    bcftools query -f '[ %GT]\n' ${input} | awk '
BEGIN { hom_total = 0; unknown_total = 0; ref_call_total=0; total_variants = 0 }
{
    total_variants++;
    if ($1 == "." || $1 == "./." || $1 == "0/." || $1 == ".|." || $1 == "./0") unknown_total++;
    else if ($1 == "0/0") ref_call_total++;
    else if ($1 ~ /0\/0/ || $1 ~ /1\/1/) hom_total++;
}
END {
    print "Total Variants:", total_variants;
    print "Total RefCall:", ref_call_total
    print "Unknown Variants:", unknown_total;
    print "Total Homozygote Variants:", hom_total;
    print "Total Heterozygote Variants:", total_variants-ref_call_total-unkwnon_total-hom_total;
}' > ${base_filename}_counts.txt

else
    echo "Unsupported file format: ${input}"
fi
