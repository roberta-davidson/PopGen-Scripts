library(tidyverse)

setwd("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/qp3Pop")

f3dat = read.table("/Users/robertadavidson/Box Sync/Robbi_PhD/05_Chonos/qp3Pop/all.qp3Pop.out",
                   col.names=c("PopA", "PopB", "PopC", "F3", "StdErr", "Z", "SNPs"))

#Subset data to plot regarding pop or ind of interest
s <- f3dat[f3dat$PopB == "Chonos",]

#order s by F3
sOrdered <- arrange(s,F3)

#set pop order as factor so ggplot won't re-order automatically
sOrdered$PopA <- factor(sOrdered$PopA, levels = sOrdered$PopA)

# ggplot
plot <- ggplot(data = sOrdered) + 
  geom_point(aes(x=F3, y=PopA, color=F3), #plot F3 points
             size = 3) + #set point size
  geom_errorbar(aes(y=PopA, xmin=F3-StdErr, xmax=F3+StdErr, #plot error bars
                    color=F3, #colour by F3
                    width=0.4)) + # change whisker length
  theme_light() + #set theme
  ggtitle("") + #set plot title
  labs(x = "F3(Mbuti; Chonos, X)", #edit x-axis label
       y = "")
plot
ggsave('Chonos_data18_f3.pdf', dpi=300)
