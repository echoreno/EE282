#!/usr/bin/env RScript

setwd("~/1. UCI/1. D Fall 2022/1. Informatics/2. Project/Final")

install.packages("metafor")
install.packages("ggplot2")
library(metafor)
library(ggplot2)

#Reading the data

table<-read.csv("metaanalysis.csv",header=T)

#trt: mean of decomposition in treatment
#ctrl: mean of decomposition in control
#sdt: standard deviation in treatment
#sdc: standard deviation in control
#ntrt: replicate number in treatment
#nctrl: replicate number in control

tecm<-table[1:47,]   #Subsetting data for ECM
tamf<-table[48:94,]  #Subsetting data for AMF
ttot<-table[,]       #Subsetting entire table (ECM+AMF)


### ECM META-ANALYSIS ###

#Obtaining effect size as logRoM (ROM) using means, SD and replicate number

eecm<-escalc(measure="ROM", m1i=trt, m2i=ctrl, sd1i=sdt, sd2i=sdc, n1i=ntrt, n2i=nctrl, data=tecm)

#Obtaining random effects model using effect size (yi) and variance (vi)

recm <- rma(yi, vi, data=eecm,slab=paste(author)) 

#returning to original units to obtain % of change in decomposition

predict(recm, transf=exp, digits=3) 


### AMF META-ANALYSIS ###

#Obtaining effect size as logRoM (ROM) using means, SD and replicate number

eamf<-escalc(measure="ROM", m1i=trt, m2i=ctrl, sd1i=sdt, sd2i=sdc, n1i=ntrt, n2i=nctrl, data=tamf)

#Obtaining random effects model using effect size (yi) and variance (vi)

ramf <- rma(yi, vi, data=eamf,slab=paste(author)) #Random effects model with effect size and variance

#returning to original units to obtain % of change in decomposition

predict(ramf, transf=exp, digits=3) 


### ECM+AMF META-ANALYSIS ###

#Obtaining effect size as logRoM (ROM) using means, SD and replicate number

etot<-escalc(measure="ROM", m1i=trt, m2i=ctrl, sd1i=sdt, sd2i=sdc, n1i=ntrt, n2i=nctrl, data=ttot)

#Obtaining random effects model using effect size (yi) and variance (vi)

rtot <- rma(yi, vi, data=etot,slab=paste(author)) #Random effects model with effect size and variance

#returning to original units to obtain % of change in decomposition

predict(rtot, transf=exp, digits=3) #return to original units with CI


### COMPARING EFFECT SIZES BETWEEN ECM VS AMF ####

#It calculates effect sizes as those obtained individually per guild with rma, and compare
#the distance between them.It uses the effect sizes from etot.

comp<-rma.mv(yi, vi, mods = ~ guild, random = ~ guild | id, struct="DIAG",
              slab=paste(author), data=etot, digits=3)


### PLOTTING EFFECT SIZES BY GUILD ###

#Obtaining model that predicts the same effect sizes per guild as those obtained with rma
#but with the effect sizes obtained in etot

comp2<-rma.mv(yi, vi, mods = ~ guild-1, random = ~ guild | id, struct="DIAG",
               slab=paste(author), data=etot, digits=3)

# to plot I use the results of the model obtained for ECM+AMF (rtot) and comp2

summary(comp2)
summary(rtot)

#getting effect size
y<-summary(comp2)$b
y2<-summary(rtot)$b

#getting confidence intervals
ci_l<-summary(comp2)$ci.lb
ci_h<-summary(comp2)$ci.ub
ci_l2<-summary(rtot)$ci.lb
ci_h2<-summary(rtot)$ci.ub

y<-append(y,y2)
ci_l<-append(ci_l,ci_l2)
ci_h<-append(ci_h,ci_h2)

#Creating data frame
fg<-data.frame(cbind(y,ci_l,ci_h))
colnames(fg)[1]<-"log Ratio of Means"
colnames(fg)[2]<-"ci_l"
colnames(fg)[3]<-"ci_h"
fg$Guild<-c("AMF","ECM","ECM+AMF")
fg$Guild<-as.factor(fg$Guild)

#Plotting
effect<-ggplot(fg,aes(y=Guild,x=y))+
  geom_point(size=4, shape=19) +
  geom_errorbarh(aes(xmin=ci_l, xmax=ci_h), height=.1, cex = 1) +
  coord_fixed(ratio=0.1) +
  geom_vline(xintercept=0, linetype='longdash')+
  xlab("Log Ratio of Means ")+
  theme(axis.text.y  = element_text(face="bold"),
        axis.text.x  = element_text(face="bold"),
        axis.title   = element_text(size=12,face="bold"))

png(filename = "effect.png")
plot(effect)
dev.off()


