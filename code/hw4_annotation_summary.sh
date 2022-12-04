#!/usr/bin/env bash

# ASSEMBLING GENOME

srun -c32 -A class-ee282 --pty --x11 bash -i
conda activate ee282
cd ~/myrepos/ee282

# Assembling a genome

conda install -y miniasm minimap

# 1. Dowloading the reads

cp /pub/jje/ee282/iso1_onp_a2_1kb.fastq /data/homezvol2/echoreno/myrepos/ee282/
ln -sf iso1_onp_a2_1kb.fastq reads.fq

# 2. Overlaping reads with minimap 

minimap -t 32 -Sw5 -L100 -m0 reads.fq{,} \
| gzip -1 > onp.paf.gz

# 3. Constructing an assembly

miniasm -f reads.fq onp.paf.gz > reads.gfa

# Assembly assesment
 
srun -A class-ee282 --pty --x11 bash -i
conda activate ee282
cd ~/myrepos/ee282

# 1. Calculating the N50 for the assembly (reads.gfa).

awk ' $0 ~/^S/ { print ">" $2" \n" $3 } ' reads.gfa \
> assembly.gfa
  
bioawk -c fastx ' { print length($seq)} ' assembly.gfa \
| sort -rn \
| gawk ' { tot=tot+$1; print $1 "\t" tot } END { print tot } ' \
| sort -k1,1rn \
| gawk ' NR == 1 { tot = $1 } NR > 1 && $2/tot >= 0.5 { print $1 } ' \
| head -1 \
> n50.txt

fold -w 60 assembly.gfa > unitigs.fa

# 2. Comparing assembly to both the contig assembly and the scaffold assembly from the Drosophila melanogaster 

## Using plot CDF 

bioawk -c fastx '{ print length($seq) }' unitigs.fa \
| sort -rn \
> unitigs.sizes.txt

faSplitByN dmel-all-chromosome-r6.48.fasta.gz contig-dmel.fasta.gz 10 

bioawk -c fastx ' { print length($seq) } ' contig-dmel.fasta.gz \
| sort -rn \
>  contig.sizes.txt

bioawk -c fastx ' { print length($seq) } ' dmel-all-chromosome-r6.48.fasta.gz \
| sort -rn \
>  scaffold.sizes.txt

plotCDF *.sizes.txt CDF.png

## Using plot CDF2 

cp /pub/jje/ee282/bin/plotCDF2 /data/homezvol2/echoreno/bin/

bioawk -c fastx '{ print length($seq) }' unitigs.fa \
| sort -rn \
| awk ' BEGIN { print "Assembly\tLength\nassembly\t0" } { print "assembly\t" $1 } ' \
> unitigs.sizes

bioawk -c fastx ' { print length($seq) } ' contig-dmel.fasta.gz \
| sort -rn \
| awk ' BEGIN { print "Assembly\tLength\ncontig\t0" } { print "contig\t" $1 } ' \
>  contig.sizes

bioawk -c fastx ' { print length($seq) } ' dmel-all-chromosome-r6.48.fasta.gz \
| sort -rn \
| awk ' BEGIN { print "Assembly\tLength\nscaffold\t0" } { print "scaffold\t" $1 } ' \
>  scaffold.sizes

plotCDF2 *.sizes CDF2.png

# 3. Calculating BUSCO scores

conda install busco

busco --list-datasets | less

gunzip dmel-all-chromosome-r6.48.fasta.gz

srun -c32 -A class-ee282 --pty --x11 bash -i
conda activate ee282
cd ~/myrepos/ee282

### For the assembly (using unitig.fa)

busco -c 32 -i unitigs.fa -l diptera_odb10 -o unitigs_busco -m genome
   
### For D. melanogaster (using dmel-all-chromosome-r6.48.fasta)

busco -c 32 -i dmel-all-chromosome-r6.48.fasta -l diptera_odb10 -o dmel_busco -m genome



