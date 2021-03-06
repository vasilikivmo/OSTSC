% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/OSTSC.R
\name{OSTSC}
\alias{OSTSC}
\title{Over Sampling for Time Series Classification}
\usage{
OSTSC(sample, label, class, ratio = 1, per = 0.8, r = 1, k = 5,
  m = 15, parallel = TRUE, progBar = TRUE)
}
\arguments{
\item{sample}{Univariate sequence data samples}

\item{label}{Labels corresponding to samples}

\item{class}{The number of the class which need to be oversampled, starting 
from the class with least observations, with the default setting 
to as most as possible.}

\item{ratio}{Targeted positive samples number to achieve/negative samples 
number, with the default value 1}

\item{per}{Percentage of the mixing between ESPO and ADASYN, with the default 
value 0.8}

\item{r}{An scalar ratio to tell in which level (towards the boundary) we shall 
push our syntactic data in ESPO, with the default value 1}

\item{k}{k-NN used in the ADASYN algorithm, with the default value 5}

\item{m}{m-NN used in ADASYN, finding seeds from the Positive Class, with the 
default value 15}

\item{parallel}{Whether to run in parallel, with the default setting TRUE. 
(Recommend for dataset with over 30,000 records. The using cores 
is 1 less than the total cores)}

\item{progBar}{Whether to include progress bars, with the default setting TRUE.
For ESPO approach, the bar charactor is |--------|100\%. 
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
This function balances univariate imbalance time series data based on 
structure preserving oversampling.
}
\examples{
# This is a simple example to show the usage. A more complex example is inside the vignette.
# loading data
data(synthetic_control)
# get split feature and label data 
train.label <- synthetic_control$train.y
train.sample <- synthetic_control$train.x
# the first dimension of feature and label shall be the same
# the second dimention of feature is the time sequence length
dim(train.sample)
dim(train.label)
# check the imbalance of the data
table(train.label)
# oversample the class 1 to the same amount of class 0
MyData <- OSTSC(train.sample, train.label, parallel = FALSE, k = 4)
# store the feature data after oversampling
x <- MyData$sample
# store the label data after oversampling
y <- MyData$label
# check the imbalance of the data
table(y)
}
\references{
H. Cao, X.-L. Li, Y.-K. Woon and S.-K. Ng, 
            "Integrated Oversampling for Imbalanced Time Series Classification" 
            IEEE Trans. on Knowledge and Data Engineering (TKDE), 
            vol. 25(12), pp. 2809-2822, 2013
            
            H. Cao, V. Y. F. Tan and J. Z. F. Pang, 
            "A Parsimonious Mixture of Gaussian Trees Model for Oversampling in Imbalanced and Multi-Modal Time-Series Classification" 
            IEEE Trans. on Neural Network and Learning System (TNNLS), 
            vol. 25(12), pp. 2226-2239, 2014
            
            H. Cao, X. L. Li, Y. K. Woon and S. K. Ng, 
            "SPO: Structure Preserving Oversampling for Imbalanced Time Series Classification" 
            Proc. IEEE Int. Conf. on Data Mining ICDM, 
            pp. 1008-1013, 2011
}
