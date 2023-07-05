library(tidyverse)
library(reshape2)
library(MASS)
library(reshape) 
library(plotly)
library(RColorBrewer)
library(paletteer)
library(pheatmap)

setwd("/Users/robertadavidson/Box Sync/Robbi_PhD/TWIST_Tests")
#get data
fn="/Users/robertadavidson/Box Sync/Robbi_PhD/TWIST_Tests/AP_20_.R.qp3Pop.out"
f3Pairdat=read.table(fn, col.names = c("Ind1", "Ind2", "OUT","f3","StdErr","Z","SNPs"))
labs=read.table("/Users/robertadavidson/Box Sync/Robbi_PhD/TWIST_Tests/labels_2.txt",
                col.names=c("Ind","Type", "Pop"))
#select only f3 and ind colums
f3Pairdat2 <- dplyr::select(f3Pairdat, Ind1,Ind2,f3) 

#cast
cast_f3Pairdat <- cast(f3Pairdat2, Ind1~Ind2)
cast_labs <- left_join(cast_f3Pairdat, labs, by=c("Ind1"="Ind"))

#annotations_df
pos_df <- data.frame("Type" = cast_labs$Type)
rownames(pos_df) = cast_labs$Ind1 # name matching
rownames(cast_f3Pairdat) = cast_f3Pairdat$Ind1 # name matching

#define colours for annotations
colours <- list(Type=c("TW"="blue", "2R"="limegreen", "SG"="grey20", "1240K"="tomato2"))

#plot with clustering tree
pheatmap(as.matrix(cast_f3Pairdat),
         Rowv=as.dendrogram(hclust(dist(t(as.matrix(cast_f3Pairdat))))), #draw row dendrogram
         Colv=as.dendrogram(hclust(dist(t(as.matrix(cast_f3Pairdat))))), #draw column dendrogram
         na_col = "grey", #set NA tiles to white
         border_color = "black",  #remove border colour
         angle_col = 90, #rotate column labels
         fontsize = 8, #set plot font size
         treeheight_col = 30, treeheight_row = 30,
       #  cutree_rows = 3,cutree_cols = 3,
         # cellheight=10, cellwidth=10,
         legend=TRUE,
         display_numbers = F,
         annotation_row = pos_df,
         annotation_col = pos_df,
         annotation_colors = colours,
         number_color = "black",
         number_format = "%.4f",
         #scale = "row",
         main = "f3 individual pairwise comparisons: f3 (Mbuti; Ind1,Ind2)") #set plot title
