library(tidyverse)
library(data.table)
library(ggrepel)

#### MDS plot ####
#extract cols for plot
MDS_f3 <- select(df,PopA,PopB,negF3)
MDS_f3 <- filter(MDS_f3, PopA!="USR1", PopB!="USR1")

#pivot wide
MDS <- pivot_wider(MDS_f3, names_from=PopA, values_from = negF3, values_fill = 0.0000)
#remove sample names column
MDS_matrix <- MDS[, -1]
#format as matrix
MDS_matrix <- dist(t(as.matrix(MDS_matrix)))

# caluculate MDS
mds1 <- cmdscale(MDS_matrix, k=2, eig=TRUE)

#set output as dataframe
mds_n <- as.data.frame(mds1[["points"]])
setDT(mds_n, keep.rownames = TRUE)

#merge with pop labels
mds_labs <- cbind(mds_n, labs)

#make colour palette to match paper
colours <- c("green","lightgrey","turquoise","purple","orange","pink","blue","red")

#plot
ggplot(mds_labs, aes(x=V1, y=-V2, color = mds_labs$Pop)) +
  geom_point(size=2) +
  theme_light() +
  scale_color_manual(values = c("forestgreen","rosybrown1","turquoise","purple","orange","black","hotpink","blue","red")) + 
  geom_text_repel(data = mds_n, aes(label=rn),
                   segment.size  = 0.1, segment.color = "grey50") +
  theme(panel.grid.major = element_blank(), #remove major gridline
      panel.grid.minor = element_blank(),
      axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      panel.background=element_blank(),
      panel.border=element_blank(),
      plot.background=element_blank(),
      legend.position = "right") + 
  geom_hline(yintercept = 0, color = "black", alpha=0.5, size=0.5) +
  geom_vline(xintercept = 0, color = "black", alpha=0.5, size=0.5) +
  labs(x="Dimension 1", y= "Dimension 2", color="Population", 
       title = "Multidimensional Scaling Plot of 1-f3(Mbuti; Ind1, Ind2).")
