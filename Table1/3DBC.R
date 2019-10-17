## Implementation of the Table 1 example from
## "A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate"
## by Mehrotra and Sharma (2019), Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270
## 
### Implementation by A. Dobler, autumn 2019
### andreas.dobler@met.no

## Reproducing the example, some issues (most likely related to close zero values) showed up:
# Going from left to right in Table 1
# RankO: Both, the 5th and 6th Obs from the bottom are 0, but the rank is different.
# RankC and RankF: In the text it says "Same value are assigned the same rank". But ranks for zero precipitation are increasing (contrary to RankO).
# ProbO, ProbC & ProbF: Unclear how the probabilities for small value (zero and small non-zero) are calculated. Is there a threshold involved? I get all other values the same as in the table (both for Prob and Gauss).
# GaussO, GaussC & GaussF: Calculating the sample lag one AC from the values in the table, I get rO = 0.23, rC = -0.15 & rF = 0.12 and, as a result, rN = 0.47
# GaussOR: I get the values from the table (approx.), when I use rO = 0.23 (the text says rO = -0.38, rC = -0.13, rF = 0.44)
# GaussFC: I get the values from the table (approx.), when I use rN = 0.47 (rN = 0.205 in the text). Calculating the sample lag one AC from the GaussFC values in the table, I get rFC = 0.43 (close to rN)
## Otherwise, the procedure seems to provide the same numbers, thus I assume it to be correct.

#read data
dat <- read.table("table1_3DBC.txt",header=T,sep=",")

#extract Obs, current and future (daily) values
Obs <- dat$Obs
Cur <- dat$Cur
Fut <- dat$Fut

#length/number of values
nod <- length(Obs)
nodp1 <- nod +1 

#Rank data in descending order
RankO <- nodp1 -  rank(Obs, ties.method = "first")
RankC <- nodp1 -  rank(Cur, ties.method = "first")
RankF <- nodp1 -  rank(Fut, ties.method = "first")

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
rF <- acf(GaussF,plot=F,lag.max=1)$acf[2]

#Remove rO from Gauss0
GaussOR <- GaussO/sqrt(1-rO*rO)
GaussOR[2:nod] <- (GaussO[2:nod]-rO*GaussO[1:(nod-1)])/sqrt(1-rO*rO) #from 2nd time step

#Calculate corrected autocorrelation
rN <- ((1+rF) / (1+rC) * (1+rO) - (1-rF) / (1-rC) * (1-rO) ) / ((1+rF) / (1+rC) * (1+rO) + (1-rF) / (1-rC) * (1-rO) ) 

#Add rN to GaussOR
GaussFC <- GaussOR * sqrt(1-rN*rN)
for (t in 2:nod)
GaussFC[t] <- rN*GaussFC[t-1] + GaussOR[t]*sqrt(1-rN*rN) #from 2nd time step

#Rank and reorder future values
RankFC <- nodp1 -  rank(GaussFC, ties.method = "first")
FutC <- sort(Fut,decreasing = TRUE)[RankFC]
CurC <- sort(Cur,decreasing = TRUE)[RankO]

## Plot
plot(Obs,type="l",lwd=3)
lines(Cur,col="navy")
lines(CurC,col="green")
lines(Fut,col="navy",lty=3)
lines(FutC,col="green",lty=3)
legend("topright",legend=c("Obs","Cur","CurC","Fut","FutC"),col=c("black","navy","green","navy","green"),lwd=c(3,2,2,2,2),lty=c(1,1,1,3,3))
