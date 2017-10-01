#' @title The precomputed result of LSTM for HFT before oversampling.
#'
#' @details The LSTM for large dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#'
#' @format A list of LSTM result. 
#' \describe{
#'   params: list of 7
#'   metrics: list of 4
#'   ...
#' }
#' 
#' @return BefoResuHFT: the precomputed result of LSTM for HFT before oversampling
#' @export BefoResuHFT
#' @usage OSTOC::BefoResuHFT()

BefoResuHFT <- function() {
  data(LSTM_HFT_full_before)  # load data
  BefoResuHFT <- structure(class = "keras_training_history", list(params = LSTM_HFT_full_before$params, metrics = LSTM_HFT_full_before$metrics))  #build class
  return(BefoResuHFT)
}