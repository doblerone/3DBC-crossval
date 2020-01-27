## An implementation of
## "A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate"
## by Mehrotra and Sharma (2019), Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270
## Refered to as 3DBC (3-dimensional bias-correction), as it keeps inter-variable, temporal and spatial consistencies from the reference data set.
## Basically a smart combination of quantile-mapping (or any usual bias-correction method) and Schaake Shuffle
###
### Implementation by A. Dobler, autumn 2019
### andreas.dobler@met.no

## This is the template for the R-job chain
## Generate (6-day) jobs by e.g. (in bash):
## for ((d=1;d<366;d=d+6)); do let e=d+5; sed "s/START/$d/g; s/END/$e/g" 3DBC_tas_IPSL_RCA_template.R > 3DBC_tas_IPSL_RCA_d${d}.R; done


library(ncdf4)

for (d in START:END)
{
  daystring <- format(as.Date(d-1, origin = "1980-01-01"),"%m%d") #Format: MMDD
  
  #some print output
  print(paste("Processing day",daystring))
  print("Reading data")
  
  #read data
  nc <- nc_open(paste("/lustre/storeB/users/andreasd/postclim/3DBC/tas/Obs/seNorge2018_1971-2010_",daystring,".nc",sep=""))
  ObsA <- ncvar_get(nc,"tg")
  nc_close(nc)
  
  nc <- nc_open(paste("/lustre/storeB/users/andreasd/postclim/3DBC/tas/Cur/hist_IPSL_RCA_TM_daily_1971-2010_",daystring,".nc",sep=""))
  CurA <- ncvar_get(nc,"air_temperature__map_hist_daily")/10-273.15
  
  #define mask with grid points with values
  ValMask <- which(!is.na(CurA[,,1]) ,arr.ind=T)
  NofPoints <- dim(ValMask)[1]
  
  nc_close(nc)
  
  nc <- nc_open(paste("/lustre/storeB/users/andreasd/postclim/3DBC/tas/Fut/rcp45_IPSL_RCA_TM_daily_2011-2100_",daystring,".nc",sep=""))
  FutA <- ncvar_get(nc,"air_temperature__map_rcp45_daily")/10-273.15
  nc_close(nc)
  #reading done
  
  #create arrays for corrected data
  CurCA <- array(NA,dim(CurA))
  FutCA <- array(NA,dim(FutA))
  
  #some print output
  print("PP started:")
  print(date())
  print("------------------------")
  
  #loop over grid pointss
  for (i in 1:NofPoints)  
  {
    if ((NofPoints-i) %% 100000 == 0)
      print(paste(NofPoints-i,"points left to do...",sep=" "))
    
    x <- ValMask[i,1]
    y <- ValMask[i,2]
    
    Obs <- ObsA[x,y,]
    Cur <- CurA[x,y,]
    FutL <- FutA[x,y,]
    
    #number of values
    nod <- length(Obs)
    nodf <- length(FutL)
    nodp1 <- nod+1
    
    #Split Fut into blockss
    futl <- ceiling(nodf/nod) #number of times Obs fits into Fut +1
    Fut <- array(NA,c(futl,nod))
    
    for (s in 1:(futl-1))
    {
      Fut[s,] <- as.numeric(unlist(split(FutL, ceiling(seq_along(FutL)/nod))[s]))
    }            
    Fut[futl,] <- FutL[(nodf-nod+1):nodf]
    
    #Rank data in descending order
    RankO <- nodp1 -  rank(Obs, ties.method = "first")
    RankC <- nodp1 -  rank(Cur, ties.method = "first")
    RankF <- nodp1 -  t(apply(Fut,1,rank,ties.method = "first"))
    
    #Cummulative probabilty
    ProbO <- 1-RankO/nodp1
    ProbC <- 1-RankC/nodp1
    ProbF <- 1-RankF/nodp1
    
    #Gaussian transformation
    GaussO <- qnorm(ProbO)
    GaussC <- qnorm(ProbC)
    GaussF <- qnorm(ProbF)
    
    #Calculate lag-one autocorrelations
    rO <- acf(GaussO,plot=F,lag.max=1)$acf[2]
    rC <- acf(GaussC,plot=F,lag.max=1)$acf[2]
    rF <- apply(GaussF,1,FUN = function (u) c(acf(u, plot = FALSE,lag.max=1)$acf[2]))
    
    #Remove rO from GaussO
    GaussOR <- GaussO/sqrt(1-rO*rO)
    GaussOR[2:nod] <- (GaussO[2:nod]-rO*GaussO[1:(nod-1)])/sqrt(1-rO*rO) #from 2nd time step
    
    #Calculate corrected autocorrelation
    rN <- ((1+rF) / (1+rC) * (1+rO) - (1-rF) / (1-rC) * (1-rO) ) / ((1+rF) / (1+rC) * (1+rO) + (1-rF) / (1-rC) * (1-rO) ) 
    
    #Add rN to GaussOR. Note: Gauss for current climate equals GaussO!
    GaussFC <- sqrt(1-rN*rN) %*% t(GaussOR)
    for (t in 2:nod)
      GaussFC[,t] <- rN*GaussFC[,t-1] + sqrt(1-rN*rN) %*% t(GaussOR[t]) #from 2nd time step
    
    ##Rank and reorder values
    #Current cliamte
    CurCA[x,y,] <- sort(Cur,decreasing = TRUE)[RankO]
    
    #Future climate
    RankFC <- nodp1 -  t(apply(GaussFC,1,rank,ties.method = "first"))
    for (s in 1:(futl-1))
    {
      FutCA[x,y,(nod*(s-1)+1):(nod*s)] <- sort(Fut[s,],decreasing = TRUE)[RankFC[s,]]
    }            
    FutCA[x,y,(nodf-nod+1):nodf] <- sort(Fut[futl,],decreasing = TRUE)[RankFC[futl,]]
  }
  #That's all :-)
  
  print("------------------------")
  print("PP finished:")
  print(date())
  
  #Write to NetCDF
  print("Writing data...")
  
  OUT <- (CurCA+273.15)*100
  nc <- nc_open(paste("/lustre/storeB/users/andreasd/postclim/3DBC/tas/CurC/hist_IPSL_RCA_TM_daily_1971-2010_",daystring,".nc",sep=""),write=TRUE)
  ncvar_put(nc,"air_temperature__map_hist_daily",OUT)
  nc_close(nc)
  
  OUT <- (FutCA+273.15)*100
  nc <- nc_open(paste("/lustre/storeB/users/andreasd/postclim/3DBC/tas/FutC/rcp45_IPSL_RCA_TM_daily_2011-2100_",daystring,".nc",sep=""),write=TRUE)
  ncvar_put(nc,"air_temperature__map_rcp45_daily",OUT)
  nc_close(nc)
  
  print(paste("Day",daystring,"done."))
  print("===========================")
  
  rm(list = ls(all.names = TRUE)) #clear environment
  gc()                            #free up memrory and report the memory usage.
  
}


