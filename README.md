# 3DBC
An implementation of "A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate", Mehrotra and Sharma (2019), Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270 in R

The method is refered to as 3DBC (3-dimensional bias-correction), as it keeps inter-variable, temporal and spatial consistencies from the reference data set.

It is basically a smart combination of quantile-mapping (or any usual bias-correction method) and Schaake Shuffle.

**These scripts are for the cross-validation exercise** 

## v2023: new version for the new 2023 report
## Contents

#### Main folder
Scripts for preparing yearly files and adjust NetCDF attributes (prepare_obs.sh, prepare_input.sh, prepare_output.sh, ncatted_*.sh)

### GCM_RCM (e.g., MPI_CCLM)
Example scripts to post-process one of the bias-corrected **Historical** RCM data sets from KSS/NVE used in Klima i Norge 2100.
The scripts reorder the dates within a year following the reference dataset lag-1 autocorrelation (seperately for all variables).
(MET Norway specific file locations need to be changed)

### 3DBC output
is available at http://thredds.met.no/thredds/catalog/metusers/andreasd/3DBC/ver2023/xval/catalog.html

