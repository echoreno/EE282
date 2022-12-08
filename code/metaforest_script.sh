#!/usr/bin/env RScript

setwd("~/1. UCI/1. D Fall 2022/1. Informatics/2. Project/Final")

install.packages("metaforest")
install.packages("ggplot2")
install.packages("gridExtra")

library(metaforest)
library(ggplot2)
library(gridExtra)

table<-read.csv("metaforest.csv",header=T)   #It contains the effect size and variance (vi) 
                                             #obtained with metafor, as well as moderators.
table<-na.omit(table)                        #table w/o NAs,   N=47


### METAFOREST ###

#Running model to select number of trees necessary (when the model converges)

conv <- MetaForest(LogRoM~Guild+Condition+Unit+Biome+CN+Air.Temperature+Time+Abs.Latitude,
                   data = table,study = "id_exp",
                   whichweights = "random",
                   num.trees = 20000)

plot(conv)        #Convergence plot

#Running model with 15000 trees and all the moderators

model <- MetaForest(LogRoM~Guild+Condition+Unit+Biome+CN+Air.Temperature+Time+Abs.Latitude, data = table,
                    study = "id_exp",
                    whichweights = "random",
                    num.trees = 15000)

summary(model)        #summary of the model
VarImpPlot(model)     #Plotting importance of the moderators

# Running recursive preselection, and storing results in object "preselect"

preselected <- preselect(model, replications = 100, algorithm = "recursive")
plot(preselected)

# Retaining only moderators with positive variable importance in more than 50% of replications

preselect_vars(preselected, cutoff = .5)

# Running the MAIN MODEL with only Guild, C:N and Abs. latitude

modelfinal <- MetaForest(LogRoM~Guild+CN+Abs.Latitude, data = table,
                         study = "id_exp",
                         whichweights = "random",
                         num.trees = 15000)

summary(modelfinal)
plot(modelfinal)                        #Convergence plot for the main model
importance <- VarImpPlot(modelfinal)    #Plotting importance of the moderators in the main model
png(filename = "importance.png")
plot(importance)
dev.off()



### PARTIAL DEPENDENCE PLOTS ###

# I generated three types of plots: 
# A) LogRoM as a function of Abs. Latitude or C:N ratio
# B) LogRoM as a function of Abs. Latitude or C:N ratio, but divided by guild
# C) Heatmap with LogRoM as function of both Abs. Latitude and C:N ratio or Abs. Latitude and guild
# I finally placed the 6 plots in the same grid

# Sort the variables by importance, so that the partial dependence plots are ranked by importance

ordered_vars <- names(modelfinal$forest$variable.importance)[
  order(modelfinal$forest$variable.importance, decreasing = TRUE)]

# A) Partial dependence plots with LogRoM and moderators (a plot per moderator)

pdtot <- PartialDependence(modelfinal, vars = ordered_vars,
                           rawdata = TRUE, pi = .95,bw=T,output="list")

print(pdtot[[1]])                # LogRoM ~ Abs. Latitude
pdtot1<-pdtot[[1]] + 
  labs(y="Log Ratio of Means")

print(pdtot[[2]])                # LogRoM ~ C:N 
pdtot2<-pdtot[[2]] + 
  labs(y="Log Ratio of Means")

# B) Partial dependence plots per guild

pdtotguild <-PartialDependence(modelfinal, vars = ordered_vars,moderator="Guild",
                               rawdata = TRUE, pi = .95,bw=T, output="list")

print(pdtotguild[[1]])              # LogRoM ~ Abs. Latitude by guild
pdtotguild1<-pdtotguild[[1]] + 
  labs(y="Log Ratio of Means")+
  theme(legend.position = c(1,0.35),
        legend.background = element_rect(fill = "transparent"))

print(pdtotguild[[2]])              # LogRoM ~ C:N by guild
pdtotguild2<-pdtotguild[[2]] + 
  labs(y="Log Ratio of Means")+
  theme(legend.position = c(1,0.35),
        legend.background = element_rect(fill = "transparent"))

# C) Partial dependence plots as heatmaps

pdtotheat <-PartialDependence(modelfinal, vars = ordered_vars,moderator="Abs.Latitude",
                             rawdata = TRUE, pi = .95,bw=T, output="list")

pdtotheat                               #LogRoM ~ Abs. Latitude + C:N
print(pdtotheat[[1]])
pdtotheat1<-pdtotheat[[1]] + 
  labs(y="Absolute Latitude")+
  theme(legend.position = "right")

print(pdtotheat[[2]])                   #LogRoM ~ Abs. Latitude + Guild
pdtotheat2<-pdtotheat[[2]] + 
  labs(y="Absolute Latitude")+
  theme(legend.position = "right")


# Combining all the plots

###### @ pd 1000X600 ######
pdfinal<-grid.arrange(pdtot1,pdtot2,pdtotguild1,pdtotguild2,
                  pdtotheat1,pdtotheat2, nrow=3,
                  widths = c(1,1,1),
                  layout_matrix = rbind(c(1,2,5),
                                        c(3,4,6)))

png(filename = "PDplots.png", width = 1000, height = 600)
plot(pdfinal)
dev.off()

