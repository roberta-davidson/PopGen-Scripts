## Playing with fEEMS

Copied from https://github.com/NovembreLab/feems with modifications.

Set up in bash terminal:

```
conda create -n=feems_e python=3.8.3 
```
```
conda activate feems_e
```
```
conda install -c conda-forge suitesparse=5.7.2 scikit-sparse=0.4.4 cartopy=0.18.0 jupyter=1.0.0 jupyterlab=2.1.5 sphinx=3.1.2 sphinx_rtd_theme=0.5.0 nbsphinx=0.7.1 sphinx-autodoc-typehints
```
```
pip install git+https://github.com/NovembreLab/feems
```
activate python environment:
```
python
```
Follow tutorial: https://github.com/NovembreLab/feems/blob/main/docsrc/notebooks/getting-started.ipynb
# base
```
import numpy as np
```
```
import pkg_resources
```
```
from sklearn.impute import SimpleImputer
```
```
from pandas_plink import read_plink
```
# viz
```
import matplotlib.pyplot as plt
```
```
import cartopy.crs as ccrs
```
# feems
```
from feems.utils import prepare_graph_inputs
```
```
from feems import SpatialGraph, Viz
```
# change matplotlib fonts
```
plt.rcParams["font.family"] = "Arial"
```
```
plt.rcParams["font.sans-serif"] = "Arial"
```
```
data_path = pkg_resources.resource_filename("feems", "data/")
```
```
