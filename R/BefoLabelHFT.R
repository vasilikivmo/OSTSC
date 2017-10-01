#' @title The precomputed prediction labels from LSTM for HFT before oversampling.
#'
#' @details The LSTM for large dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#'
#' @format A list of prediction labels. 
#'
#' @return BefoLabelHFT: the precomputed prediction labels from LSTM for HFT before oversampling
#' @export BefoLabelHFT
#' @usage OSTOC::BefoLabelHFT()

BefoLabelHFT <- function() {
  data(LSTM_HFT_predlabel_before)  # load data
  BefoLabelHFT <- as.vector(unlist(LSTM_HFT_predlabel_before))  #as vector
  return(BefoLabelHFT)
}