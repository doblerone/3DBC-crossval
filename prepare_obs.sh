#######################################################################
## Prepare reference data for 3DBC
## Reference data = seNorge_2018, KliNoGrid_16.12 and HySN2018v2005ERA5
#######################################################################
BASEDIR=/lustre/storeB/users/andreasd/KiN_2023_data/3DBC/

###############
## Prepare dirs
###############
cd ${BASEDIR}
for var in pr tas sfcWind hurs ps rlds rsds #tasmin and tasmax are included in tas
 do mkdir -p ${var}/Obs
done

##################
## Link/merge data
##################

###################
## Precipitation
###################
cd ${BASEDIR}/pr/Obs/
ln -s /lustre/storeB/users/cristianl/seNorge2/download/seNorge_2018_v20.05/RR_adjusted/*nc .

##########################
## Temperature
## incl. min, max and mean
##########################
cd ${BASEDIR}/tas/Obs/
ln -s /lustre/storeB/project/metkl/senorge2/thredds/seNorge/seNorge_2018/Archive/*nc .
rm seNorge2018_2021.nc

#########
## Wind
#########
cd ${BASEDIR}/sfcWind/Obs/
for ((y=1958;y<2015;y++))
 do ncrcat -x -v altitude /lustre/storeA/project/metkl/klinogrid/thredds/KliNoGrid_16.12/FFMRR-Nor/${y}/KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_${y}??.nc KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_${y}.nc
done

#######################
## hurs, ps, rlds, rsds
#######################
for var in hurs ps rlds rsds
 do cd ${BASEDIR}/${var}/Obs/
 ln -s /lustre/storeB/users/andreasd/KiN_2023_data/HySN2018v2005ERA5/*${var}*nc4 . 
done

