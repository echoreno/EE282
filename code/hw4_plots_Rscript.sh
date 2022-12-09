#!/usr/bin/env RScript

setwd("C:/Users/chore/OneDrive/DOCUME~1/1. UCI/1. D Fall 2022/1. Informatics/1. Homeworks/hw4")

install.packages("ggplot2")
library(ggplot2)


#read data exported from bash

lt <- read.table("lt.lgcn.txt", header=F) #table with <= 100kb
gt <- read.table("gt.lgcn.txt", header=F) #table with > 100kb (gt)
colnames(lt)<-c("length","gc","name")
colnames(gt)<-c("length","gc","name")


# <= 100kb (lt) histograms

## 1. Sequence length distribution 

ltlgthplot <- ggplot(lt, aes(x=log(length))) + geom_histogram(bins=100)+
  labs(x="ln(Length of sequence)",y="Frequency of sequences")

png(filename = "ltlgthplot.png")
plot(ltlgthplot)
dev.off()

## 2. Sequence GC% distribution

ltgcplot <- ggplot(lt, aes(x=gc)) + geom_histogram(bins=50)+
  labs(x="GC content (%)",y="Frequency of sequences")

png(filename = "ltgcplot.png")
plot(ltgcplot)
dev.off()



## > 100kb (gt) histograms

## 1. Sequence length distribution 

gtlgthplot <- ggplot(gt, aes(x=length)) + geom_histogram()+
  labs(x="Length of sequence",y="Frequency of sequences")

png(filename = "gtlgthplot.png")
plot(gtlgthplot)
dev.off()

## 2. Sequence GC% distribution

gtgcplot <- ggplot(gt, aes(x=gc)) + geom_histogram(bins=50)+
  labs(x="GC content (%)",y="Frequency of sequences")

png(filename = "gtgcplot.png")
plot(gtgcplot)
dev.off()

