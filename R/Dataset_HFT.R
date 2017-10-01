#' @title The high frequency trading data.
#'
#' @description The data is a random selection from a high frequency trading data. 
#' @details The feature is from instantaneous liquidity imbalance using the best bid to ask ratio, up-tick 
#' as class 1, down-tick as class -1, and normal status as class 0. The time series sequences length is set 
#' to 10. In this package, the class 1 and class -1 observations are random selected till 6, while the 
#' class 0 is 288. While the whole observations are ordered in the time order, the dataset haven't split 
#' training and setting data. The users can split it by any ratio they like.
#'
#' @format A dataset with 300 observations and 10 sequence length, with a single sequence per row. 
#' \describe{
#'   The y data is the class label (1, -1 or 0)
#'   The x data constructs time series sequences (in numeric)
#'   ...
#' }
#' 
#' @docType data
#' @keywords datasets
#' @name Dataset_HFT
#' @usage data(Dataset_HFT)
#' @references Matthew Dixon.(2017) Sequence Classification of the Limit Order Book using Recurrent Neural Networks. 
#'             arXiv:1707.05642.
NULL