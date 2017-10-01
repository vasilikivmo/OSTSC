#' @title The precomputed result of LSTM for MHEALTH after oversampling.
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
#' @return AfterResuMHEALTH: the precomputed result of LSTM for MHEALTH after oversampling
#' @export AfterResuMHEALTH
#' @usage OSTOC::AfterResuMHEALTH()

AfterResuMHEALTH <- function() {
  data(LSTM_MHEALTH_full_after)  # load data
  AfterResuMHEALTH <- structure(class = "keras_training_history", list(params = LSTM_MHEALTH_full_after$params, metrics = LSTM_MHEALTH_full_after$metrics))  #build class
  return(AfterResuMHEALTH)
}