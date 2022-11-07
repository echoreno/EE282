#!/usr/bin/env bash

srun -A class-ee282 --pty --x11 bash -i
conda activate ee282


# Download the database  

wget http://ftp.flybase.net/releases/FB2022_05/dmel_r6.48/fasta/dmel-all-chromosome-r6.48.fasta.gz


# Verify file integrity 

shasum  dmel-all-chromosome-r6.48.fasta.gz > all_chrom.txt
shasum  -c all_chrom.txt
 

# Summarize annotation file  

faSize dmel-all-chromosome-r6.48.fasta.gz > dmel-all-chromosome-r6.48.fasta.gz.txt
less dmel-all-chromosome-r6.48.fasta.gz.txt



