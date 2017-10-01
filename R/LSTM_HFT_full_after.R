#' @title The precomputed result of LSTM for HFT after oversampling.
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
#' @name LSTM_HFT_full_after
#' @usage data(LSTM_HFT_full_after)
NULL