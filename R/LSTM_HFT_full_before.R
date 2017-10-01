#' @title The precomputed result of LSTM for HFT before oversampling.
#'
#' @details The LSTM for 30000 observations dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#'
#' @format A list of LSTM result. 
#' \describe{
#'   params: list of 7
#'   metrics: list of 4
#'   ...
#' }
#' 
#' @docType data
#' @keywords datasets
#' @name LSTM_HFT_full_before
#' @usage data(LSTM_HFT_full_before)
NULL