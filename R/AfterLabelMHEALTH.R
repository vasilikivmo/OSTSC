#' @title The precomputed prediction labels from LSTM for MHEALTH after oversampling.
#'
#' @details The LSTM for large dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#'
#' @format A list of prediction labels. 
#'
#' @return AfterLabelMHEALTH: the precomputed prediction labels from LSTM for MHEALTH after oversampling
#' @export AfterLabelMHEALTH
#' @usage OSTOC::AfterLabelMHEALTH()

AfterLabelMHEALTH <- function() {
  data(LSTM_MHEALTH_predlabel_after)  # load data
  AfterLabelMHEALTH <- as.vector(unlist(LSTM_MHEALTH_predlabel_after))  #as vector
  return(AfterLabelMHEALTH)
}