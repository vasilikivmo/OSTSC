#' @title The precomputed result of LSTM for HFT after oversampling.
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
#' @return AfterResuHFT: the precomputed result of LSTM for HFT after oversampling
#' @export AfterResuHFT
#' @usage OSTOC::AfterResuHFT()

AfterResuHFT <- function() {
  data(LSTM_HFT_full_after)  # load data
  AfterResuHFT <- structure(class = "keras_training_history", list(params = LSTM_HFT_full_after$params, metrics = LSTM_HFT_full_after$metrics))  #build class
  return(AfterResuHFT)
}