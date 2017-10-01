#' @title The precomputed prediction labels from LSTM for MHEALTH before oversampling.
#'
#' @details The LSTM for large dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#'
#' @format A list of prediction labels. 
#'
#' @return BefoLabelMHEALTH: the precomputed prediction labels from LSTM for MHEALTH before oversampling
#' @export BefoLabelMHEALTH
#' @usage OSTOC::BefoLabelMHEALTH()

BefoLabelMHEALTH <- function() {
  data(LSTM_MHEALTH_predlabel_before)  # load data
  BefoLabelMHEALTH <- as.vector(unlist(LSTM_MHEALTH_predlabel_before))  #as vector
  return(BefoLabelMHEALTH)
}