# I can't remember which of these are actually essential
library(tidyverse)
library(ape)
library(vegan)
library(data.table)
library(ggrepel)
library(ade4)
library(stats)
library(adegenet)
library(phytools)

setwd("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/f3_ind")
df=read.table("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/f3_ind/data31_.R.qp3Pop.out",
              col.names=c("PopA", "PopB", "PopC", "F3", "StdErr", "Z", "SNPs"))

labs=read.table("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/f3_ind/data31_labels.txt",
                col.names=c("Ind","Pop"))

#inverse f3 stat
df <- df %>% mutate(inverse_F3=F3^-1) %>%
    mutate(negF3=1-F3)
    
#extract cols for tree
df_f3 <- select(df,PopA,PopB,inverse_F3)
NN_df_f3 <- filter(df_f3, PopA!="USR1", PopB!="USR1")
#pivot wider
f3_matrix <- pivot_wider(df_f3, names_from=PopA, values_from = inverse_F3, values_fill = 0.00)
f3_matrix <- f3_matrix[, -1]
f3_matrix <- dist(t(as.matrix(f3_matrix)))

#neighbor joining tree 
tree <- nj(f3_matrix)
tree2 <- root(tree, out = "USR1") #root tree
tree2 <- ladderize(tree2) #ladderise

#plot tree
plot(tree2, type="phylo", show.tip = TRUE, edge.width=2, cex=0.8) + #tree
title("Rooted NJ tree") +   #title
tiplabels(tree2$tip.label)

### haven't worked out colouring yet :(

          bg=num2col(tree2$tip.label, col.pal=rainbow(1:length(tree2$tip.label))), 
          fg="transparent")
temp <- pretty(1993:2008, 5)
legend("topright", fill=transp(num2col(temp, col.pal=colours),.7), leg=temp, ncol=2)
