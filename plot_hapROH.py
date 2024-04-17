import os as os
import pandas as pd
import sys
import matplotlib.pyplot as plt # added by me to close plots


### Fill in your own path here!
path = "./"  # The Path to Package Midway Cluster
os.chdir(path)  # Set the right Path (in line with Atom default)
print(f"Set path to: {os.getcwd()}") # Show the current working directory. 
#prefix of your data
data = "SouthCone11"

#### Plot the Posterior along one Chromosome. 
from hapsburg.figures.plot_posterior import plot_posterior_cm

iids = ['ALOW1', 'CY5_1', 'CY5_4', 'IPUN1', 'IYA1', 'IYA4', 'IYA5', 'IYA6', 'MEL1', 'MEL2', 'MEL4', 'Yaghan894.SG', 'Yaghan895.SG', 'MA577.SG', 'AM74.SG', 'I0309', 'I0308', 'I2230', 'I2537', 'I2540', 'I1752', 'I1753', 'I1754', 'CP18', 'CP19', 'CP23', 'CP25', 'CP21_published', 'CP22_published', 'I8575', 'I8576', 'I8351', 'LAR001', 'IPK12.SG', 'PK13a.SG', 'IPY08b.SG', 'I12366', 'I12357', 'I12355', 'I12363', 'I12941', 'I12943', 'I12356', 'SA5832.SG', 'A460.SG', 'Aconcagua.SG', 'Sumidouro4.SG', 'Sumidouro5.SG', 'Sumidouro6.SG', 'I11974.SG', 'IO2', 'MIS3', 'MIS5', 'MIS7', 'I12362', 'I12354', 'I12358', 'IPY10.SG']
chrs = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22"]

## 1.1) Plot summary over multiple Individuals
print("Plotting summary")
from hapsburg.figures.plot_bars import plot_legend_only, plot_panel_row, prepare_dfs_plot
plot_legend_only(savepath="./plots/summary_legend.pdf", figsize=(4,3.5))
df1 = pd.read_csv(f"./{data}_combined_roh05.csv", sep='\t')
plot_dfs, cols = prepare_dfs_plot(df1, cms=[4, 8, 12, 20])
plot_panel_row(plot_dfs, wspace=0.1, r_title=30, leg_pos=-7,
               ylim=[0,300], figsize=(16,5),
               savepath="./plots/summary.png",
              # savepath="./plots/summary.pdf"
              )
