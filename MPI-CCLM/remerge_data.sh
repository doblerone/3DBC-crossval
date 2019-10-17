###################################################################################
## Remerge data after 3DBC, i.e. merge single day files into annual files again  ##
###################################################################################

###################
## Precipitation
###################
### Current climate
cd /lustre/storeB/users/andreasd/postclim/3DBC/pr/CurC
mkdir -p merged split
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo mergetime hist_MPI_CCLM_RR_daily_1971-2010_${m}??.nc merged/hist_MPI_CCLM_RR_daily_1971-2010_${m}.nc
   cdo splityear merged/hist_MPI_CCLM_RR_daily_1971-2010_${m}.nc split/hist_MPI_CCLM_RR_daily_${m}_
done

# remove merged month files
rm merged/hist_MPI_CCLM_RR_daily_1971-2010_??.nc

# merge files for one year
for ((y=1971;y<=2010;y=y+1))
do cdo -f nc4 mergetime split/hist_MPI_CCLM_RR_daily_??_${y}.nc merged/hist_MPI_CCLM_RR_daily_${y}.nc
done

# remove split files
rm split/hist_MPI_CCLM_RR_daily_??_????.nc
rmdir split

###################
### Future climate (rcp85)
#merge daily files for one month
cd /lustre/storeB/users/andreasd/postclim/3DBC/pr/FutC
mkdir -p merged split
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo mergetime rcp85_MPI_CCLM_RR_daily_2011-2100_${m}??.nc merged/rcp85_MPI_CCLM_RR_daily_2011-2100_${m}.nc
   cdo splityear merged/rcp85_MPI_CCLM_RR_daily_2011-2100_${m}.nc split/rcp85_MPI_CCLM_RR_daily_${m}_
done

# remove merged month files
rm merged/rcp85_MPI_CCLM_RR_daily_2011-2100_??.nc

# merge files for one year
for ((y=2011;y<=2100;y=y+1))
do cdo -f nc4 mergetime split/rcp85_MPI_CCLM_RR_daily_??_${y}.nc merged/rcp85_MPI_CCLM_RR_daily_${y}.nc
done

# remove split files
rm split/rcp85_MPI_CCLM_RR_daily_??_????.nc
rmdir split

###################
## Temperature
###################
### Current climate
cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/CurC
mkdir -p merged split
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo mergetime hist_MPI_CCLM_TM_daily_1971-2010_${m}??.nc merged/hist_MPI_CCLM_TM_daily_1971-2010_${m}.nc
   cdo splityear merged/hist_MPI_CCLM_TM_daily_1971-2010_${m}.nc split/hist_MPI_CCLM_TM_daily_${m}_
done

# remove merged month files
rm merged/hist_MPI_CCLM_TM_daily_1971-2010_??.nc

# merge files for one year
for ((y=1971;y<=2010;y=y+1))
do cdo -f nc4 mergetime split/hist_MPI_CCLM_TM_daily_??_${y}.nc merged/hist_MPI_CCLM_TM_daily_${y}.nc
done

# remove split files
rm split/hist_MPI_CCLM_TM_daily_??_????.nc
rmdir split

###################
### Future climate (rcp85)
#merge daily files for one month
cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/FutC
mkdir -p merged split
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo mergetime rcp85_MPI_CCLM_TM_daily_2011-2100_${m}??.nc merged/rcp85_MPI_CCLM_TM_daily_2011-2100_${m}.nc
   cdo splityear merged/rcp85_MPI_CCLM_TM_daily_2011-2100_${m}.nc split/rcp85_MPI_CCLM_TM_daily_${m}_
done

# remove merged month files
rm merged/rcp85_MPI_CCLM_TM_daily_2011-2100_??.nc

# merge files for one year
for ((y=2011;y<=2100;y=y+1))
do cdo -f nc4 mergetime split/rcp85_MPI_CCLM_TM_daily_??_${y}.nc merged/rcp85_MPI_CCLM_TM_daily_${y}.nc
done

# remove split files
rm split/rcp85_MPI_CCLM_TM_daily_??_????.nc
rmdir split
###################################
## Adjust NetCDF header information
###################################
for file in /lustre/storeB/users/andreasd/postclim/3DBC/*/???C/merged/*nc
do ncatted -O -a summary,global,o,c,"Post-processing the bias-corrected data used in Klima i Norge 2100 (see http://data.nve.no/report/climate_hydrological_projections_Norway.pdf) using the 3D bias-correction method proposed by Mehrotra and Sharma (2019). The 3DBC method corrects for temporal, spatial and inter-variable inconsistencies introduced by quantile mapping. seNorge_2018 daily precipitation and temperature data has been used as the reference data set." $file
ncatted -O -a creator_name,global,o,c,"Andreas Dobler" $file
ncatted -O -a creator_email,global,o,c,"andreas.dobler@met.no" $file
ncatted -O -a references,global,o,c,"Mehrotra and Sharma (2019): A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate, Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270" $file
ncatted -O -a institution,global,o,c,"The Norwegian Meteorological Institute (MET Norway)" $file
ncatted -O -a keywords,global,o,c,"Climate, Meteorology, Precipitation projections, Gridded data, Bias-adjustment, Empirical quantile mapping, 3DBC, Norway" $file
ncatted -O -a date_created,global,o,c,"Autumn 2019" $file
ncatted -O -h -a history,global,d,c,"" $file
done






