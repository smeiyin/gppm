

validate_toStan <- function(parsedModel,myData){
  stopifnot(is(parsedModel,'ParsedModel'))
}

.pkgglobalenv <- new.env(parent=emptyenv())

toStan <-function(parsedModel,control){
  validate_toStan(parsedModel)


  templateLocation <- file.path(system.file(package = 'gppm'),'stanTemplate2.stan')

  theTemplate <- readChar(templateLocation, file.info(templateLocation)$size)

  theCode <- theTemplate;
  paramSect <- paste0('real ', parsedModel$params,';',collapse = '\n ')
  theCode <- gsub('<parameters>',paramSect,theCode)
  theCode <- gsub('<meanfunction>',parsedModel$mFormula,theCode)
  theCode <- gsub('<covfunction>',parsedModel$kFormula,theCode)
  if(parsedModel$family=="binomial"){
    parsedModel$family <- 1
  }else{
    parsedModel$family <- 0
  }
  theCode <- gsub('<family>', parsedModel$family, theCode)
  if(parsedModel$link=="logit"){
    parsedModel$link <- 1
  }else{
    parsedModel$link <- 0
  }
  theCode <- gsub('<link>', parsedModel$link, theCode)
  if(control$stanModel){
    utils::capture.output(theModel <- rstan::stan_model(model_code = theCode,auto_write = TRUE))
  }else{
    theModel <- NA
  }
  return(theModel)
}


