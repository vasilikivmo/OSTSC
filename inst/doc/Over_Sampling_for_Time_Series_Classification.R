## ---- echo=FALSE, message=FALSE------------------------------------------
require(OSTSC)
require(keras)
require(rio)
require(dummies)
require(pROC)

## ------------------------------------------------------------------------
library(OSTSC)
data(synthetic_control)

train.label <- synthetic_control$train.y
train.sample <- synthetic_control$train.x
test.label <- synthetic_control$test.y
test.sample <- synthetic_control$test.x

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label, k = 4)
over.sample <- MyData$sample
over.label <- MyData$label

## ------------------------------------------------------------------------
table(over.label)

## ------------------------------------------------------------------------
library(keras)
train.y <- to_categorical(train.label)
test.y <- to_categorical(test.label)
train.x <- array(train.sample, dim = c(dim(train.sample),1)) 
test.x <- array(test.sample, dim = c(dim(test.sample),1)) 

## ---- eval=FALSE---------------------------------------------------------
#  model <- keras_model_sequential()
#  model %>%
#    layer_lstm(10, input_shape = c(dim(train.x)[2], dim(train.x)[3])) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_dense(dim(train.y)[2]) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_activation("softmax")
#  model %>% compile(
#    loss = "categorical_crossentropy",
#    optimizer = "adam",
#    metrics = "accuracy"
#  )
#  lstm.before <- model %>% fit(
#    x = train.x,
#    y = train.y,
#    validation_split = 0.1,
#    epochs = 200
#  )
#  plot(lstm.before)

## ---- echo=FALSE, message=FALSE------------------------------------------
score <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/synthetic_control%20model%20saved/sc_before_score.rdata')
lstm.before <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/synthetic_control%20model%20saved/sc_before_e200.rdata')
pred.label <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/synthetic_control%20model%20saved/sc_before_predlabel.rdata')

score <- as.vector(unlist(score))
pred.label <- as.vector(unlist(pred.label))
plot(structure(class = "keras_training_history", list(params = lstm.before$params, metrics = lstm.before$metrics)))

## ---- eval=FALSE---------------------------------------------------------
#  score <- model %>% evaluate(test.x, test.y)

## ---- echo=FALSE---------------------------------------------------------
cat("The loss value is", unlist(score[1]), ".\n")
cat("The metric value (in this case 'accuracy') is", unlist(score[2]), ".\n")

## ------------------------------------------------------------------------
over.y <- to_categorical(over.label)
over.x <- array(over.sample, dim = c(dim(over.sample),1)) 

## ---- eval=FALSE---------------------------------------------------------
#  model.over <- keras_model_sequential()
#  model.over %>%
#    layer_lstm(10, input_shape = c(dim(over.x)[2], dim(over.x)[3])) %>%
#    layer_dropout(rate = 0.1) %>%
#    layer_dense(dim(over.y)[2]) %>%
#    layer_dropout(rate = 0.1) %>%
#    layer_activation("softmax")
#  model.over %>% compile(
#    loss = "categorical_crossentropy",
#    optimizer = "adam",
#    metrics = "accuracy"
#  )
#  lstm.after <- model.over %>% fit(
#    x = over.x,
#    y = over.y,
#    validation_split = 0.1,
#    epochs = 200
#  )
#  plot(lstm.after)

## ---- echo=FALSE, message=FALSE------------------------------------------
score.over <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/synthetic_control%20model%20saved/sc_after_score.rdata')
lstm.after <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/synthetic_control%20model%20saved/sc_after_e200.rdata')
pred.label.over <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/synthetic_control%20model%20saved/sc_after_predlabel.rdata')

score.over <- as.vector(unlist(score.over))
pred.label.over <- as.vector(unlist(pred.label.over))
plot(structure(class = "keras_training_history", list(params = lstm.after$params, metrics = lstm.after$metrics)))

## ---- eval=FALSE---------------------------------------------------------
#  score.over <- model.over %>% evaluate(test.x, test.y)

## ---- echo=FALSE---------------------------------------------------------
cat("The loss value is", unlist(score.over[1]), ".\n")
cat("The metric value (in this case 'accuracy') is", unlist(score.over[2]), ".\n")

## ---- eval=FALSE---------------------------------------------------------
#  pred.label <- model %>% predict_classes(test.x)
#  pred.label.over <- model.over %>% predict_classes(test.x)

## ------------------------------------------------------------------------
cm.before <- table(test.label, pred.label)
cm.after <- table(test.label, pred.label.over)

## ---- echo=FALSE---------------------------------------------------------
layout(matrix(c(1,1,2)))
par(mar=c(2,2,2,2))
plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
title('Normalized Confusion Matrix (before oversampling)', cex.main=1.75)

rect(150, 430, 240, 370, col='#3F97D0')
rect(250, 430, 340, 370, col='#F7AD50')
rect(150, 305, 240, 365, col='#F7AD50')
rect(250, 305, 340, 365, col='#3F97D0')
text(195, 435, '0', cex=1.2)
text(295, 435, '1', cex=1.2)
text(125, 370, 'True', cex=1.3, srt=90, font=2)
text(245, 450, 'Predicted', cex=1.3, font=2)
text(140, 400, '0', cex=1.2, srt=90)
text(140, 335, '1', cex=1.2, srt=90)

res <- as.numeric(cm.before)
sum1 <- res[1] + res[3]
sum2 <- res[2] + res[4] 
text(195, 400, round(res[1]/sum1, 4), cex=1.6, font=2, col='white')
text(195, 335, round(res[2]/sum2, 4), cex=1.6, font=2, col='white')
text(295, 400, round(res[3]/sum1, 4), cex=1.6, font=2, col='white')
text(295, 335, round(res[4]/sum2, 4), cex=1.6, font=2, col='white')

layout(matrix(c(1,1,2)))
par(mar=c(2,2,2,2))
plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
title('Normalized Confusion Matrix (after oversampling)', cex.main=1.75)

rect(150, 430, 240, 370, col='#3F97D0')
rect(250, 430, 340, 370, col='#F7AD50')
rect(150, 305, 240, 365, col='#F7AD50')
rect(250, 305, 340, 365, col='#3F97D0')
text(195, 435, '0', cex=1.2)
text(295, 435, '1', cex=1.2)
text(125, 370, 'True', cex=1.3, srt=90, font=2)
text(245, 450, 'Predicted', cex=1.3, font=2)
text(140, 400, '0', cex=1.2, srt=90)
text(140, 335, '1', cex=1.2, srt=90)

res <- as.numeric(cm.after)
sum1 <- res[1] + res[3]
sum2 <- res[2] + res[4] 
text(195, 400, round(res[1]/sum1, 4), cex=1.6, font=2, col='white')
text(195, 335, round(res[2]/sum2, 4), cex=1.6, font=2, col='white')
text(295, 400, round(res[3]/sum1, 4), cex=1.6, font=2, col='white')
text(295, 335, round(res[4]/sum2, 4), cex=1.6, font=2, col='white')

## ------------------------------------------------------------------------
library(pROC)
plot.roc(test.label, pred.label, legacy.axes = TRUE, col = "blue", print.auc = TRUE,  
         print.auc.cex= .8, xlab = 'False Positive Rate', ylab = 'True Positive Rate', 
         main="ROC synthetic_control")
plot.roc(test.label, pred.label.over, legacy.axes = TRUE, col = "red", print.auc = TRUE,   
         print.auc.y = .4, print.auc.cex= .8, add = TRUE)
legend("bottomright", legend=c("Before Oversampling", "After Oversampling"), 
       col=c("blue", "red"), lwd=2, cex= .6)

## ------------------------------------------------------------------------
MHEALTH <- OSTSC::MHEALTH()

train.label <- MHEALTH$train.y
train.sample <- MHEALTH$train.x
test.label <- MHEALTH$test.y
test.sample <- MHEALTH$test.x

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label)
over.sample <- MyData$sample
over.label <- MyData$label

table(over.label)

## ------------------------------------------------------------------------
library(keras)
train.y <- to_categorical(train.label)
test.y <- to_categorical(test.label)
train.x <- array(train.sample, dim = c(dim(train.sample),1)) 
test.x <- array(test.sample, dim = c(dim(test.sample),1)) 

## ---- eval=FALSE---------------------------------------------------------
#  model <- keras_model_sequential()
#  model %>%
#    layer_lstm(10, input_shape = c(dim(train.x)[2], dim(train.x)[3])) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_dense(dim(train.y)[2]) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_activation("softmax")
#  model %>% compile(
#    loss = "categorical_crossentropy",
#    optimizer = "adam",
#    metrics = "accuracy"
#  )
#  lstm.before <- model %>% fit(
#    x = train.x,
#    y = train.y,
#    validation_split = 0.2,
#    epochs = 200
#  )
#  plot(lstm.before)

## ---- echo=FALSE, message=FALSE------------------------------------------
lstm.before <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/Mhealth%20LSTM%20model%20saved/mhealth_before_e200.rdata')
pred.label <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/Mhealth%20LSTM%20model%20saved/mhealth_before_predlabel.rdata')

pred.label <- as.vector(unlist(pred.label))
plot(structure(class = "keras_training_history", list(params = lstm.before$params, metrics = lstm.before$metrics)))

## ------------------------------------------------------------------------
over.y <- to_categorical(over.label)
over.x <- array(over.sample, dim = c(dim(over.sample),1)) 

## ---- eval=FALSE---------------------------------------------------------
#  model.over <- keras_model_sequential()
#  model.over %>%
#    layer_lstm(10, input_shape = c(dim(over.x)[2], dim(over.x)[3])) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_dense(dim(over.y)[2]) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_activation("softmax")
#  model_over %>% compile(
#    loss = "categorical_crossentropy",
#    optimizer = "adam",
#    metrics = "accuracy"
#  )
#  lstm.after <- model.over %>% fit(
#    x = over.x,
#    y = over.y,
#    validation_split = 0.1,
#    epochs = 200
#  )
#  plot(lstm.after)

## ---- echo=FALSE, message=FALSE------------------------------------------
lstm.after <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/Mhealth%20LSTM%20model%20saved/mhealth_after_e200.rdata')
pred.label.over <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/Mhealth%20LSTM%20model%20saved/mhealth_after_predlabel.rdata')

pred.label.over <- as.vector(unlist(pred.label.over))
plot(structure(class = "keras_training_history", list(params = lstm.after$params, metrics = lstm.after$metrics)))

## ---- eval=FALSE---------------------------------------------------------
#  pred.label <- model %>% predict_classes(test.x)
#  pred.label.over <- model.over %>% predict_classes(test.x)

## ------------------------------------------------------------------------
cm.before <- table(test.label, pred.label)
cm.after <- table(test.label, pred.label.over)

## ---- echo=FALSE---------------------------------------------------------
layout(matrix(c(1,1,2)))
par(mar=c(2,2,2,2))
plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
title('Normalized Confusion Matrix (before oversampling)', cex.main=1.75)

rect(150, 430, 240, 370, col='#3F97D0')
rect(250, 430, 340, 370, col='#F7AD50')
rect(150, 305, 240, 365, col='#F7AD50')
rect(250, 305, 340, 365, col='#3F97D0')
text(195, 435, '0', cex=1.2)
text(295, 435, '1', cex=1.2)
text(125, 370, 'True', cex=1.3, srt=90, font=2)
text(245, 450, 'Predicted', cex=1.3, font=2)
text(140, 400, '0', cex=1.2, srt=90)
text(140, 335, '1', cex=1.2, srt=90)

res <- as.numeric(cm.before)
sum1 <- res[1] + res[3]
sum2 <- res[2] + res[4] 
text(195, 400, round(res[1]/sum1, 4), cex=1.6, font=2, col='white')
text(195, 335, round(res[2]/sum2, 4), cex=1.6, font=2, col='white')
text(295, 400, round(res[3]/sum1, 4), cex=1.6, font=2, col='white')
text(295, 335, round(res[4]/sum2, 4), cex=1.6, font=2, col='white')

layout(matrix(c(1,1,2)))
par(mar=c(2,2,2,2))
plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
title('Normalized Confusion Matrix (after oversampling)', cex.main=1.75)

rect(150, 430, 240, 370, col='#3F97D0')
rect(250, 430, 340, 370, col='#F7AD50')
rect(150, 305, 240, 365, col='#F7AD50')
rect(250, 305, 340, 365, col='#3F97D0')
text(195, 435, '0', cex=1.2)
text(295, 435, '1', cex=1.2)
text(125, 370, 'True', cex=1.3, srt=90, font=2)
text(245, 450, 'Predicted', cex=1.3, font=2)
text(140, 400, '0', cex=1.2, srt=90)
text(140, 335, '1', cex=1.2, srt=90)

res <- as.numeric(cm.after)
sum1 <- res[1] + res[3]
sum2 <- res[2] + res[4] 
text(195, 400, round(res[1]/sum1, 4), cex=1.6, font=2, col='white')
text(195, 335, round(res[2]/sum2, 4), cex=1.6, font=2, col='white')
text(295, 400, round(res[3]/sum1, 4), cex=1.6, font=2, col='white')
text(295, 335, round(res[4]/sum2, 4), cex=1.6, font=2, col='white')

## ---- warning=FALSE------------------------------------------------------
library(pROC)
plot.roc(as.vector(test.label), pred.label, legacy.axes = TRUE, col = "blue", 
         print.auc = TRUE, print.auc.cex= .8, xlab = 'False Positive Rate', 
         ylab = 'True Positive Rate', main="ROC MHEALTH")
plot.roc(as.vector(test.label), pred.label.over, legacy.axes = TRUE, col = "red", 
         print.auc = TRUE, print.auc.y = .4, print.auc.cex= .8, add = TRUE)
legend("bottomright", legend=c("Before Oversampling", "After Oversampling"), 
       col=c("blue", "red"), lwd=2, cex= .6)

## ------------------------------------------------------------------------
HFT <- OSTSC::HFT()

label <- HFT$y
sample <- HFT$x
train.label <- label[1:15000]
train.sample <- sample[1:15000, ]
test.label <- label[15001:30000]
test.sample <- sample[15001:30000, ]

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label)
over.sample <- MyData$sample
over.label <- MyData$label

## ------------------------------------------------------------------------
table(over.label)

## ------------------------------------------------------------------------
library(keras)
library(dummies)
train.y <- dummy(train.label)
test.y <- dummy(test.label)
train.x <- array(train.sample, dim = c(dim(train.sample),1)) 
test.x <- array(test.sample, dim = c(dim(test.sample),1)) 

## ---- eval=FALSE---------------------------------------------------------
#  model <- keras_model_sequential()
#  model %>%
#    layer_lstm(10, input_shape = c(dim(train.x)[2], dim(train.x)[3])) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_dense(dim(train.y)[2]) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_activation("softmax")
#  model %>% compile(
#    loss = "categorical_crossentropy",
#    optimizer = "adam",
#    metrics = "accuracy"
#  )
#  lstm.before <- model %>% fit(
#    x = train.x,
#    y = train.y,
#    validation_split = 0.1,
#    epochs = 200
#  )
#  plot(lstm.before)

## ---- echo=FALSE, message=FALSE------------------------------------------
lstm.before <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/HFT%20LSTM%20model%20saved/HFT_before_e200.rdata')
pred.label <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/HFT%20LSTM%20model%20saved/HFT_before_predlabel.rdata')

pred.label <- as.vector(unlist(pred.label))
plot(structure(class = "keras_training_history", list(params = lstm.before$params, metrics = lstm.before$metrics)))

## ------------------------------------------------------------------------
over.y <- dummy(over.label)
over.x <- array(over.sample, dim = c(dim(over.sample),1)) 

## ---- eval=FALSE---------------------------------------------------------
#  model.over <- keras_model_sequential()
#  model.over %>%
#    layer_lstm(10, input_shape = c(dim(over.x)[2], dim(over.x)[3])) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_dense(dim(over.y)[2]) %>%
#    layer_dropout(rate = 0.2) %>%
#    layer_activation("softmax")
#  model.over %>% compile(
#    loss = "categorical_crossentropy",
#    optimizer = "adam",
#    metrics = "accuracy"
#  )
#  lstm.after <- model.over %>% fit(
#    x = over.x,
#    y = over.y,
#    validation_split = 0.1,
#    epochs = 200
#  )
#  plot(lstm_after)

## ---- echo=FALSE, message=FALSE------------------------------------------
lstm.after <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/HFT%20LSTM%20model%20saved/HFT_after_e200.rdata')
pred.label.over <- rio::import('https://github.com/lweicdsor/GSoC2017/raw/master/HFT%20LSTM%20model%20saved/HFT_after_predlabel.rdata')

pred.label.over <- as.vector(unlist(pred.label.over))
plot(structure(class = "keras_training_history", list(params = lstm.after$params, metrics = lstm.after$metrics)))

## ---- eval=FALSE---------------------------------------------------------
#  pred.label <- model %>% predict_classes(test.x)
#  pred.label.over <- model.over %>% predict_classes(test.x)

## ------------------------------------------------------------------------
cm.before <- table(test.label, pred.label)
cm.after <- table(test.label, pred.label.over)

## ---- echo=FALSE---------------------------------------------------------
layout(matrix(c(1,1,2)))
par(mar=c(2,2,2,2))
plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
title('Normalized Confusion Matrix (before oversampling)', cex.main=1.75)

rect(140, 430, 200, 390, col='#3F97D0')
rect(210, 430, 270, 390, col='#F7AD50')
rect(280, 430, 340, 390, col='#F7AD50')
rect(140, 345, 200, 385, col='#F7AD50')
rect(210, 345, 270, 385, col='#3F97D0')
rect(280, 345, 340, 385, col='#F7AD50')
rect(140, 300, 200, 340, col='#F7AD50')
rect(210, 300, 270, 340, col='#F7AD50')
rect(280, 300, 340, 340, col='#3F97D0')
text(170, 435, '-1', cex=1.2)
text(240, 435, '0', cex=1.2)
text(310, 435, '1', cex=1.2)
text(130, 410, '-1', cex=1.2, srt=90)
text(130, 365, '0', cex=1.2, srt=90)
text(130, 320, '1', cex=1.2, srt=90)
text(120, 370, 'True', cex=1.3, srt=90, font=2)
text(240, 450, 'Predicted', cex=1.3, font=2)
  
res <- as.numeric(cm.before)
sum1 <- res[1] + res[4] + res[7]
sum2 <- res[2] + res[5] + res[8]
sum3 <- res[3] + res[6] + res[9]
text(170, 410, round(res[1]/sum1, 4), cex=1.6, font=2, col='white')
text(170, 365, round(res[2]/sum2, 4), cex=1.6, font=2, col='white')
text(170, 320, round(res[3]/sum3, 4), cex=1.6, font=2, col='white')
text(240, 410, round(res[4]/sum1, 4), cex=1.6, font=2, col='white')
text(240, 365, round(res[5]/sum2, 4), cex=1.6, font=2, col='white')
text(240, 320, round(res[6]/sum3, 4), cex=1.6, font=2, col='white')
text(310, 410, round(res[7]/sum1, 4), cex=1.6, font=2, col='white')
text(310, 365, round(res[8]/sum2, 4), cex=1.6, font=2, col='white')
text(310, 320, round(res[9]/sum3, 4), cex=1.6, font=2, col='white')

layout(matrix(c(1,1,2)))
par(mar=c(2,2,2,2))
plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
title('Normalized Confusion Matrix (after oversampling)', cex.main=1.75)

rect(140, 430, 200, 390, col='#3F97D0')
rect(210, 430, 270, 390, col='#F7AD50')
rect(280, 430, 340, 390, col='#F7AD50')
rect(140, 345, 200, 385, col='#F7AD50')
rect(210, 345, 270, 385, col='#3F97D0')
rect(280, 345, 340, 385, col='#F7AD50')
rect(140, 300, 200, 340, col='#F7AD50')
rect(210, 300, 270, 340, col='#F7AD50')
rect(280, 300, 340, 340, col='#3F97D0')
text(170, 435, '-1', cex=1.2)
text(240, 435, '0', cex=1.2)
text(310, 435, '1', cex=1.2)
text(130, 410, '-1', cex=1.2, srt=90)
text(130, 365, '0', cex=1.2, srt=90)
text(130, 320, '1', cex=1.2, srt=90)
text(120, 370, 'True', cex=1.3, srt=90, font=2)
text(240, 450, 'Predicted', cex=1.3, font=2)

res <- as.numeric(cm.after)
sum1 <- res[1] + res[4] + res[7]
sum2 <- res[2] + res[5] + res[8]
sum3 <- res[3] + res[6] + res[9]
text(170, 410, round(res[1]/sum1, 4), cex=1.6, font=2, col='white')
text(170, 365, round(res[2]/sum2, 4), cex=1.6, font=2, col='white')
text(170, 320, round(res[3]/sum3, 4), cex=1.6, font=2, col='white')
text(240, 410, round(res[4]/sum1, 4), cex=1.6, font=2, col='white')
text(240, 365, round(res[5]/sum2, 4), cex=1.6, font=2, col='white')
text(240, 320, round(res[6]/sum3, 4), cex=1.6, font=2, col='white')
text(310, 410, round(res[7]/sum1, 4), cex=1.6, font=2, col='white')
text(310, 365, round(res[8]/sum2, 4), cex=1.6, font=2, col='white')
text(310, 320, round(res[9]/sum3, 4), cex=1.6, font=2, col='white')

## ---- warning=FALSE------------------------------------------------------
library(pROC)
plot.roc(test.label, pred.label, legacy.axes = TRUE, col = "blue", print.auc = TRUE,  
         print.auc.cex= .8, xlab = 'False Positive Rate', ylab = 'True Positive Rate', 
         main="ROC HFT")
plot.roc(test.label, pred.label.over, legacy.axes = TRUE, col = "red", print.auc = TRUE,   
         print.auc.y = .4, print.auc.cex= .8, add = TRUE)
legend("bottomright", legend=c("Before Oversampling", "After Oversampling"), 
       col=c("blue", "red"), lwd=2, cex= .6)

