#' @title The precomputed result of LSTM for MHEALTH before oversampling.
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
#' @return BefoResuMHEALTH: the precomputed result of LSTM for MHEALTH before oversampling
#' @export BefoResuMHEALTH
#' @usage OSTOC::BefoResuMHEALTH()

BefoResuMHEALTH <- function() {
  data(LSTM_MHEALTH_full_before)  # load data
  BefoResuMHEALTH <- structure(class = "keras_training_history", list(params = LSTM_MHEALTH_full_before$params, metrics = LSTM_MHEALTH_full_before$metrics))  #build class
  return(BefoResuMHEALTH)
}