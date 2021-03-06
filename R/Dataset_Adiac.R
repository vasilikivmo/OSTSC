#' @title The automatic diatoms identification.
#'
#' @details The data Adiac is generated from a pilot study concerning automatic identification of 
#' diatoms (unicellular algae) on the basis of images (2004). The dataset originally had
#' 37 classes. But we selected only one class as positive class (class 1) and all others
#' as negative class (class 0) to form an extremely imbalance dataset. 
#'
#' @format A dataset with 781 observations and 176 sequence length, with a single sequence per row. 
#' \describe{
#'   The y data is the class label (1 or 0)
#'   The x data constructs time series sequences (in numeric)
#'   The training dataset contains 390 observations
#'   The testing dataset contains 391 observations
#'   ...
#' }
#' 
#' @docType data
#' @keywords datasets
#' @name Dataset_Adiac
#' @usage data(Dataset_Adiac)
#' @source \url{http://timeseriesclassification.com/description.php?Dataset=Adiac}
NULL