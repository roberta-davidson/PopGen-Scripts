library(tidyverse)

### Bar plot of population level f3 statistics ###

setwd("/path/qp3Pop")

#read in data
f3dat = read.table("/path/data25_Africa_CUO_Shotgun.R.qp3Pop.out",
                   col.names=c("PopA", "PopB", "PopC", "F3", "StdErr", "Z", "SNPs"))

#Subset data to plot regarding pop or ind of interest
s <- f3dat[f3dat$PopB == "Shotgun",] 

#order data frame by F3
sOrdered <- arrange(s,F3)

#set pop order as factor so ggplot won't re-order automatically
sOrdered$PopA <- factor(sOrdered$PopA, levels = sOrdered$PopA) 

# ggplot
plot <- ggplot(data = sOrdered) + 
  geom_point(aes(x=F3, y=PopA, colour = Z), #plot F3 points
             size = 3) + #set point size
  geom_errorbar(aes(y=PopA, xmin=F3-StdErr, xmax=F3+StdErr, #plot error bars
                    color=Z, #colour by F3
                    width=0.4)) + # change whisker length
  theme_light() + #set theme
  theme(plot.title = element_text(hjust = 0.5))+
  labs(x = "f3(Africa; Shotgun, X)", #edit x-axis label
       y = "", title = "On Target - f3(Africa; Shotgun, X) - with number of SNPs per tree") + 
  geom_text(aes(x=F3, y=PopA, label=SNPs, hjust=0.5, vjust=-0.6))
plot
ggsave('Shotgun_data25_f3.pdf', dpi=300)