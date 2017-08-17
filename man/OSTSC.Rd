% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/OSTSC.R
\name{OSTSC}
\alias{OSTSC}
\title{Over sampling for time series classification}
\usage{
OSTSC(sample, label, target_class, ratio = 1, Per = 0.8, R = 1, k = 5,
  m = 15, parallel = TRUE, progBar = TRUE)
}
\arguments{
\item{sample}{univariate sequence data samples}

\item{label}{labels corresponding to samples}

\item{target_class}{the label of the class which need to be oversampled}

\item{ratio}{targeted positive samples number to achieve/negative samples number, with the default value 1}

\item{Per}{Percentage of the mixing between SPO and ADASYN, with the default value 0.8}

\item{R}{An scalar ratio to tell in which level (towards the boundary) we shall push our syntactic data in EPSO, 
with the default value 1}

\item{k}{k-NN used in the ADASYN algorithm, with the default value 5}

\item{m}{m-NN used in ADASYN, finding seeds from the Positive Class, with the default value 15}

\item{parallel}{Whether to run in parallel, with the default setting TRUE.
(Recommend for dataset with over 30,000 records. The using cores is 1 less than the total cores)}

\item{progBar}{Whether to include progress bars, with the default setting TRUE.
For EPSO approach, the bar charactor is |--------|100\%.
For ADASYN approach, the bar charactor is |========|100\%.}
}
\value{
sample: the time series sequences data oversampled

label: the label corresponding to each row of records
}
\description{
Oversample a time series sequence imbalance data.
}
\details{
This function balances a binary imbalance time series data.
}
\examples{
# loading data
data(synthetic_control_TRAIN)   
# create feature and label data 
label <- synthetic_control_TRAIN[, c(1)]
sample <- synthetic_control_TRAIN[, -1] 
# oversample the class 1 to the same amount of class 0
MyData <- OSTSC(sample, label, target_class = 1)
# print the feature data after oversampling
MyData$sample
# print the label data after oversampling
MyData$label
}
\references{
H. Cao, X.-L. Li, Y.-K. Woon and S.-K. Ng, 
            "Integrated Oversampling for Imbalanced Time Series Classification" 
            IEEE Trans. on Knowledge and Data Engineering (TKDE), 
            vol. 25(12), pp. 2809-2822, 2013
}