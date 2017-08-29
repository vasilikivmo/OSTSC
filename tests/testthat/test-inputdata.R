library(xts)
context("input data")

test_that("input data could be in xts format", {
  # create xts data
  data("synthetic_control")
  train.label <- synthetic_control$train.y
  train.sample <- synthetic_control$train.x
  train <- cbind(train.label, train.sample)
  df.xts <- as.xts(train, order.by=Sys.time() + 1:dim(train)[1])
  df.label <- df.xts[, c(1)]
  df.sample <- df.xts[, -1]
  # oversampling
  MyData <- OSTSC(df.sample, df.label, parallel = FALSE, k = 4)
  label <- MyData$label
  expect_equal( length(label[which(label == 0)]), length(label[which(label == 1)]) )
})

test_that("input data could be in array format", {
  # create array
  data("synthetic_control")
  train.label <- synthetic_control$train.y
  train.sample <- synthetic_control$train.x
  df.label <- as.array(train.label)
  df.sample <- as.array(train.sample)
  # oversampling
  MyData <- OSTSC(df.sample, df.label, parallel = FALSE, k = 4)
  label <- MyData$label
  expect_equal( length(label[which(label == 0)]), length(label[which(label == 1)]) )
})

test_that("input data could be in data frame format", {
  # create data frame
  data("synthetic_control")
  train.label <- synthetic_control$train.y
  train.sample <- synthetic_control$train.x
  df.label <- as.data.frame(train.label)
  df.sample <- as.data.frame(train.sample)
  # oversampling
  MyData <- OSTSC(df.sample, df.label, parallel = FALSE, k = 4)
  label <- MyData$label
  expect_equal( length(label[which(label == 0)]), length(label[which(label == 1)]) )
})

test_that("input sample and label data have same first dimension", {
  # create samples and labels with different records
  data("synthetic_control")
  train.label <- synthetic_control$train.y
  train.sample <- synthetic_control$train.x
  df.label <- train.label
  df.sample <- train.sample[-1, ]
  # oversampling
  expect_error( OSTSC(df.sample, df.label, parallel = FALSE, k = 4), "Number of time series sequences provided" )
})

test_that("OSTSC handles datasets containing NA, NaN, or accidental strings", {
  # create data containing NA, NaN, and accidental strings
  data("synthetic_control")
  train.label <- synthetic_control$test.y
  train.sample <- synthetic_control$test.x
  train.sample[1, 3] <- NaN
  train.sample[4, 1] <- NA 
  train.sample[5, 5] <- 'a'
  # oversampling
  MyData <- OSTSC(train.sample, train.label, parallel = FALSE)
  label <- MyData$label
  expect_equal( length(label[which(label == 0)]), length(label[which(label == 1)]) )
})