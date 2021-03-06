% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ADASYNBar.R
\name{ADASYNBar}
\alias{ADASYNBar}
\title{Generate samples by ADASYN approach.}
\usage{
ADASYNBar(p, n, nTarget, k, m)
}
\arguments{
\item{p}{minority class samples}

\item{n}{majority class samples}

\item{nTarget}{the targeted number of samples to achieve}

\item{k}{k-NN used in the ADASYN algorithm, with the default value 5}

\item{m}{m-NN used in ADASYN, finding seeds from the Positive Class, with the default value 15}
}
\value{
sampleADA
}
\description{
Generate samples by ADASYN approach.
}
\keyword{internal}
