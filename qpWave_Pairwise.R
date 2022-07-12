library(tidyverse)
library(reshape2)
library(MASS)
library(reshape) 
library(RColorBrewer)
library(paletteer)
library(pheatmap)

setwd("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/qpWave")
#get data
fn="/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/qpWave/data18_Peru_summary.qpWave.out"
qpWavedat=read.table(fn, col.names = c("Ind1", "Ind2", "f4rank","Pvalue"))
#cast long
Inds <- qpWavedat$Ind2 %>% sort() %>% unique()
cast_qpWavedat <- cast(qpWavedat, Ind1~Ind2)

#make colour palette
mycolours=colorRampPalette(c("#E2E2E2","#D6D78E","#D2B237","#BF4B0C","#7A2202","#3C1300"))

#plot with clustering tree
plot2 <- pheatmap(as.matrix(cast_qpWavedat), col = mycolours(6),#plot heatmap with custom colour ramp
                  Rowv=as.dendrogram(hclust(dist(t(as.matrix(cast_qpWavedat))))), #draw row dendrogram
                  Colv=as.dendrogram(hclust(dist(t(as.matrix(cast_qpWavedat))))), #draw column dendrogram
                  breaks=c(0, 0.01,0.05,0.1,0.4,0.7,1.0), # set breaks in colour palette
                  na_col = "white", #set NA tiles to white
                  border_color = NA,  #remove border colour
                  angle_col = 90, #rotate column labels
                  fontsize = 8, #set plot font size
                  treeheight_col = 30,
                  treeheight_row = 30,
                  #cellheight=15, cellwidth=15,
                  legend=TRUE,
                  display_numbers = FALSE,
                  number_color = "white",
                  legend_breaks=c(0, 0.01,0.05,0.1,0.4,0.7,1.0), #set legend break labels to match colours
                  main = "qpWave individual pairwise comparisons") #set plot title
                  filename = "qpWave.pdf"
)
