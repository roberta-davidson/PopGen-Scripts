library(rlang)
library(admixtools)
library(tidyverse)
library(data.table)
library(ggplot2)
library(plotly)

setwd("/Users/robertadavidson/Library/CloudStorage/Box-Box/Robbi_PhD/05_Chonos/qpGraph")

##Compute f2-blocks
prefix = '/Users/robertadavidson/Library/CloudStorage/Box-Box/Robbi_PhD/05_Chonos/qpGraph/Nathan_4' #eigenstrat fleset prefix
my_f2_dir = '/Users/robertadavidson/Library/CloudStorage/Box-Box/Robbi_PhD/05_Chonos/qpGraph/f2blocks'

extract_f2(prefix, my_f2_dir, overwrite = T)

##Constrints the number of admixture for selected population
constraint = tribble(~pop, ~min, ~max,
                          'Mbuti', 0, 0,
                          'USA_Ancient_Beringian_USR1.SG',0,0,
                          'Argentina_LagunaToro_2400BP',0,3,
                          'Argentina_NorthTierradelFuego_LaArcillosa2_5800BP',0,3,
                          'Chile_PuntaSantaAna_7300BP.SG',0,3,
                          'Chile_Conchali_700BP',0,3,
                          'Chile_WesternArchipelago_Ayayema_5100BP.SG',0,3,
                          )
#Constraints the order of populations
constrainte = tribble(
  ~earlier1, ~earlier2, ~later1, ~later2,
  'Mbuti','USA_Ancient_Beringian_USR1.SG','Chile_WesternArchipelago_Ayayema_5100BP.SG','Chile_Conchali_700BP')


##Get f2 from precomputed f2 folder
#Compute f2 use function extract extract_f2() and store in designated folder
f2wlc13 = f2_from_precomp("f2blocks", pops = c("Mbuti","USA_Ancient_Beringian_USR1.SG","Argentina_LagunaToro_2400BP",
                    "Argentina_NorthTierradelFuego_LaArcillosa2_5800BP","Chile_PuntaSantaAna_7300BP.SG","Chile_Conchali_700BP",
                     "Chile_WesternArchipelago_Ayayema_5100BP.SG"))

##Build graph manually and use it as initial graph on find graph
Nakatuka =  matrix(c('Root','n1',
                       'Root','Mbuti',
                       'n1','n2',
                       'n2','n3',
                       'n2','USA_Ancient_Beringian_USR1.SG',
                       'n3','n4',
                       'n4','Argentina_LagunaToro_2400BP',
                       'n3','n5',
                       'n5','Chile_Conchali_700BP',
                       'n4','n7',
                       'n7','n8',
                       'n8','Chile_WesternArchipelago_Ayayema_5100BP.SG',
                       'n7','n10',
                       'n10','n11',
                       'n10','Argentina_NorthTierradelFuego_LaArcillosa2_5800BP',
                       'n11','n11a',
                       'n11a','Chile_PuntaSantaAna_7300BP.SG'
),,2, byrow = T) %>% edges_to_igraph()
Nakatuka %>% plotly_graph


#Check manual graph
is_valid(Nakatuka)
satisfies_constraints(graph=Nakatuka,event_order = constrainte)
satisfies_constraints(graph=Nakatuka,admix_constraints = constraint)

qpg_results = qpgraph(f2wlc13,Nakatuka)
qpg_results$score
plot_graph(qpg_results$edges)
plotly_graph(qpg_results$edges)

#find_graphs using initial graph
#the number of admixture is set based on initial find_graphs
fgwlc13 = find_graphs(f2wlc13, initgraph = Nakatuka, admix_constraints = constraint,
                      event_constraints = constrainte,reject_f4z = 1, stop_gen = 100, stop_gen2 = 10)
#look at scores,highlight 5 best
scores <- ggplot(fgwlc13, aes(y=score, x=generation)) + geom_point(size = 3, alpha = 0.6, color = ifelse(rank(fgwlc13$score) <= 5, "red", "blue")) + theme_light()
scores
# take 5 graphs with best score
fgwlc13_fit = fgwlc13 %>% slice_min(score, n = 5) 
graph_score <- 1
satisfies_constraints(graph=fgwlc13_fit$graph[[graph_score]],event_order = constrainte)
satisfies_constraints(graph=fgwlc13_fit$graph[[graph_score]],admix_constraints = constraint)

#Run qpgraph considering f4 based on the best graph
fgwlc_gr13 = qpgraph(f2wlc13, fgwlc13_fit$graph[[graph_score]], return_fstats = TRUE)
fgwlc_gr13$score
fgwlc_gr13$worst_residual

#Draw graph and highlight unidentifiable branch or node
wlc13=fgwlc_gr13$edges %>% plotly_graph(highlight_unidentifiable = T)
wlc13
#Draw a table for f3 residual
wlc13f3=as.data.table(fgwlc_gr13$f3)
wlc13f3[, Sig:=""]
wlc13f3[abs(z)>=2, Sig:="*"]
wlc13f3[abs(z)>=3, Sig:="**"]

wlc13f3[, pop2:=factor(pop2, levels=wlc13f3[, .N, by=pop2][order(N), pop2])]
wlc13f3[, pop3:=factor(pop3, levels=wlc13f3[, .N, by=pop3][order(N), pop3])]
wlc13_residual <- ggplot(wlc13f3, aes(x=pop2, y=pop3, fill=z)) +
  geom_tile(color="black", size=0.25) +
  geom_text(aes(label=Sig, size=2), show.legend=F) +
  scale_fill_gradient2(high = "red", mid = "white", low = "blue") +
  labs(fill="Residual (Z)") +
  theme_bw() +
  theme(axis.title=element_blank(),axis.text.x=element_text(hjust=1, angle=45),
        legend.position=c(0.125, 0.25), legend.background=element_rect(color="black", size=0.5))
wlc13_residual



ggsave(plot = wlc13_residual, filename = "Nakatsuka_base_1_residual.pdf")
ggsave(plot = scores, filename = "Nakatsuka_base_1_scores.pdf")
ggsave(plot = wlc13, filename = "Nakatsuka_base_1.pdf")
