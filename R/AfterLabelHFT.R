#' @title The precomputed prediction labels from LSTM for HFT after oversampling.
#'
#' @details The LSTM for large dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#'
#' @format A list of prediction labels. 
#'
#' @return AfterLabelHFT: the precomputed prediction labels from LSTM for HFT after oversampling
#' @export AfterLabelHFT
#' @usage OSTOC::AfterLabelHFT()

AfterLabelHFT <- function() {
  data(LSTM_HFT_predlabel_after)  # load data
  AfterLabelHFT <- as.vector(unlist(LSTM_HFT_predlabel_after))  #as vector
  return(AfterLabelHFT)
}