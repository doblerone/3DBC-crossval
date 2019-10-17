# 3DBC
An implementation of "A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate", Mehrotra and Sharma (2019), Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270 in R

The method is refered to as 3DBC (3-dimensional bias-correction), as it keeps inter-variable, temporal and spatial consistencies from the reference data set.

It is basically a smart combination of quantile-mapping (or any usual bias-correction method) and Schaake Shuffle.

## Contents
### Table1
Implementation and content of the Table 1 example from the paper. Note the comments in the script.

### MPI-CCLM
Example scripts to post-process one of the bias-corrected RCM data from KSS/NVE used in Klima i Norge 2100.
(MET Norway specific file locations need to be changed)

1. The data is split into files containing one day of the year each (prepare.sh).
2. The 3DBC script is applied to reorder the dates following the reference data (seNorge_2018) lag-1 autocorrelation (seperately for pr and tas).
3. The data is remerged (remerge_data.sh) to the previous file structure.

The output of this is available at
http://thredds.met.no/thredds/catalog/metusers/andreasd/3DBC/catalog.html
