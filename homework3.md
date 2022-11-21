#Script#!/usr/bin/env bash

srun -A class-ee282 --pty --x11 bash -i
conda activate ee282

# Change directory to github
myrepos/ee282

# Creating a new branch for homework3
`git checkout -b homework3`


# FIRST PART: GENOME SUMMARY
==================

## Download the database for all chromosomes

`wget http://ftp.flybase.net/releases/FB2022_05/dmel_r6.48/fasta/dmel-all-chromosome-r6.48.fasta.gz`


## Verify file integrity 

`shasum  dmel-all-chromosome-r6.48.fasta.gz > all_chrom.txt`
`shasum  -c all_chrom.txt`
 

## Summarize annotation file  

`faSize dmel-all-chromosome-r6.48.fasta.gz > dmel-all-chromosome-r6.48.fasta.gz.txt
less dmel-all-chromosome-r6.48.fasta.gz.txt`

Answer:
1. Total number of nucleotides: 143726002 
2. Total number of Ns: 1152978
3. Total number of sequences: 1870


# SECOND PART: ANNOTATION SUMMARY
=======================

## Download data base (annotation file) as .gz and .txt 

`wget http://ftp.flybase.net/releases/FB2022_05/dmel_r6.48/gtf/dmel-all-r6.48.gtf.gz`

`deml="http://ftp.flybase.net/releases/FB2022_05/dmel_r6.48/gtf/dmel-all-r6.48.gtf.gz"`
`wget -O - -q $deml \`
`| gunzip \`
`> flygtf.txt`


## Verify file integrity 

`shasum dmel-all-r6.48.gtf.gz > dmel.gtf.gz.txt`
`shasum -c dmel.gtf.gz.txt`


## Total number of features of each type  

`bioawk -c gff '{print $3}' flygtf.txt > flybioawk.txt` 
`sort flybioawk.txt \`
`| uniq -c \`
`| sort -k1,1rn \`
`> flysorted.txt`
`less flysorted.txt`

Answer:
 190050 exon
 163242 CDS
  46802 5UTR
  33738 3UTR
  30885 start_codon
  30825 stop_codon
  30799 mRNA
  17896 gene
   3053 ncRNA
    485 miRNA
    365 pseudogene
    312 tRNA
    300 snoRNA
    262 pre_miRNA
    115 rRNA
     32 snRNA



## Total number of genes per chromosome arm (X, Y, 2L, 2R, 3L, 3R, 4) 

`bioawk -c gff '{print $1 "\t" $3 }' flygtf.txt \`
`|sort -k2,2rn \`
`|grep -w "gene" \`
`|uniq -c \`
`> geneschrom.txt`

Answer:
1. X: 2708
2. Y: 113
3. 2L: 3515
4. 2R: 3653
5. 3L: 3489
6. 3R: 4227
7. 4: 114

