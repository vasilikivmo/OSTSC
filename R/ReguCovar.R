#' Generate samples by ESPO and ADASYN.
#' 
#' @param cleanData First column is label data, rest is sample data, without NA, NaN values
#' @param targetClass The class needs to be oversampled
#' @param ratio Targeted positive samples number to achieve/negative samples number, with the default value 1.
#' @param per Percentage of the mixing between ESPO and ADASYN, with the default value 0.8
#' @param r An scalar ratio to tell in which level (towards the boundary) we shall push our syntactic data, 
#'          with the default value 1
#' @param k k-NN used in the ADASYN algorithm, with the default value 5
#' @param m m-NN used in ADASYN, finding seeds from the Positive Class, with the default value 15
#' @param parallel Whether to run in parallel, with the default setting TRUE 
#'                 (Recommend for dataset with over 30,000 records)
#' @param progBar Whether to include progress bars, with the default setting TRUE
#' @return newData
#' @importFrom stats cov
#' @keywords internal

ReguCovar <- function(cleanData, targetClass, ratio, r, per, k, m, parallel, progBar) {
  # Generate samples by ESPO and ADASYN.
  #
  # Args:
  #   cleanData:    First column is label data, rest is sample data, without missing values.
  #   targetClass: The class needs to be oversampled. 
  #   ratio:        Targeted positive samples number to achieve/negative samples number, 
  #                 with the default value 1.
  #   r:            An scalar ratio to tell in which level (towards the boundary) we shall push our 
  #                 syntactic data, with the default value 1. 
  #   per:          Percentage of the mixing between ESPO and ADASYN. 
  #   k:            k-NN used in the ADASYN algorithm, with the default value 5.
  #   m:            m-NN used in ADASYN, finding seeds from the Positive Class, with the default value 15.
  #   parallel:     Whether to run in parallel, with the default setting TRUE. 
  #                 (Recommend for dataset with over 30,000 records)
  #   progBar:      Whether to include progress bars, with the default setting TRUE.
  #
  # Returns:
  #   newData: the oversampled dataset.
  
  # form positive (target class) data and negative data
  # The negative data is formed using a one-vs-rest manner.
  positive <- cleanData[which(cleanData[, c(1)] == targetClass), ]
  
  negative <- cleanData[which(cleanData[, c(1)] != targetClass), ]
  
  p <- positive[, -1]  # remove label column
  n <- negative[, -1]
  
  # Number of sequences needed to be created
  nTarget <- nrow(N)*ratio
  
  poscnt <- nrow(P)
  if (nTarget > poscnt) { 
    # check if the positive data records have already more than the records asked to be created
    
    # Compute Regularized Eigen Spectra
    numToGen <- ceiling((nTarget - poscnt)*per)
    numADASYN <- nTarget - poscnt - numToGen
    
    me <- apply(p, 2, mean)  # Mean vector of p
    pCov <- cov(p)  # vector covariance
    v <- eigen(pCov)$vectors  # Eigen axes matrix
    # v <- v[, n:1]
    d <- eigen(pCov)$values  # Eigenvalues
    # d <- d[n:1]
    n <- ncol(p)  # The feature dimension
    ind <- which(d <= 0.005)  # The unreliable eigenvalues
    if (length(ind) != 0) {
      por <- ind[1]  # [1,por] the portion of reliable
    } else {
      por <- n
    }
    tCov  <- cov(rbind(p, n))  # The covariance matrix of the total data (column)
    dT <- crossprod(v, tCov) %*% v  # dT = v' * tCov * v
    dT <- diag(dT)  # Turning the diagonal of matrix dT to a vector
    
    # Modify the Eigen spectrum according to a 1-Parameter Model
    # dMod: Modified Eigen Spectrum Value
    dMod <- matrix(0, 1, n)
    alpha <- d[1]*d[por]*(por-1)/(d[1] - d[por])
    beta  <- (por*d[por] - d[1])/(d[1] - d[por])
    for (i in 1:n) {
      if (i < por) {
        dMod[i] <- d[i]
      } else {
        dMod[i] = alpha/(i+beta)
        if (dMod[i] > dT[i]) {
          dMod[i] <- dT[i]
        }
      }
    }
    # Create Oversampled Data by ESPO and ADASYN, users choose if applying in parallel and if adding progress bar
    if (numToGen != 0) {
      if (identical(parallel, FALSE)) {
        if (identical(progBar, FALSE)) {
          sampleESPO <- ESPO(me, v, dMod, p, n, r, por, numToGen)
        } else {
          cat("Oversampling class", targetClass, "... \n")
          sampleESPO <- ESPOBar(me, v, dMod, p, n, r, por, numToGen)
        }
      } else {
        if (identical(progBar, FALSE)) {
          sampleESPO <- ESPOPara(me, v, dMod, p, n, r, por, numToGen)
        } else {
          cat("Oversampling class", target_class, "... \n")
          sampleESPO <- ESPOParaBar(me, v, dMod, p, n, r, por, numToGen)
        }
      }
    }
    
    if (numADASYN != 0) {
      if (identical(parallel, FALSE)) {
        if (identical(progBar, FALSE)) {
          sampleADA <- ADASYN(t(p), t(n), numADASYN, k, m)
        } else {
          sampleADA <- ADASYNBar(t(p), t(n), numADASYN, k, m)
        }
      } else {
        if (identical(progBar, FALSE)) {
          sampleADA <- ADASYNPara(t(p), t(n), numADASYN, k, m)
        } else {
          sampleADA <- ADASYNParaBar(t(p), t(n), numADASYN, k, m)
        }
      }
    }
    
    # Form new data
    dataTargetClass <- rbind(t(sampleADA), sampleESPO)
    newData <- cbind(matrix(targetClass, nTarget, 1), dataTargetClass)
    return(newData)
  } else {
    return(positive)
  }
}
