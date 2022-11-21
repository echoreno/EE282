#!/usr/bin/env bash

srun -A class-ee282 --pty --x11 bash -i
conda activate ee282


## Download data base as .gz and .txt 

wget http://ftp.flybase.net/releases/FB2022_05/dmel_r6.48/gtf/dmel-all-r6.48.gtf.gz

deml="http://ftp.flybase.net/releases/FB2022_05/dmel_r6.48/gtf/dmel-all-r6.48.gtf.gz"
wget -O - -q $deml \
| gunzip \
> flygtf.txt


## Verify file integrity 


$shasum dmel-all-r6.48.gtf.gz > dmel.gtf.gz.txt
$shasum -c dmel.gtf.gz.txt


## Total number of features of each type  

bioawk -c gff '{print $3}' flygtf.txt > flybioawk.txt 
sort flybioawk.txt \
| uniq -c \
| sort -k1,1rn \
> flysorted.txt
less flysorted.txt


## Total number of genes per chromosome arm (X, Y, 2L, 2R, 3L, 3R, 4) 

bioawk -c gff '{print $1 "\t" $3 }' flygtf.txt \
|sort -k2,2rn \
|grep -w "gene" \
|uniq -c \
> geneschrom.txt

