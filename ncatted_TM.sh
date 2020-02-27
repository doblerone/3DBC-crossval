###################################
## Adjust NetCDF header information
###################################
for file in /lustre/storeB/users/andreasd/postclim/3DBC/tas/???C/merged/*nc
do ncatted -O -a summary,global,o,c,"Post-processing the bias-corrected data used in Klima i Norge 2100 (see http://data.nve.no/report/climate_hydrological_projections_Norway.pdf) using the 3D bias-correction method proposed by Mehrotra and Sharma (2019). The 3DBC method corrects for temporal, spatial and inter-variable inconsistencies introduced by quantile mapping. seNorge_2018 daily precipitation and temperature data has been used as the reference data set." $file
ncatted -O -a creator_name,global,o,c,"Andreas Dobler" $file
ncatted -O -a creator_email,global,o,c,"andreas.dobler@met.no" $file
ncatted -O -a references,global,o,c,"Mehrotra and Sharma (2019): A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate, Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270" $file
ncatted -O -a institution,global,o,c,"The Norwegian Meteorological Institute (MET Norway)" $file
ncatted -O -a keywords,global,o,c,"Climate, Meteorology, Temperature projections, Gridded data, Bias-adjustment, Empirical quantile mapping, 3DBC, Norway" $file
ncatted -O -a date_created,global,o,c,"Autumn 2019" $file
ncatted -O -h -a history,global,d,c,"" $file
done
