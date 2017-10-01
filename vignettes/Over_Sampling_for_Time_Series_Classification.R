## ---- echo=FALSE, message=FALSE------------------------------------------
require(OSTSC)
require(keras)
require(rio)
require(dummies)
require(pROC)

## ------------------------------------------------------------------------
library(OSTSC)
data(Dataset_Synthetic_Control)

train.label <- Dataset_Synthetic_Control$train.y
train.sample <- Dataset_Synthetic_Control$train.x
test.label <- Dataset_Synthetic_Control$test.y
test.sample <- Dataset_Synthetic_Control$test.x

## ------------------------------------------------------------------------
dim(train.sample)

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label, parallel = FALSE)
over.sample <- MyData$sample
over.label <- MyData$label

## ------------------------------------------------------------------------
table(over.label)

## ------------------------------------------------------------------------
dim(over.sample)

## ------------------------------------------------------------------------
data(Dataset_Adiac)

train.label <- Dataset_Adiac$train.y
train.sample <- Dataset_Adiac$train.x
test.label <- Dataset_Adiac$test.y
test.sample <- Dataset_Adiac$test.x

## ------------------------------------------------------------------------
dim(train.sample)

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label, parallel = FALSE)
over.sample <- MyData$sample
over.label <- MyData$label

## ------------------------------------------------------------------------
table(over.label)

## ------------------------------------------------------------------------
data(Dataset_HFT)

train.label <- Dataset_HFT$y
train.sample <- Dataset_HFT$x

## ------------------------------------------------------------------------
dim(train.sample)

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label, parallel = FALSE)
over.sample <- MyData$sample
over.label <- MyData$label

## ------------------------------------------------------------------------
table(over.label)

## ------------------------------------------------------------------------
data(Dataset_MHEALTH_Check)

train.label <- Dataset_MHEALTH_Check$train.y
train.sample <- Dataset_MHEALTH_Check$train.x
test.label <- Dataset_MHEALTH_Check$test.y
test.sample <- Dataset_MHEALTH_Check$test.x

## ------------------------------------------------------------------------
dim(train.sample)

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label, parallel = FALSE)
over.sample <- MyData$sample
over.label <- MyData$label

table(over.label)

## ------------------------------------------------------------------------
library(keras)
train.y <- to_categorical(train.label)
test.y <- to_categorical(test.label)
train.x <- array(train.sample, dim = c(dim(train.sample),1)) 
test.x <- array(test.sample, dim = c(dim(test.sample),1)) 

## ---- results='hide'-----------------------------------------------------
model <- keras_model_sequential()
model %>%
  layer_lstm(10, input_shape = c(dim(train.x)[2], dim(train.x)[3])) %>%
  layer_dropout(rate = 0.2) %>% 
  layer_dense(dim(train.y)[2]) %>%
  layer_dropout(rate = 0.2) %>% 
  layer_activation("softmax")
model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = "adam", 
  metrics = "accuracy"
)
lstm.before <- model %>% fit( 
  x = train.x, 
  y = train.y, 
  validation_split = 0.2,
  epochs = 50
)
plot(lstm.before)

## ------------------------------------------------------------------------
score <- model %>% evaluate(test.x, test.y)

## ---- echo=FALSE---------------------------------------------------------
cat("The loss value is", unlist(score[1]), ".\n")
cat("The metric value (in this case 'accuracy') is", unlist(score[2]), ".\n")

## ------------------------------------------------------------------------
over.y <- to_categorical(over.label)
over.x <- array(over.sample, dim = c(dim(over.sample),1)) 

## ---- results='hide'-----------------------------------------------------
model.over <- keras_model_sequential()
model.over %>%
  layer_lstm(10, input_shape = c(dim(over.x)[2], dim(over.x)[3])) %>%
  layer_dropout(rate = 0.1) %>% 
  layer_dense(dim(over.y)[2]) %>%
  layer_dropout(rate = 0.1) %>% 
  layer_activation("softmax")
model.over %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = "adam", 
  metrics = "accuracy"
)
lstm.after <- model.over %>% fit( 
  x = over.x, 
  y = over.y, 
  validation_split = 0.2,
  epochs = 50
)
plot(lstm.after)

## ------------------------------------------------------------------------
score.over <- model.over %>% evaluate(test.x, test.y)

## ---- echo=FALSE---------------------------------------------------------
cat("The loss value is", unlist(score.over[1]), ".\n")
cat("The metric value (in this case 'accuracy') is", unlist(score.over[2]), ".\n")

## ------------------------------------------------------------------------
pred.label <- model %>% predict_classes(test.x)
pred.label.over <- model.over %>% predict_classes(test.x)

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
plot.roc(as.vector(test.label), pred.label, legacy.axes = TRUE, col = "blue", print.auc = TRUE,  
         print.auc.cex= .8, xlab = 'False Positive Rate', ylab = 'True Positive Rate', 
         main="ROC MHEALTH Checking")
plot.roc(as.vector(test.label), pred.label.over, legacy.axes = TRUE, col = "red", print.auc = TRUE,   
         print.auc.y = .4, print.auc.cex= .8, add = TRUE)
legend("bottomright", legend=c("Before Oversampling", "After Oversampling"), 
       col=c("blue", "red"), lwd=2, cex= .6)

## ------------------------------------------------------------------------
data(Dataset_HFT_Check)

label <- Dataset_HFT_Check$y
sample <- Dataset_HFT_Check$x

train.label <- label[1:2000]
train.sample <- sample[1:2000, ]
test.label <- label[2001:3000]
test.sample <- sample[2001:3000, ]

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label, parallel = FALSE)
over.sample <- MyData$sample
over.label <- MyData$label

table(over.label)

## ------------------------------------------------------------------------
library(keras)
train.y <- to_categorical(train.label)
test.y <- to_categorical(test.label)
train.x <- array(train.sample, dim = c(dim(train.sample),1)) 
test.x <- array(test.sample, dim = c(dim(test.sample),1)) 

## ---- results='hide'-----------------------------------------------------
model <- keras_model_sequential()
model %>%
  layer_lstm(10, input_shape = c(dim(train.x)[2], dim(train.x)[3])) %>%
  layer_dropout(rate = 0.2) %>% 
  layer_dense(dim(train.y)[2]) %>%
  layer_dropout(rate = 0.2) %>% 
  layer_activation("softmax")
model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = "adam", 
  metrics = "accuracy"
)
lstm.before <- model %>% fit( 
  x = train.x, 
  y = train.y, 
  validation_split = 0.2,
  epochs = 50
)
plot(lstm.before)

## ------------------------------------------------------------------------
score <- model %>% evaluate(test.x, test.y)

## ---- echo=FALSE---------------------------------------------------------
cat("The loss value is", unlist(score[1]), ".\n")
cat("The metric value (in this case 'accuracy') is", unlist(score[2]), ".\n")

## ------------------------------------------------------------------------
over.y <- to_categorical(over.label)
over.x <- array(over.sample, dim = c(dim(over.sample),1)) 

## ---- results='hide'-----------------------------------------------------
model.over <- keras_model_sequential()
model.over %>%
  layer_lstm(10, input_shape = c(dim(over.x)[2], dim(over.x)[3])) %>%
  layer_dropout(rate = 0.1) %>% 
  layer_dense(dim(over.y)[2]) %>%
  layer_dropout(rate = 0.1) %>% 
  layer_activation("softmax")
model.over %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = "adam", 
  metrics = "accuracy"
)
lstm.after <- model.over %>% fit( 
  x = over.x, 
  y = over.y, 
  validation_split = 0.2,
  epochs = 50
)
plot(lstm.after)

## ------------------------------------------------------------------------
score.over <- model.over %>% evaluate(test.x, test.y)

## ---- echo=FALSE---------------------------------------------------------
cat("The loss value is", unlist(score.over[1]), ".\n")
cat("The metric value (in this case 'accuracy') is", unlist(score.over[2]), ".\n")

## ------------------------------------------------------------------------
pred.label <- model %>% predict_classes(test.x)
pred.label.over <- model.over %>% predict_classes(test.x)

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
plot.roc(as.vector(test.label), pred.label, legacy.axes = TRUE, col = "blue", print.auc = TRUE,  
         print.auc.cex= .8, xlab = 'False Positive Rate', ylab = 'True Positive Rate', 
         main="ROC HFT Checking")
plot.roc(as.vector(test.label), pred.label.over, legacy.axes = TRUE, col = "red", print.auc = TRUE,   
         print.auc.y = .4, print.auc.cex= .8, add = TRUE)
legend("bottomright", legend=c("Before Oversampling", "After Oversampling"), 
       col=c("blue", "red"), lwd=2, cex= .6)

## ------------------------------------------------------------------------
data(Dataset_MHEALTH_Eval)

train.label <- Dataset_MHEALTH_Eval$train.y
train.sample <- Dataset_MHEALTH_Eval$train.x
test.label <- Dataset_MHEALTH_Eval$test.y
test.sample <- Dataset_MHEALTH_Eval$test.x

## ------------------------------------------------------------------------
table(train.label)

## ---- results='hide'-----------------------------------------------------
MyData <- OSTSC(train.sample, train.label, parallel = FALSE)
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

