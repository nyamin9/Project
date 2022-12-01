
## 앒서 가정 검증을 통해 다중공선성을 제거하였다.
## 모델 생성 후 잔차들의 분산과 더빈왓슨 검정을 통해 잔차의 등분산성 가정과 자기상관 가정을 확인할 것이다.
## 또한 잔차 플롯과 QQ plot을 통해 잔차의 분포를 확인하고, 잔차의 정규성을 확인할 것이다.  

## 앞선 몇몇 모델의 테스트 결과 오차의 자기상관 제거를 위한 방법으로 차분이 유의하지 않음을 확인하였다.
## 따라서 과거값을 이용한 새로운 변수를 만들어 자기상관을 낮출 것이다.

##################################################################################################
############ 과거값을 사용한 새로운 변수를 만들어 자기상관을 낮춰보도록 한다. ####################
##################################################################################################

########################################################### TEST 1
par(mfrow = c(1,1))

testy <- data$priceindex
testinterest <- c(NA,NA,NA, data$interest[1:45])
testlngoods <- data$lngoods
testlnexchange <- c(NA, data$lnexchange[1:47])
testlnoil <- c(NA, data$lnoil[1:47])
testlnKOSPI <- data$lnKOSPI            
testCOVID <- c(NA,NA, data$COVID[1:46])
testtime <- data$time

test <- data.frame(testy, testinterest, testlnexchange, testlnoil, testlnKOSPI, testCOVID)
test$COVID_OX <- ifelse(test$testCOVID==0, test$COVID_OX <- 0, test$COVID_OX <- 1)

modeltest <- lm(testy ~ testinterest + testlnexchange + testlnoil + testlnKOSPI + testCOVID-1, data = test)

summary(modeltest)
acf(modeltest$residuals)
dwtest(modeltest)
### dwtest 결과 p-value가 0.03으로 귀무가설을 기각한다.
### 자기상관 문제를 해결하지 못했다.

par(mfrow = c(2,4))
plot(data$priceindex, type = 'l')
plot(data$interest, type = 'l')
plot(data$lngoods, type = 'l')
plot(data$lnexchange, type = 'l')
plot(data$lnoil, type = 'l')
plot(data$lnKOSPI, type = 'l')
plot(data$COVID, type = 'l')



########################################################### TEST 2

testy <- data$priceindex
testinterest <- c(NA,NA,NA, data$interest[1:45])
testlngoods <- c(NA,NA, data$lngoods[1:46])   
testlnexchange <- c(NA, data$lnexchange[1:47])
testlnoil <- c(NA, data$lnoil[1:47])
testlnKOSPI <- data$lnKOSPI            
testCOVID <- c(NA,NA, data$COVID[1:46])
testtime <- data$time


test <- data.frame(testy, testinterest, testlnexchange, testlngoods, testlnKOSPI, testCOVID, testlnoil)
test$COVID_OX <- ifelse(test$testCOVID==0, test$COVID_OX <- 0, test$COVID_OX <- 1)

modeltest <- lm(testy ~  testinterest + testinterest:(testCOVID) + testlnexchange + testlnoil + testlnKOSPI -1, data = test)


summary(modeltest)
acf(modeltest$residuals)
dwtest(modeltest)
### dwtest 결과 p-value가 0.04으로 귀무가설을 기각한다.
### 자기상관 문제를 해결하지 못했다.
AIC(modeltest)



########################################################### TEST 3
testy2 <- data$priceindex
testlnoil2 <- c(NA, data$lnoil[1:47])
testlnKOSPI2 <- data$lnKOSPI
testCOVID2 <- c(NA,NA, data$COVID[1:46]) 
testtime2 <- data$time

test2 <- data.frame(testy2, testlnoil2,testlnKOSPI2,testCOVID2,testtime2)
modeltest2 <- lm(testy2 ~ testlnoil2 + testlnKOSPI2 + testCOVID2 + testtime2, data = test2)


summary(modeltest2)
par(mfrow=c(1,1))
acf(modeltest2$residuals)
dwtest(modeltest2)
### dwtest 결과 p-value가 0.001로 귀무가설을 기각한다.
### 자기상관 문제를 해결하지 못했다.



########################################################### FINAL TEST
######################### 🏆 최종모델 🏆 #############################
######################################################################

final_target <- data$priceindex
final_interest <- c(NA, data$interest[1:47])
final_lngoods <- c(NA,NA,NA, data$lngoods[1:45])       
final_lnexchange <- c(NA, data$lnexchange[1:47])
final_lnoil <- c(NA, data$lnoil[1:47])
final_lnKOSPI <- data$lnKOSPI            
final_COVID <-  data$COVID 
final_time <- data$time


final <- data.frame(final_target, final_interest, final_lnexchange, final_lngoods, final_lnKOSPI, final_COVID, final_lnoil, final_time)

final$COVID_OX <- ifelse(final$final_COVID==0, final$COVID_OX <- 0, final$COVID_OX <- 1)
final$COVID_OX <- c(NA, final$COVID_OX[1:47])

model_final <- lm(final_target ~ final_interest:(final_COVID) + final_lnexchange:(COVID_OX) + final_lnoil + final_lnexchange + final_lnKOSPI, data = final)

summary(model_final)
acf(model_final$residuals)
dwtest(model_final)
### dwtest 결과 p-value가 0.08으로 귀무가설을 기각하지 못한다.
### 자기상관 문제를 해결하였다. 

AIC(model_final)

par(mfrow = c(2,2))
plot(model_final)


################################################## 독립변수의 설명력 시각화

relweights <- function(fit, col){
  R <- cor(fit$model)
  nvar <- ncol(R)
  rxx <- R[2:nvar, 2:nvar]
  rxy <- R[2:nvar, 1]
  svd <- eigen(rxx)
  evec <- svd$vectors
  ev <- svd$values
  delta <- diag(sqrt(ev))
  lambda <- evec %*% delta %*% t(evec)
  lambdasq <- lambda^2
  beta <- solve(lambda) %*% rxy
  rsquare <- colSums(beta^2)
  rawwgt <- lambdasq %*% beta ^ 2
  import <- (rawwgt / rsquare) * 100
  import <- as.data.frame(import)
  row.names(import) <- names(fit$model[2:nvar])
  names(import) <- "Weights"
  import <- import[order(import),1,drop = FALSE]
  dotchart(import$Weights, labels = row.names(import),
           xlab = "% of R-square", pch = 19,
           main = "Relative Importance of predictor Variables",
           sub = paste("Total R-square=", round(rsquare, digits = 3)),
           col = col)
  
  return(import)
}

result = relweights(model_final, 'blue')
result


library(ggplot2)
plotRelWeights <- function(fit, col){
  data <- relweights(fit, col)
  data$Predictors <- rownames(data)
  p <- ggplot(data = data, aes(x=reorder(Predictors, Weights), y = Weights, fill=Predictors))+
    geom_bar(stat = 'identity',width = 0.5)+
    ggtitle("Relative Importance of predictor Variables")+
    ylab(paste0("% of R-square \n(Total R-square = ",attr(data, "R-square"),")"))+
    geom_text(aes(y=Weights-0.1, label=paste(round(Weights,1),"%")), hjust=1)+
    guides(fill=FALSE)+
    coord_flip()
  
  p
}

plotRelWeights(model_final, 'blue')

## 물가지수를 예측하기 위해서는 코스피가 가장 설명력이 높은 독립변수였지만, 가장 큰 영향을 미치는 독립변수는 estimate이 가장 큰 환율이었다.
