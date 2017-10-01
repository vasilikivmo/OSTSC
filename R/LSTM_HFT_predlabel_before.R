#' @title The precomputed prediction labels from LSTM for HFT before oversampling.
#'
#' @details The LSTM for large dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#'
#' @format A list of prediction labels. 
#' 
#' @docType data
#' @keywords datasets
#' @name LSTM_HFT_predlabel_before
#' @usage data(LSTM_HFT_predlabel_before)
NULL