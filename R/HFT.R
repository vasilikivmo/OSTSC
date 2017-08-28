#' The high frequency trading data
#'
#' The data is a random selection from a high frequency trading data. The feature is from instantaneous 
#' liquidity imbalance using the best bid to ask ratio, up-tick as class 1, down-tick as class -1, and
#' normal status as class 0. The time series sequences length is set to 10. In this package, the class 1
#' and class -1 observations are random selected till 600, while the class 0 is 28800. While the whole 
#' observations are ordered in the time order, the dataset haven't split training and setting data. The 
#' users can split it by any ratio they like.
#'
#' @format A time series data with sequence length 10 and observations number 30000. 
#' \describe{
#'   The train_y and test_y contain the class label (1, -1 or 0)
#'   The train_x and test_x contain time series sequences (in numeric)
#'   Each sequence occurs in one line.
#' }
#' 
#' @docType data
#' @keywords datasets
#' @export HFT
#' @usage HFT()
#' @references Matthew Dixon.(2017) Sequence Classification of the Limit Order Book using Recurrent Neural Networks. 
#'             arXiv:1707.05642.

HFT <- function() {
  # load data from github
  HFT <- rio::import("https://github.com/lweicdsor/GSoC2017/raw/master/toy_HFT/HFT.rda")
  return(HFT)
}