library(devtools)
numberPersons <- 250
timePointsPerPerson <- function(){round(rnorm(1,mean=8,sd=1))}
getTime <- function(timePoint){rnorm(1,mean=timePoint,sd=0.5)}
set.seed(249)
demoLGCM <- data.frame(matrix(nrow=1,ncol = 3))
names(demoLGCM) <- c('ID','t','y')
counter <- 1
for (i in 1:numberPersons){
  nTime <- timePointsPerPerson()
  for (j in 1:nTime){
    demoLGCM[counter,'ID'] <- i
    demoLGCM[counter,'t'] <- getTime(j)
    demoLGCM[counter,'y'] <- 1
    counter <- counter + 1
  }
}
# meanf <- 'muI+muS*t'
covf <- 'varI+covIS*(t+t#)+varS*t*t#+(t==t#)*sigma'
lgcm <- gppm(meanf,covf,demoLGCM,'ID','y')
trueParas <- c(58,-1,5,1,0, 0.01)
names(trueParas) <-c('muI','muS','varI','varS','covIS','sigma')
demoLGCM <- simulate(lgcm,parameterValues=trueParas)

demoLGCMRed <- demoLGCM[1:20,]
fixedIcep <- gppm('Icep','(t==t#)*sigma',demoLGCMRed,'ID','y')
trueParasIcep <- c(0,5)
names(trueParasIcep) <-c('Icep','sigma')
demoBinary <- simulate(fixedIcep,parameterValues=trueParasIcep)
logistic <- function(x){1/(1+exp(-x))}
demoBinary$y <- logistic(demoBinary$y)
for (i in 1:nrow(demoBinary)){
  demoBinary$y[i] <- rbinom(1,1,demoBinary$y[i])
}
devtools::use_data(demoLGCM,trueParas,demoBinary,overwrite = TRUE)




