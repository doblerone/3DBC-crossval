##########################################################################################################################
## Prepare data for 3DBC, i.e. split them into files containing one day of the year each (total 366 files)  ##
##########################################################################################################################
## For IPSL driven RCA --> Adjust for more models
########################################################
## Reference data = seNorge_2018
## External data source: http://thredds.met.no/thredds/catalog/metusers/senorge2/seNorge/seNorge_2018/Archive/catalog.html
## Paper: https://www.earth-syst-sci-data.net/10/235/2018/
#######################################################

### Split yearly files into monthly files
#cd /lustre/storeB/project/metkl/senorge2/thredds/seNorge/seNorge_2018/Archive
#for file in seNorge2018_197[1-9].nc seNorge2018_198* seNorge2018_199* seNorge2018_200* seNorge2018_2010.nc
#do cdo splitmon -selvar,tg $file /lustre/storeB/users/andreasd/postclim/3DBC/tas/Obs/${file}_month
#   cdo splitmon -selvar,rr $file /lustre/storeB/users/andreasd/postclim/3DBC/pr/Obs/${file}_month
#done

###################
## Precipitation
###################

# Merge monthly files over all years
#cd /lustre/storeB/users/andreasd/postclim/3DBC/pr/Obs/
#for m in 01 02 03 04 05 06 07 08 09 10 11 12
#do ncrcat seNorge2018_????.nc_month${m}.nc seNorge2018_1971-2010_${m}.nc
#done

# Remove single monthly files
#rm seNorge2018_????.nc_month??.nc

# Split into daily files
#for file in seNorge2018_1971-2010_??.nc
#do cdo splitday $file ${file}_day
#done

# Remove merged monthly files
#rm seNorge2018_1971-2010_??.nc

# Rename files
#rename "s/.nc_day//g" seNorge2018_1971-2010_??.nc_day??.nc

###################
## Temperature
###################
# Merge monthly files over all years
#cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/Obs/
#for m in 01 02 03 04 05 06 07 08 09 10 11 12
#do ncrcat seNorge2018_????.nc_month${m}.nc seNorge2018_1971-2010_${m}.nc
#done

# Remove single monthly files
#rm seNorge2018_????.nc_month??.nc

# Split into daily files
#for file in seNorge2018_1971-2010_??.nc
#do cdo splitday $file ${file}_day
#done

# Remove merged monthly files
#rm seNorge2018_1971-2010_??.nc

# Rename files
#rename "s/.nc_day//g" seNorge2018_1971-2010_??.nc_day??.nc

#######################################################
## Climate data = bias-corrected RCM data from KSS/NVE
## Extrenal data source: https://nedlasting.nve.no/klimadata/kss
## Report: http://publikasjoner.nve.no/rapport/2016/rapport2016_59.pdf
#######################################################
### Current climate
###################
## Precipitation
###################
# Split into monthly files
cd /lustre/storeB/users/andreasd/postclim/3DBC/pr/Cur
cdo -r -splitmon /lustre/storeB/project/KSS/proj/scenariodata/Precipitation/netcdf/IPSL_RCA/hist/hist_IPSL_RCA_RR_daily_1971-2010.nc hist_IPSL_RCA_RR_daily_1971-2010_month

# Split into daily files
for file in hist_IPSL_RCA_RR_daily_1971-2010_month??.nc
do cdo splitday $file ${file}_day
done

# Remove monthly files
rm hist_IPSL_RCA_RR_daily_1971-2010_month??.nc

# Rename files
rename "s/.nc_day//g" hist_IPSL_RCA_RR_daily_1971-2010_month??.nc_day??.nc
rename "s/month//g" hist_IPSL_RCA_RR_daily_1971-2010_month????.nc

###################
## Temperature
###################
# Split into monthly files
cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/Cur
cdo -r -splitmon /lustre/storeB/project/KSS/proj/scenariodata/Temperature/netcdf/IPSL_RCA/hist/hist_IPSL_RCA_TM_daily_1971-2010.nc hist_IPSL_RCA_TM_daily_1971-2010_month

# Split into daily files
for file in hist_IPSL_RCA_TM_daily_1971-2010_month??.nc
do cdo splitday $file ${file}_day
done

# Remove monthly files
rm hist_IPSL_RCA_TM_daily_1971-2010_month??.nc

# Rename files
rename "s/.nc_day//g" hist_IPSL_RCA_TM_daily_1971-2010_month??.nc_day??.nc
rename "s/month//g" hist_IPSL_RCA_TM_daily_1971-2010_month????.nc

##########################
### Future climate (rcp45)
##########################
## Precipitation
###################
### Split yearly files into monthly files
cd /lustre/storeB/project/KSS/proj/scenariodata/Precipitation/netcdf/IPSL_RCA/rcp45/
for file in rcp45_IPSL_RCA_RR_daily_{2011..2100}_v4.nc
do cdo splitmon $file /lustre/storeB/users/andreasd/postclim/3DBC/pr/Fut/${file}_month
done

# Merge monthly files over all years
cd /lustre/storeB/users/andreasd/postclim/3DBC/pr/Fut/
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo -r mergetime rcp45_IPSL_RCA_RR_daily_2???_v4.nc_month${m}.nc rcp45_IPSL_RCA_RR_daily_2011-2100_${m}.nc
done

# Remove single monthly files
rm rcp45_IPSL_RCA_RR_daily_2???_v4.nc_month??.nc

# Split into daily files
for file in rcp45_IPSL_RCA_RR_daily_2011-2100_??.nc
do cdo splitday $file ${file}_day
done

# Remove merged monthly files
rm rcp45_IPSL_RCA_RR_daily_2011-2100_??.nc

# Rename files
rename "s/.nc_day//g" rcp45_IPSL_RCA_RR_daily_2011-2100_??.nc_day??.nc

# Copy current and future climate files (to be adjusted by the 3DBC R-scripts)
module load nco #load newest nco version

cd /lustre/storeB/users/andreasd/postclim/3DBC/pr/Cur/
for file in hist_IPSL_RCA_RR_daily_1971-2010_????.nc
do ncap2 -s 'precipitation__map_hist_daily=double(precipitation__map_hist_daily)*0.1' $file ../CurC/$file
done

cd /lustre/storeB/users/andreasd/postclim/3DBC/pr/Fut/
for file in rcp45_IPSL_RCA_RR_daily_2011-2100_????.nc
do ncap2 -s 'precipitation__map_rcp45_daily=double(precipitation__map_rcp45_daily)*0.1' $file ../FutC/$file
done

###################
## Temperature
###################
### Split yearly files into monthly files
cd /lustre/storeB/project/KSS/proj/scenariodata/Temperature/netcdf/IPSL_RCA/rcp45/
for file in rcp45_IPSL_RCA_TM_daily_{2011..2100}_v4.nc
do cdo splitmon $file /lustre/storeB/users/andreasd/postclim/3DBC/tas/Fut/${file}_month
done

# Merge monthly files over all years
cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/Fut/
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo -r mergetime rcp45_IPSL_RCA_TM_daily_2???_v4.nc_month${m}.nc rcp45_IPSL_RCA_TM_daily_2011-2100_${m}.nc
done

# Remove single monthly files
rm rcp45_IPSL_RCA_TM_daily_2???_v4.nc_month??.nc

# Split into daily files
for file in rcp45_IPSL_RCA_TM_daily_2011-2100_??.nc
do cdo splitday $file ${file}_day
done

# Remove merged monthly files
rm rcp45_IPSL_RCA_TM_daily_2011-2100_??.nc

# Rename files
rename "s/.nc_day//g" rcp45_IPSL_RCA_TM_daily_2011-2100_??.nc_day??.nc

# Copy current and future climate files (to be adjusted by the 3DBC R-scripts)
cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/CurC/
cp /lustre/storeB/users/andreasd/postclim/3DBC/tas/Cur/hist_IPSL_RCA_TM_daily_1971-2010_????.nc .

cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/FutC/
cp /lustre/storeB/users/andreasd/postclim/3DBC/tas/Fut/rcp45_IPSL_RCA_TM_daily_2011-2100_????.nc .




