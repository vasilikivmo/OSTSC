#' @title The precomputed result of LSTM.
#'
#' @description The LSTM for large dataset is slow. To avoid running LSTM every time creating 
#' the vignettes, the precomputed result is recorded for vignettes knit efficiency.
#' @param fullData the precomputed result of LSTM
#' @return resu: the precomputed result of LSTM in class keras_training_history

LSTMResu <- function(fullData) {
  load_data()  # load data
  resu <- structure(class = "keras_training_history", list(params = LSTMResu$params, metrics = LSTMResu$metrics))  #build class
  return(resu)
}