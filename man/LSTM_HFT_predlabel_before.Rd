% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LSTM_HFT_predlabel_before.R
\docType{data}
\name{LSTM_HFT_predlabel_before}
\alias{LSTM_HFT_predlabel_before}
\title{The precomputed prediction labels from LSTM for HFT before oversampling.}
\format{A list of prediction labels.}
\usage{
data(LSTM_HFT_predlabel_before)
}
\details{
The LSTM for large dataset is slow. To avoid running LSTM every time creating 
the vignettes, the precomputed result is recorded for vignettes knit efficiency.
}
\keyword{datasets}
