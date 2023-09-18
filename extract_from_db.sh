#!/bin/bash

# Function to display usage instructions
display_help() {
    echo "Usage: $0 <input1>"
    echo "This script takes variants in a tsv format."
    echo "  <input1>: variants.tsv"
    echo "Options:"
    echo "  -h, --help: Show this help message and exit"
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check if both arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Error:Iinput argument is required. Use -h or --help for usage instructions."
    exit 1
fi

# Assign the input arguments to variables
input1="/media/genapqnap/local_DB-202309/DB_2023_09_wo.tsv"
#input1="Sample_2021020_Hom.tsv"
input2=$1

base_filename="${input2%%.*}"
echo "your file name is $base_filename"

db_name=$(basename "$input1")

# Now you can use $input1 and $input2 in your script
#cat $input2 | awk -F'\t' 'NR == FNR {a[$1,$2,$3,$4]; next} ($1,$2,$3,$4) in a' - <(cat $input1) > final.tsv
#cat $input2 | awk -F'\t' 'NR == FNR {a[$1,$2,$3,$4] = $5; next} ($1,$2,$3,$4) in a {print $0, a[$1,$2,$3,$4]}' - <(cat $input1) > final.tsv
awk -F'\t' 'NR == FNR {a[$1,$2,$3,$4] = $5; next} ($1,$2,$3,$4) in a {print $0 "\t" a[$1,$2,$3,$4]}' $input2 $input1 > ${base_filename}_in_DB.tsv

echo "local DB name is: $db_name"
echo "Input file name is: $base_filename"
