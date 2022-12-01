# HOMEWORK 4

Notes on the scripts:
1. Most of the activities were made using bash (_hw4_genome_summary.sh_ and _hw4_annotation_summary.sh_)
2. Only the plots #1 and #2 when were done with RStudio (_hw4_plots.sh) when summarizing partitions  

# A) SUMMARIZING PARTITIONS

Files with ≤ 100kb are named as _lt_ and > 100kb as _gt_.  
I made the partitions using faFilter, obtaining the files _lt.fa.gz_ and _gt.fa.gz_.  
To summarize the partitions I used faSize and obtained the next results:

## Answer for ≤ 100kb (_lt.fa.txt_ file):

1. Total number of nucleotides: 6178042 
2. Total number of Ns: 662593
3. Total number of sequences: 1863

## Answer for > 100kb (_gt.fa.txt_ file)

1. Total number of nucleotides: 137547960  
2. Total number of Ns: 490358
3. Total number of sequences: 7

# PLOTTING PARTITIONS

I obtained the files _lt.lgc.txt_ and _gt.lgcn.txt_ using bioawk and the _fa.gz_ files from each partition.  
Those _.txt_ files were exported and used in RStudio to get the plots #1 and #2 for each partition.
Then, the _.txt_ files were sorted and the resulting _lgcnsrt.txt_ files were used together with plotCDF  
to obtain the plot #3.  

## ≤ 100kb (lt)

1. Sequence length distribution.
![ltlength](/myrepos/ee282/ltlgthplot.png)

2. Sequence GC% distribution.
![ltcn](/myrepos/ee282/ltgcplot.png)

3. Cumulative sorted
![ltsorted](/myrepos/ee282/lt.lgsrt.png)

## > 100kb (gt)

1. Sequence length distribution.
![gtlength](/myrepos/ee282/gtlgthplot.png)

2. Sequence GC% distribution.
![gtcn](/myrepos/ee282/gtgcplot.png)

3. Cumulative sorted
![gtsorted](/data/homezvol2/echoreno/myrepos/ee282/gt.lgsrt.png)
