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
do cdo mergetime hist_HADGEM_RCA_RR_daily_1971-2010_${m}??.nc merged/hist_HADGEM_RCA_RR_daily_1971-2010_${m}.nc
   cdo splityear merged/hist_HADGEM_RCA_RR_daily_1971-2010_${m}.nc split/hist_HADGEM_RCA_RR_daily_${m}_
done

# remove merged month files
rm merged/hist_HADGEM_RCA_RR_daily_1971-2010_??.nc

# merge files for one year
for ((y=1971;y<=2010;y=y+1))
do cdo -z zip -f nc4 mergetime split/hist_HADGEM_RCA_RR_daily_??_${y}.nc merged/hist_HADGEM_RCA_RR_daily_${y}.nc
done

# remove split files
rm split/hist_HADGEM_RCA_RR_daily_??_????.nc
rmdir split

###################
### Future climate (rcp45)
#merge daily files for one month
cd /lustre/storeB/users/andreasd/postclim/3DBC/pr/FutC
mkdir -p merged split
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo mergetime rcp45_HADGEM_RCA_RR_daily_2011-2100_${m}??.nc merged/rcp45_HADGEM_RCA_RR_daily_2011-2100_${m}.nc
   cdo splityear merged/rcp45_HADGEM_RCA_RR_daily_2011-2100_${m}.nc split/rcp45_HADGEM_RCA_RR_daily_${m}_
done

# remove merged month files
rm merged/rcp45_HADGEM_RCA_RR_daily_2011-2100_??.nc


# merge files for one year
for ((y=2011;y<=2100;y=y+1))
do cdo -z zip -f nc4 mergetime split/rcp45_HADGEM_RCA_RR_daily_??_${y}.nc merged/rcp45_HADGEM_RCA_RR_daily_${y}.nc
done

# remove split files
rm split/rcp45_HADGEM_RCA_RR_daily_??_????.nc
rmdir split

###################
## Temperature
###################
### Current climate
cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/CurC
mkdir -p merged split
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo mergetime hist_HADGEM_RCA_TM_daily_1971-2010_${m}??.nc merged/hist_HADGEM_RCA_TM_daily_1971-2010_${m}.nc
   cdo splityear merged/hist_HADGEM_RCA_TM_daily_1971-2010_${m}.nc split/hist_HADGEM_RCA_TM_daily_${m}_
done

# remove merged month files
rm merged/hist_HADGEM_RCA_TM_daily_1971-2010_??.nc

# merge files for one year
for ((y=1971;y<=2010;y=y+1))
do cdo -z zip -f nc4 mergetime split/hist_HADGEM_RCA_TM_daily_??_${y}.nc merged/hist_HADGEM_RCA_TM_daily_${y}.nc
done

# remove split files
rm split/hist_HADGEM_RCA_TM_daily_??_????.nc
rmdir split

###################
### Future climate (rcp45)
#merge daily files for one month
cd /lustre/storeB/users/andreasd/postclim/3DBC/tas/FutC
mkdir -p merged split
for m in 01 02 03 04 05 06 07 08 09 10 11 12
do cdo mergetime rcp45_HADGEM_RCA_TM_daily_2011-2100_${m}??.nc merged/rcp45_HADGEM_RCA_TM_daily_2011-2100_${m}.nc
   cdo splityear merged/rcp45_HADGEM_RCA_TM_daily_2011-2100_${m}.nc split/rcp45_HADGEM_RCA_TM_daily_${m}_
done

# remove merged month files
rm merged/rcp45_HADGEM_RCA_TM_daily_2011-2100_??.nc

# merge files for one year
for ((y=2011;y<=2100;y=y+1))
do cdo -z zip -f nc4 mergetime split/rcp45_HADGEM_RCA_TM_daily_??_${y}.nc merged/rcp45_HADGEM_RCA_TM_daily_${y}.nc
done

# remove split files
rm split/rcp45_HADGEM_RCA_TM_daily_??_????.nc
rmdir split






