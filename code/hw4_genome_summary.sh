#!/usr/bin/env bash

srun -A class-ee282 --pty --x11 bash -i
conda activate ee282

# Change directory
cd ~/myrepos/ee282


# SUMMARIZING PARTITIONS

wget http://ftp.flybase.net/releases/FB2022_05/dmel_r6.48/fasta/dmel-all-chromosome-r6.48.fasta.gz 

# ≤ 100kb (lt)

faFilter -maxSize=100000 dmel-all-chromosome-r6.48.fasta.gz lt.fa 
gzip -c lt.fa > lt.fa.gz 
faSize lt.fa.gz > lt.fa.txt
less lt.fa.txt

# > 100kb (gt)

faFilter -minSize=100001 dmel-all-chromosome-r6.48.fasta.gz gt.fa
gzip -c gt.fa > gt.fa.gz
faSize gt.fa.gz > gt.fa.txt
less gt.fa.txt


# PLOTTING PARTITIONS

# ≤ 100kb (lt)

bioawk -c fastx ' { print length($seq) "\t" gc($seq) "\t" $name } ' lt.fa.gz \
> lt.lgcn.txt 
sort -k1,1rn lt.lgcn.txt > lt.lgcnsrt.txt

## 1 and 2 in RStudio script

## 3.Cumulative sorted

plotCDF <(cut -f 1 lt.lgcnsrt.txt) lt.lgsrt.png
display lt.lgsrt.png

# > 100kb (gt)

bioawk -c fastx ' { print length($seq) "\t" gc($seq) "\t" $name } ' gt.fa.gz \
> gt.lgcn.txt 
sort -k1,1rn gt.lgcn.txt > gt.lgcnsrt.txt

## 1 and 2 in RStudio script

## 3.Cumulative sorted

plotCDF <(cut -f 1 gt.lgcnsrt.txt) gt.lgsrt.png
display lt.lgsrt.png








