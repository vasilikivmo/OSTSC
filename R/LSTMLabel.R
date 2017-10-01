#' @title The precomputed prediction labels from LSTM.
#'
#' @description The LSTM for large dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#' @param labelData the precomputed prediction labels from LSTM
#' @return resu: the precomputed prediction labels in vector format

LSTMLabel <- function(labelData) {
  data(labelData)  # load data
  resu <- as.vector(unlist(labelData))  #as vector
  return(resu)
}