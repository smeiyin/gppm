% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extractors.R
\name{nObs}
\alias{nObs}
\title{Number of Observations}
\usage{
nObs(gpModel)
}
\arguments{
\item{gpModel}{object of class GPPM.}
}
\value{
Number of observations for each person as a numeric vector. The corresponding IDs are in the IDs attribute.
}
\description{
Extracts the number of observations for each person from a GPPM.
}
\examples{
\donttest{
data("demoLGCM")
lgcm <- gppm('muI+muS*t','varI+covIS*(t+t#)+varS*t*t#+(t==t#)*sigma',
        demoLGCM,'ID','y')
numberObs <-  nObs(lgcm)
}
}
\seealso{
Other functions to extract from a GPPM: \code{\link{SE}},
  \code{\link{coef.GPPM}}, \code{\link{confint.GPPM}},
  \code{\link{covf}}, \code{\link{datas}},
  \code{\link{fitted.GPPM}}, \code{\link{getIntern}},
  \code{\link{logLik.GPPM}}, \code{\link{maxnObs}},
  \code{\link{meanf}}, \code{\link{nPars}},
  \code{\link{nPers}}, \code{\link{nPreds}},
  \code{\link{parEsts}}, \code{\link{pars}},
  \code{\link{preds}}, \code{\link{vcov.GPPM}}
}
