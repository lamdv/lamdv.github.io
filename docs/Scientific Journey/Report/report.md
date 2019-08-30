---
title: "Report on combining (Stack) C+T predictor"
author: "DANG Vu-Lam"
output:
  html_document:
    keep_md: true
editor_options: 
  chunk_output_type: inline
---


In this document I investigate multiple method to calculate PRS. Some of them are based on combining multiple C+T predictors to enhence the performance of C+T. They are based on the work of [Florian Privé](https://privefl.github.io/bigsnpr/articles/SCT.html). [^1]

## Methods

In this RMD documents there are 5 methods demonstrated:

- SCT
- XGBoost (with SCT $1^{st}$ layer)
- Lassosum
- Random Forest (with SCT $1^{st}$ layer)
- Neural Net (with SCT $1^{st}$ layer)

More promising (SCT, XGBoost, Lassosum, Random Forest) are place first, and Neural Net are included for reference.

For some reason I can not get Keras to work with SCT first layer (always return AUC of 0.5). This can either be a problem of the target function (I have yet to find a good function that operate well), or a bug within Keras (unlikely). Or perhap the Euclid distance after C+T layer are too small for neuralnet - that's why regression based method work better?

## Required packages:

- bigstatsr
- bigsnpr
- lassosum
- data.table
- xgboost
- ranger
- keras


```r
library(bigstatsr)
library(bigsnpr)
library(lassosum)
library(data.table)
library(xgboost)
library(ranger)
library(keras)
```

## Dataset

*Please change working direction in `directory`*

I use the "Simus" simulated dataset provided by Florian. This dataset contain ~650,000 SNPs in 2 chromosomes. 20% of them are cases and the rest 80% are controls.



```r
setwd(directory) 
# Train data
sumstats <- bigreadr::fread2(file_sumstat)
# snp_readBed(paste(file_train, "bed", sep='.'))
train <- snp_attach(paste(file_train, "rds", sep='.'))
G.train <- train$genotypes
CHR <- train$map$chromosome
POS <- train$map$physical.pos
NCORES <- nb_cores()
lpval <- -log10(sumstats$pval)
y.train <- train$fam$affection

# Test data
# snp_readBed(paste(file_test, "bed", sep='.'))
test <- snp_attach(paste(file_test, "rds", sep='.'))
G.test <- test$genotypes
# 
```

## C+T step
Generating a matrix of C+T with varied clumping radius and $p-value$ thresholds.

$\beta s$ and $p-values$ are aquired in sumstats file (see `sumstats.txt`)


```r
all_keep <- snp_grid_clumping(G.train, CHR, POS, lpval, ncores = NCORES)
PRS <-snp_grid_PRS(G.train,all_keep = all_keep, betas = sumstats$beta,lpval)
PRS_test <- snp_grid_PRS(G.test, all_keep = all_keep, betas = sumstats$beta,lpval)
```

Other than SCT, other methods require DataFrame or R Matrix than FBM to manage data. I converted the FBM output of C+T to DataFrame and change the corresponding columns.





## Data treatment: Oversampling

To oversampling I extract all positive (*affection = 1*), and append them a number of times. For this simulated dataset, I enhanced the number of cases 10 times, thus the ratio become ~70:30 (from 20:80).


```r
y_case <- which(train$fam$affection %in% c(1))
for (i in seq(1, 10)){
  y.train <- append(y.train, train$fam$affection[y_case])
  ds <- rbind(ds, PRS[y_case,])
}
ds.FBM <- as_FBM(ds)
```

## Method 1: SCT

No parameters required. Combining (Sparse Logistic Regression) C+T predictors for best result.


```r
# Reference
# M <- snp_grid_stacking(multi_PRS = ds.FBM, y.train = y.train, ncores = NCORES)
M <- snp_grid_stacking(multi_PRS = PRS, y.train = train$fam$affection)
beta <- as_FBM(matrix(M$beta.G))
pred.SCT <- big_prodMat(G.test, beta)
#AUC(pred = pred.SCT, test$fam$affection)
```

```r
AUC(pred = pred.SCT, test$fam$affection)
```

```
## [1] 0.7816448
```

## Method 2: XGBoost

XGBoost provide slightly better result compare to SCT. However this result heavily depend on booster and objective selection. Experiments shown that **gblinear** booster with **count:poisson** objective give the best results.

For experimentation, I run 9 different *max_depth* and 9 *nrounds*. Each combination is repeated 10 times and the mean value calculated to rule out the randomess of *gblinear* booster

```r
AUCs <- matrix(,nrow = 10, ncol = 10)
for (i in seq(2 : 10)){
  for (j in seq(2: 10)) {
    temp <- c()
    for(t in seq(1:10)){
      bstSparse <- xgboost(data = ds[], 
                           label = y.train, 
                           booster="gblinear",
                           max_depth = i, 
                           eta = 1, 
                           nthread = 2, 
                           nrounds = j, 
                           lambda = 0.1,
                           objective = "count:poisson"
                           )
      pred <- predict(bstSparse, PRS_test[])
      temp <- append(temp,AUC(pred = pred, test$fam$affection))
    }
    AUCs[i,j] <- mean(temp)
  }
}
```

```r
AUCs
```

```
##            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
##  [1,] 0.7810081 0.7814691 0.7819848 0.7820644 0.7821634 0.7819551
##  [2,] 0.7815161 0.7816789 0.7819097 0.7820451 0.7820130 0.7820510
##  [3,] 0.7811385 0.7817903 0.7820209 0.7821792 0.7821172 0.7820448
##  [4,] 0.7812592 0.7814580 0.7820362 0.7819456 0.7820135 0.7819257
##  [5,] 0.7811024 0.7814672 0.7818094 0.7819867 0.7820772 0.7820431
##  [6,] 0.7813253 0.7816065 0.7818425 0.7822446 0.7821884 0.7819205
##  [7,] 0.7810239 0.7817146 0.7817587 0.7819281 0.7822180 0.7819721
##  [8,] 0.7811480 0.7820816 0.7818343 0.7820383 0.7820944 0.7819818
##  [9,] 0.7815687 0.7814758 0.7816728 0.7818929 0.7820611 0.7820187
## [10,]        NA        NA        NA        NA        NA        NA
##            [,7]      [,8]      [,9] [,10]
##  [1,] 0.7817276 0.7816945 0.7814971    NA
##  [2,] 0.7819033 0.7817853 0.7816005    NA
##  [3,] 0.7818634 0.7816886 0.7814594    NA
##  [4,] 0.7819806 0.7818078 0.7813999    NA
##  [5,] 0.7818562 0.7816829 0.7814363    NA
##  [6,] 0.7819113 0.7817263 0.7814301    NA
##  [7,] 0.7818913 0.7817029 0.7815198    NA
##  [8,] 0.7819087 0.7816597 0.7814085    NA
##  [9,] 0.7817407 0.7817544 0.7815585    NA
## [10,]        NA        NA        NA    NA
```

```r
boxplot(AUCs)
```

![](report_fig/result_xgboost-1.png)<!-- -->

## Method 3: Lassosum

Lassosum use L1 regularization to better fit the regression model.

For basic L1 regularization of Linear Regression, 2 metaparameters are required: a learning rate $\alpha$ and a regularization parameter $\lambda$. However, *lassosum* does not require these parameters, as the software automatically scan the parameters space and select the best $\alpha$ and $\lambda$


```r
setwd(directory) 
cor <- p2cor(p = sumstats$pval, n = 8000, sign=sumstats$beta)

out <- lassosum.pipeline(cor =cor, chr=sumstats$chromosome, pos = sumstats$physical.pos, 
                         A1 = sumstats$allele1, A2 = sumstats$allele2,
                         ref.bfile = file_train, test.bfile = file_test,
                         LDblocks = LDblocks)

v <- validate(out)

out2 <- subset(out, s=v$best.s, lambda = v$lambda)
v2 <- validate(out2)
v2$best.validation.result
```

```r
AUC(v$best.pgs, v$pheno)
```

```
## [1] 0.7308175
```

## Method 4: Random Forest

Random forest also give good AUC (above 70%, but less than other methods except for *keras*). The result highly dependen on the number of trees (more trees equals more convergence), and the learning rate also contribute to an lesser extend.

The code in this session will sweep through the parameters: 1 to 10 trees and alpha from 0.1 to 1 (0.1 increment).

```r 
PRS_test.df <- as.data.frame(PRS_test[])

f <- as.formula(paste("y ~", paste(cols[!cols %in% "PRS.df"], collapse = " + ")))

for (j in seq(1 : 10)){
  for (i in seq(1: 10)) {
    rf <- ranger(f, data = PRS.df, num.trees = j*100, verbose = TRUE, write.forest = TRUE, alpha = (i/10))
    pred <- predict(rf, PRS_test.df)
    AUCs[i,j] <- AUC(pred = pred$predictions, test$fam$affection)
  }
}
```

```r
AUCs
```

```
##            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
##  [1,] 0.7532205 0.7535048 0.7564268 0.7501722 0.7507132 0.7515333
##  [2,] 0.7440113 0.7530198 0.7540833 0.7532506 0.7518778 0.7546351
##  [3,] 0.7545732 0.7500895 0.7514272 0.7556325 0.7545590 0.7539930
##  [4,] 0.7549227 0.7515300 0.7500226 0.7548174 0.7503537 0.7543692
##  [5,] 0.7488554 0.7515392 0.7508904 0.7535265 0.7544863 0.7536828
##  [6,] 0.7501346 0.7512984 0.7525976 0.7547204 0.7520592 0.7536302
##  [7,] 0.7496137 0.7509414 0.7527130 0.7549386 0.7512415 0.7553466
##  [8,] 0.7435724 0.7513862 0.7545431 0.7513971 0.7525416 0.7559703
##  [9,] 0.7513695 0.7512825 0.7537756 0.7543274 0.7507516 0.7562646
## [10,] 0.7473798 0.7476314 0.7535859 0.7539036 0.7543751 0.7537062
##            [,7]      [,8]      [,9]     [,10]
##  [1,] 0.7541560 0.7521771 0.7544930 0.7532481
##  [2,] 0.7547923 0.7526261 0.7558700 0.7539353
##  [3,] 0.7526620 0.7529212 0.7531896 0.7540800
##  [4,] 0.7532573 0.7556534 0.7528978 0.7538868
##  [5,] 0.7518979 0.7547931 0.7558106 0.7535190
##  [6,] 0.7544119 0.7547555 0.7558792 0.7548132
##  [7,] 0.7524614 0.7543283 0.7537857 0.7549896
##  [8,] 0.7533702 0.7535374 0.7533777 0.7520208
##  [9,] 0.7569953 0.7558482 0.7558123 0.7530600
## [10,] 0.7538342 0.7547547 0.7521612 0.7539888
```

```r
boxplot(AUCs)
```

![](report_fig/result_rf-1.png)<!-- -->

## Method 5: Nerual net (Keras)

For some reason, *keras* cannot return good result; the prediction always biased to controls. Even with adjusted weights and oversampling, the bias is still there and AUC is always $0.5$. I included it here in case I figure it out in the future.

In this example, I put a 10:1 weight ratio between case and control.


```r
y.train <- train$fam$affection

model <- keras_model_sequential() 
model %>%
 layer_dense(units = 1000, activation = "softmax", input_shape = c(ncol(ds)), kernel_regularizer=regularizer_l1(0.02)) %>%
 # layer_dense(units = 1000, activation = "softmax", input_shape = c(2800)) %>%
 # layer_dropout(rate=0.1) %>%
 layer_dense(units = 2, activation = "softmax", kernel_regularizer=regularizer_l1(0.01))

model %>% compile(
 #loss = 'categorical_crossentropy',
 loss = 'mean_absolute_percentage_error',
 optimizer = 'SGD',
 metrics = c('accuracy')
)
y.train <-  to_categorical(y.train)

history <- model$fit(
 ds, y.train,
 class_weight = list(1, 10),
 epochs = as.integer(10), 
 batch_size = as.integer(28)
)
AUC(predict_classes(model, PRS_test[]), test$fam$affection)
```

```
## [1] 0.5
```

[^1]: Original Rmd documment provided [here](https://github.com/lamdv/Script/blob/master/Report/report.rmd)