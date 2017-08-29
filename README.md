# OSTSC
Over sampling for time series classification. 

This package is an achievement for Google Summer of Code 2017. This is a package balances the univariate imbalance time series data. There are some more supporting material for explanation located in respository GSoC2017 (https://github.com/lweicdsor/GSoC2017). This repository is considered a complete package which could be installed and used. I have tested it on Windows & Linux system.

# Installation
```java
library(devtools)
install_github("lweicdsor/OSTSC")
```
# Usage
library(OSTSC)

#### This is a simple example to show the usage. More complex examples are inside the vignettes. (https://github.com/lweicdsor/OSTSC/blob/master/inst/doc/Over_Sampling_for_Time_Series_Classification.pdf)

#### # loading data
data(synthetic_control)  
#### # get feature and label data 
train_label <- synthetic_control$train_y      

train_sample <- synthetic_control$train_x  
#### # the first dimension of feature and label shall be the same
#### # the second dimention of feature is the time sequence length
dim(train_sample)

dim(train_label)
#### # check the imbalance of the data
table(train_label)
#### # oversample the class 1 to the same amount of class 0
MyData <- OSTSC(train_sample, train_label)
#### # store the feature data after oversampling
x <- MyData$sample
#### # store the label data after oversampling
y <- MyData$label
#### # check the imbalance of the data
table(y)
