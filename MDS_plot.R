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
              col.names=c("IndA", "IndB", "PopC", "F3", "StdErr", "Z", "SNPs"))

labs=read.table("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/f3_ind/data31_labels.txt",
                col.names=c("Ind","Pop"))

#inverse f3 stat
df <- df %>% mutate(inverse_F3=F3^-1) %>%
    mutate(negF3=1-F3)

#### MDS plot ####
#extract cols for plot
MDS_f3 <- select(df,IndA,IndB,negF3)
MDS_f3 <- filter(MDS_f3, IndA!="USR1", IndB!="USR1") #remove Anzick
MDS_f3 <- filter(MDS_f3, IndA!="USR1", IndB!="USR1") #remove Anzick

#add pop labels to each individual
MDS_f3 <- full_join(MDS_f3,labs, by=c("IndA"="Ind"))
MDS_f3 <- full_join(MDS_f3,labs, by=c("IndB"="Ind"), suffix=c("A","B"))

#reomve pairs within same population (OPTIONAL!!)
MDS_f3 <- filter(MDS_f3, PopA!=PopB!)

#remove pop names again before pivoting
MDS_f3 <- select(MDS_f3,IndA,IndB,negF3)

#pivot wide
MDS <- pivot_wider(MDS_f3, names_from=IndA, values_from = negF3, values_fill = 0.000000)

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
mds_labs <- full_join(mds_n,labs, by=c("rn"="Ind"))

#plot
ggplot(mds_labs, aes(x=V1, y=-V2,  fill = mds_labs$Pop)) +
  geom_point(size=4, shape=21) +
  ggalt::geom_encircle(size=0, color=mds_labs$Pop, alpha=0.2)+
  theme_light() +
  scale_fill_manual(values = c("#5BC04B","#B59190","#00D89F","#7156AC","#FEBF04","black","#DA3487","#195FFF","red")) + 
  scale_color_manual(values = c("#5BC04B","#B59190","#00D89F","#7156AC","#FEBF04","black","#DA3487","#195FFF","red")) +
  geom_text_repel(data = mds_labs, aes(label=rn), segment.size  = 0.1, segment.color = "grey50") +
  theme(panel.grid.major = element_blank(), #remove major gridline
      panel.grid.minor = element_blank(),
      axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      panel.background=element_blank(),
      panel.border=element_blank(),
      plot.background=element_blank(),
      legend.position = "right",
      legend.key.size = unit(1, 'cm'), #change legend key size
      legend.key.height = unit(1, 'cm'), #change legend key height
      legend.key.width = unit(1, 'cm'), #change legend key width
      legend.title = element_text(size=14), #change legend title font size
      legend.text = element_text(size=14),
      axis.title = element_text(size = 12)) + #change legend text font size
  geom_hline(yintercept = 0, color = "black", alpha=0.5, size=0.5) +
  geom_vline(xintercept = 0, color = "black", alpha=0.5, size=0.5) +
 # scale_y_continuous(limits=c(-0.2,0.3)) +
#  scale_x_continuous(limits=c(-0.4,0.3)) +
  labs(x="Dimension 1", y= "Dimension 2", color="Population", fill="Population",
       title = "Multidimensional Scaling Plot of 1-f3(Mbuti; Ind1, Ind2).")
ggplotly(plot)
