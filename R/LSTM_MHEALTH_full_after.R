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
#' @docType data
#' @keywords datasets
#' @name LSTM_MHEALTH_full_after
#' @usage data(LSTM_MHEALTH_full_after)
NULL