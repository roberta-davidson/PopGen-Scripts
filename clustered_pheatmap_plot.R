library(tidyverse)
library(reshape2)
library(MASS)
library(reshape) 
library(plotly)
library(RColorBrewer)
library(paletteer)
library(pheatmap)

#### plot heatmap of pairwise f3 statistics, using output from a qp3pop script ####

setwd("/path/to/working/directory")
#get data
fn="/Users/robertadavidson/path/AP_20_.R.qp3Pop.out"
f3Pairdat=read.table(fn, col.names = c("Ind1", "Ind2", "OUT","f3","StdErr","Z","SNPs"))
labs=read.table("/Users/robertadavidson/path/labels_2.txt",
                col.names=c("Ind","Type", "Pop"))

#select only f3 and ind colums
f3Pairdat2 <- dplyr::select(f3Pairdat, Ind1,Ind2,f3) 

#cast wide into matrix shape
cast_f3Pairdat <- cast(f3Pairdat2, Ind1~Ind2)
cast_labs <- left_join(cast_f3Pairdat, labs, by=c("Ind1"="Ind"))

#get annotations_df
pos_df <- data.frame("Type" = cast_labs$Type)
rownames(pos_df) = cast_labs$Ind1 # name matching
rownames(cast_f3Pairdat) = cast_f3Pairdat$Ind1 # name matching

#define colours for annotations
colours <- list(Type=c("TW"="blue", "2R"="limegreen", "SG"="grey20", "1240K"="tomato2"))

#plot with clustering tree
pheatmap(as.matrix(cast_f3Pairdat),
         Rowv=as.dendrogram(hclust(dist(t(as.matrix(cast_f3Pairdat))))), #draw row dendrogram
         Colv=as.dendrogram(hclust(dist(t(as.matrix(cast_f3Pairdat))))), #draw column dendrogram
         na_col = "grey", #set NA tile colour
         border_color = "black",  #set border colour
         angle_col = 90, #rotate column labels
         fontsize = 8, #set plot font size
         treeheight_col = 30, treeheight_row = 30, #set height of trees
         cutree_rows = 3, cutree_cols = 3, #split heatmap into blocks by clustering
         cellheight=10, cellwidth=10, #cell size
         legend=TRUE, #draw legend
         display_numbers = F, #toggle writing values inside tiles
         annotation_row = pos_df, annotation_col = pos_df, #colour annotation dataframe labels
         annotation_colors = colours, #annotation colours
         number_color = "black", 
         number_format = "%.4f", #set decimal points
         #scale = "row",
         main = "f3 individual pairwise comparisons: f3 (Mbuti; Ind1,Ind2)") #set plot title