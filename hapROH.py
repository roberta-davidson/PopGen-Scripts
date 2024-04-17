import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os as os
import sys as sys
import multiprocessing as mp

print(f"CPU Count: {mp.cpu_count()}")

path = "//"
data = "SouthCone11"
os.chdir(path)
print(f"Set path to: {os.getcwd()}")

from hapsburg.PackagesSupport.hapsburg_run import hapsb_ind  # Need this import

#Run multiple Individuals¶
iids = ['Sample1', 'Sample2']

### Postprocess Results into one results.csv                  
from hapsburg.PackagesSupport.pp_individual_roh_csvs import pp_individual_roh
#%%time
## Postprocess the two Individuals from above and combine into one results .csv
df1 = pp_individual_roh(iids, meta_path=f"/hpcfs/users/a1717363/05_Chonos/hapROH/{data}_meta_blank.csv",
                        base_folder="/hpcfs/users/a1717363/05_Chonos/hapROH/",
                        save_path=f"/hpcfs/users/a1717363/05_Chonos/hapROH/{data}_combined_roh05.csv",
                        output=False, min_cm=[4, 8, 12, 20], snp_cm=50,
                        gap=0.5, min_len1=2.0, min_len2=4.0)
