library(tidyverse)
library(reshape2)
library(MASS)
library(reshape) 
library(plotly)
library(RColorBrewer)
library(paletteer)
library(pheatmap)

setwd("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/f3_ind")
#get data
fn="/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/f3_ind/data33_.R.qp3Pop.out"
f3Pairdat=read.table(fn, col.names = c("Ind1", "Ind2", "OUT","f3","StdErr","Z","SNPs")) # I script my f3 runs to write a file with these columns as output

labs=read.table("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/f3_ind/data31_labels.txt",
                col.names=c("Ind","Pop"))

#remove unwanted inds (optional)
f3Pairdat <- filter(f3Pairdat, Ind1!="USR1", Ind2!="USR1") #remove Anzick

#select only f3 and ind colums
f3Pairdat2 <- dplyr::select(f3Pairdat, Ind1,Ind2,f3)

#cast
cast_f3Pairdat <- cast(f3Pairdat2, Ind1~Ind2) #Ind1 = rows, Ind2 = cols

#mke annotations data frame
pos_df <- data.frame("Population" = labs$Pop) #write population column from the labs df
rownames(pos_df) = cast_f3Pairdat$Ind1 # name matching match rownames of new annotations df to the df of f3 data 
rownames(cast_f3Pairdat) = cast_f3Pairdat$Ind1 # name matching

#define colours for annotations
colours <- list(Population=c(Aonikenk="#5BC04B", CentralChile = "darkorange", Chonos="#00D89F", Huash="#7156AC",
              Kaweskar="#FEBF04",MiddleHolocenePatagonia="black",Pampas="deeppink2", Selknam="blue", Yamana="red"))

#plot with clustering tree
pheatmap(as.matrix(cast_f3Pairdat),
         Rowv=as.dendrogram(hclust(dist(t(as.matrix(cast_f3Pairdat))))), #draw row dendrogram
         Colv=as.dendrogram(hclust(dist(t(as.matrix(cast_f3Pairdat))))), #draw column dendrogram
         na_col = "white", #set NA tiles to white
         border_color = "NA",  #remove border colour
         angle_col = 90, #rotate column labels
         fontsize = 9, #set plot font size
         treeheight_col = 70, treeheight_row = 70, #tree size
         cutree_rows = 3, cutree_cols = 3, #how many splits in the heatmap
         cellheight=10, cellwidth=10,
         legend=TRUE,
         display_numbers = FALSE, #write values inside the blocks of the heatmap
         annotation_row = pos_df,
         annotation_col = pos_df,
         number_color = "black",
         number_format = "%.4f", #number of decimal points if writing values
         annotation_colors = colours,
         main = "f3 individual pairwise comparisons: f3 (Mbuti; Ind1,Ind2)") #set plot title
)
