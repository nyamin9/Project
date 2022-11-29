# 8가지 가정 검정
# 독립변수 간 상관계수 계산(가정6 확인)

data_cor <- data %>% select(-c("시점","물가지수"))
data_cor <- cor(data_cor)
#install.packages("corrplot")
library(corrplot)
corrplot(data_cor)

## 강한 양의 상관관계 : 무역수지-상품수지, 경상수지-상품수지, 경상수지-무역수지, COFIX금리-기준금리
## 강한 음의 상관관계 : 없음

### 다중공선성을 제거하기 위해 무역수지, 상품수지, 경상수지 중 하나만 사용하기로 결정하며, 상품수지만을 남기기로 하였다.
### 다중공선성을 제거하기 위해 COFIX금리와 기준금리 중 기준금리를 이용하기로 하였다.

data <- data %>% select(-c("무역수지","경상수지","COFIX금리"))

############################################################################################
## 1) 가정1 : 변수 Y와 X의 관계는 선형(Linear)이다.
## > 잔차, scatter plot으로 확인 가능(모형 설정 후 확인)

## 2) 가정2 : X는 확률변수가 아닌 주어진 상수값이다.
## > 그냥 받아들인다.

## 3) 가정3 : X값이 주어져 있을 때, 오차항의 평균은 0이다.
## > 오차는 검증할 수 없기 때문에, 잔차를 통해 오차를 검증한다.
## > 잔차 plot으로 확인 (모형 설정 후 확인)

## 4) 가정4 : X값이 주어져 있을때, 오차항의 분산은 시그마^2 로 모든 개체 i에 대해 동일하다.
## > 잔차 plot으로 확인, 로그변환으로 해결(모형 설정 후 확인)

## 5) 가정5 : 서로 다른 개체간 오차항들은 상관되어있지 않다.
## > 오차항의 자기상관 문제(모형 설정 후 확인) 
## -> 잔차의 time plot / 잔차의 autocorrelation function / 더빗왓슨 검정 으로 확인
## -> 시게열 가변수 추가 / 과거 독립변수값을 새로운 독립변수로 추가 / 변수변환 - 차분

## 6) 가정6 : X변수들이 여러 개 있을 때, X변수들 사이에는 선형관계가 없다
## > 다중공선성 문제가 없음을 가정
## > 높은 독립변수 간 상관계수 / 높은 R-square값, 그러나 유의하지 않은 t값
## > 상관계수가 높은 독립변수 제거

## 7) 가정7 : 모형 설정 오류가 없음
## > 그냥 받아들인다.

## 8) 가정8 : 오차항은 정규분포를 따름을 가정(모형 설정 후 확인)
## > 잔차의 Histogram과 Normal qq plot이 Plot1과 같음을 확인

## 가정 1,3,4,5,8는 모형 설정 후 진단한다.

#######################################################################################################/
# 시계열 데이터로 만들기
data$time <- c(1:48) # time 변수 만들기 #
data <- data %>% select(c("interest","lngoods","priceindex","lnexchange","lnoil","lnKOSPI","COVID","time"))
data_ts <- ts(data, frequency = 12, start=c(2018,1))
plot(data_ts,type="p")
# 분산이 점차 커지는 변수가 많으므로, 로그 변환하기로 결정을 내렸다.

#################
## 변수명 변경 ##
#################
data$interest <- data$기준금리
data$lngoods <- log(data$상품수지)
data$priceindex <- data$물가지수
data$lnexchange <- log(data$환율)
data$lnoil <- log(data$유가)
data$lnKOSPI <- log(data$KOSPI)
str(data)
## 종속변수인 물가지수는 비율(%)이므로 로그변환을 하지 않는다.
## 로그변환이 가능한 독립변수는 로그변환 시킨다.
## 비율 기준 금리는 제외하고 진행한다.
## COVID는 0을 포함하기 때문에 로그변환을 하지 않는다.

# 로그 변환 후 상관계수 확인
data_cor <- data %>% select(c("interest","lngoods","priceindex","lnexchange","lnoil","lnKOSPI","COVID"))
data_cor <- cor(data_cor)
corrplot(data_cor)

# 종속변수와 각 독립변수의 그래프 확인
data_ts <- ts(data, frequency = 12, start=c(2018,1))
par(mfrow=c(2,3))
plot(interest~priceindex, data=data_ts)
plot(lngoods~priceindex, data=data_ts)
plot(lnexchange~priceindex, data=data_ts)
plot(lnoil~priceindex, data=data_ts)
plot(lnKOSPI~priceindex, data=data_ts)
plot(COVID~priceindex,data=data_ts)
par(mfrow=c(1,1))

#########################################################################################################

##### 기본 다중회귀 모형
model1 <- lm(priceindex~interest+lngoods+lnexchange+lnoil+lnKOSPI+COVID, data=data_ts)
summary(model1)
## lngoods의 p-value가 유의하지 않으므로 제거한다.

model2 <- lm(priceindex~interest+lnexchange+lnoil+lnKOSPI+COVID, data=data_ts)
summary(model2)
## 절편의 p-value가 유의하지 않으므로 제거한다.

model3 <- lm(priceindex~interest+lnexchange+lnoil+lnKOSPI+COVID-1, data=data_ts)
summary(model3)
## 각 독립변수는 p-value가 유의하고 모형의 R-square는 100%의 설명력을 가진다.(우리 모형에서 절편을 제거했을 때 생기는 문제점, 한계)

#########################################################################################################

# 잔차 검정(가정 3,4,5,6,8 진단한다.)
#####################
## 시계열 회귀분석 ##
#####################
# 가정 5번째를 반드시 체크를 해야한다. 
# 서로 다른 개체간 오차항들은 상관되어 있지 않다. = 자기 상관(autocorrelation)
# 오차항의 자기상관 문제는 시계열 자료에서 발생한다.
# 자기상관이 없을 순 없다. 그럼에도 회귀분석을 함
# x변수 자체도 시계열 변수이기 때문이다.
# y가 상관되어 있지 않다가 아닌 "오차항"이 상관되어 있지 않다.
# x자기상관, y자기상관은 상관없다. 잔차에 자기상관이 남아있으면 조치를 취해야 함.

# y_hat residual에서 분산이 커지면 log취함
# 이자율의 단위가 퍼센트이기 때문에 log취하면 퍼센트 증가로 바뀐다. 단위가 비율이면 로그를 취하지 않는다.

############################################################################################
# 오차에 자기상관이 남아있을 수 있다.
# 확인하는 세 가지 방법 : 세 가지 다 봐야한다.
# 1) 잔차의 time plot : x축 yhat ,y축 residual로는 못 본다. x축이 time이여야 볼 수 있다.
# 2) 잔차의 autocorrealtion function
# 3) 더빈왓슨 검정


## 1) 잔차의 time plot
# 원래 잔차는 연결하면 안 된다. 원래 잔차는 행의 위치가 바뀌어도 상관이 없다.
# 그러나 time data는 행 순서가 바뀔 수 없다. 시간에 흐름에 따라 순서도 자료이다.
par(mfrow=c(1,1))
plot(model3$residuals, type="l") # both : type='b', line : type='l'
abline(h=0, col="red")

# 자기상관이 없으면 랜덤하게 있어야 한다.
# 자기 상관이 있으면 - -> -, + -> + 내려와있다가 올라와있다.
# 자기 상관이 없다고 판단된다.

## 2) 잔차의 자기상관도표(ACF) : 잔차의 자기상관계수 계산
## 특별한 패키지가 필요하지 않다.
acf(model3$residuals, main="ACF", lag.max=24)

## 1차 상관계수, 2차 상관계수
# 파란색 안으로 들어와 있다 = 자기상관 없다. 
# monthly 데이터에서 1년 전 데이터, 계절성이 있을 수 있다. 적어도 24까지는 봐야한다.
# 옵션으로 계절성 확인하자.
### but 1차 자기상관계수, 15차 자기상관계수가 유의미한게 있다.

## 3) 더빈왓슨 검정
## 1차 자기상관이 0이면 2에 가까운 값을 갖는다.
## 1차 자기상관이 positive correlation 이면 0이고,
## 1차 자기상관이 negative correlation 이면 4이다.
## 2에 가까울수록 문제가 없는 것이다.

## DW test ##
#install.packages("lmtest")
library(lmtest)
dwtest(model3)

## 귀무가설 : 자기상관이 없다. d=2
## p-value 작다. H0 기각, 자기상관이 있다.
## 내가 바라는 건 p-value > 0.05이기 바란다.

## 결과 값을 보면 4.423e-05로 <0.05, 자기상관이 있다.
## DW만 보면 안되는 이유는 1차 자기상관만 확인가능하기 때문이다.
## something special : 계절성 확인 어렵다.
## 그래서 ACF까지도 같이 확인해야 한다.
## ACF는 다 보여주는 것
############################################################################################

##############################
## 오차의 자기상관 해결방법 ##
##############################

# 1) 독립변수 추가 : 시계열 가변수 추가

## 자기상관이 생기는 이유 : 추세, 계절성, 순환(cycle)
## 1) 추세 : 증가하는 추세, 독립변수에 추세(t, t^2)를 넣어줌으로 해결(가짜변수) 한 달 지날때마다 저만큼 증가한다는 의미.

## 2) 계절을 반영하는 가변수(dummy variable)을 모형에 독립변수로 추가한다.
##    > x: time, y:y변수 plot을 통해 계절성을 확인하자. dummy 12개 넣고 유의미하지 않은 dummy는 지운다.
##    > 가짜변수를 많이 넣어 R square의 설명력을 높이면 prediction 예측할 때 유리

## 3) 순환효과를 설명하는 삼각함수항을 추가한다.
##    > 사인과 코사인을 같이 넣어서 주기를 맞춘다. 고정폭, 확산폭

plot(priceindex ~ time, data=data_ts)
# 시간에 따라 증가하는 추세가 있어보인다.

# 1) 추세 확인을 위한 time 변수 추가
model3 <- lm(priceindex~interest+lnexchange+lnoil+lnKOSPI+COVID-1, data=data_ts)

modelwithtrend1 <- lm(priceindex~interest+lnexchange+lnoil+lnKOSPI+COVID+time-1, data=data_ts)
summary(modelwithtrend1)

modelwithtrend2 <- lm(priceindex~lnexchange+lnoil+lnKOSPI+COVID+time-1, data=data_ts)
summary(modelwithtrend2)

par(mfrow=c(1,2))
acf(modelwithtrend2$residuals,main="with t")
acf(model2$residuals, main="without t")

dwtest(model2) ; dwtest(modelwithtrend2)
## dwtest 결과 time변수를 추가하여도 여전히 낮은 p-value를 취한다.
## 따라서 time 변수는 추가하지 않는다.


# 2) 독립변수의 과거값을 새로운 독립변수로 추가
# 과거 x변수를 넣는다. 독립변수에 작년 것을 넣는다 => 시계열모형으로 간다.(선형회귀 area 밖)
# 선형변수 가정 : x변수는 주어졌다고 생각하자를 위반
# OLS를 못 쓴다. -> 시계열 모형(AR)으로 넘어감, 형태는 똑같음

## input X_t-1 ##
## 금리를 한달 뒤로 미룸 
nn = dim(data_ts)[1]
data$interest1 <- c(NA, data$interest[1:nn-1])
data_ts <- ts(data, frequency = 12, start=c(2018,1))

model3 <- lm(priceindex~interest+lnexchange+lnoil+lnKOSPI+COVID-1, data=data_ts)
summary(model3)

cor(data_ts)
acf(model3$residuals)
model3 <- lm(priceindex~interest+lnexchange+lnoil+lnKOSPI+COVID-1, data=data_ts)

modelwithinterest<- lm(priceindex~interest+interest+lnexchange+lnoil+lnKOSPI+COVID-1, data=data_ts)
summary(modelwithinterest)
acf(modelwithinterest$residuals)
dwtest(modelwithinterest)
## 유의미하지 않은 변수 추가로 더 나빠짐. 해결 안 된다.


### 각각의 변수의 과거값을 사용한다. 
### 과거값을 포함한 새로운 변수를 추가해본다.

## input X_t-2 ##
## 코로나 확진자 수를 두달 뒤로 미룸
data$COVID1 <- c(NA,NA, data$COVID[1:46])
modelwithCOVID1<- lm(priceindex~interest+lnexchange+lnoil+lnKOSPI+COVID1-1, data=data)
summary(modelwithCOVID1)
acf(modelwithCOVID1$residuals, lag.max = 24)
dwtest(modelwithCOVID1)

## input X_t-3 ##
## 금리를 세달 뒤로 미룸
data$interest1 <- c(NA,NA,NA, data$interest[1:45])
modelwithinterest1<- lm(priceindex~interest1+lnexchange+lnoil+lnKOSPI+COVID1-1, data=data)
summary(modelwithinterest1)
acf(modelwithinterest1$residuals, lag.max = 24)
dwtest(modelwithinterest1)

## input X_t-1 ##
## 환율을 한달 뒤로 미룸
data$lnexchange1 <- c(NA, data$lnexchange[1:47])
modelwithlnexchange1<- lm(priceindex~interest+lnexchange1+lnoil+lnKOSPI+COVID1-1, data=data)
summary(modelwithlnexchange1)
acf(modelwithlnexchange1$residuals, lag.max = 24)
dwtest(modelwithlnexchange1)

## input X_t-1 ##
## 코스피지수를 두달 뒤로 미룸
data$lnKOSPI1 <- c(NA,NA, data$lnKOSPI[1:46])
modelwithlnKOSPI1<- lm(priceindex~interest+lnoil+lnKOSPI1+COVID1-1, data=data)
summary(modelwithlnKOSPI1)
acf(modelwithlnKOSPI1$residuals, lag.max = 24)
dwtest(modelwithlnKOSPI1)


# 3) 변수변환 - 차분(차분은 거의 해결해 준다.)
## 변환 후 차분
ynew <- diff(data$priceindex, difference=1)
interest_new <- diff(data$interest, difference = 1)
lngoods_new <- diff(data$lngoods, difference = 1)
lnexchange_new <- diff(data$lnexchange, difference = 1)
lnoil_new <- diff(data$lnoil, difference = 1)
lnKOSPI_new <- diff(data$lnKOSPI, difference = 1)
COVID_new <- diff(data$COVID, difference = 1)

diff_data <- data.frame(ynew, interest_new, lngoods_new, lnexchange_new, lnoil_new, lnKOSPI_new, COVID_new)


## model 11 : 차분한 모든 변수를 다 넣어본다 ##
model11 <- lm(ynew~interest_new+lngoods_new+lnexchange_new+lnoil_new+lnKOSPI_new+COVID_new, data=diff_data)
summary(model11)
par(mfrow = c(1,2))
acf(model1$residuals)
acf(model11$residuals)


# stepwise - 주어진 독립변수들 중에서 선택했을 때 최적의 모델이 되는 조합을 알려줌
step(lm(ynew~interest_new+lngoods_new+lnexchange_new+lnoil_new+lnKOSPI_new+COVID_new, data=diff_data),
     scope = list(lower ~ 1, upper = ~interest_new+lngoods_new+lnexchange_new+lnoil_new+lnKOSPI_new+COVID_new), direction = "backward")
     
## model 12 : stepwise 한 모델
model12 <- lm(formula = ynew ~ interest_new + lnexchange_new + lnoil_new + lnKOSPI_new, data = diff_data)
summary(model12)
# 유의한 변수는 없고 절편만이 유의한 모형을 제시하였다.
par(mfrow = c(1,1))
acf(model12$residuals, lag.max = 24)

#### lngoods 변수는 물가지수와의 상관계수가 0에 가깝고, 거의 모든 모형에서 유의하지 않음을 확인하였으므로 모형에 되도록 넣지 않기로 결정한다.###

## model3 vs. 차분한 모형
model3 <- lm(priceindex~interest+lnexchange+lnoil+lnKOSPI+COVID-1, data=data_ts)
model13 <- lm(ynew ~ interest_new + lnexchange_new + lnoil_new + lnKOSPI_new + COVID_new - 1, data = diff_data)
summary(model13)
par(mfrow = c(1,2))
acf(model3$residuals)
acf(model13$residuals)

dwtest(model13)

## 모형에는 유의하지 않은 변수로 구성되며, 1차자기상관은 없다고 판단된다.
## 하지만 차분한 모형에서 모든 변수들이 유의하지 않으므로 차분을 사용하지 않는다.
## 모든 차분 모형은 유의하지 않으므로 차분을 사용하지 않는다.

## 이에 잔차의 자기상관을 해결하기 위해 세 가지 방법 중 과거의 독립변수를 넣어주는 방법을 사용하기로 하였다.  
## 이를 풀어서 생각하면, 두 달 전의 환율이 당월 물가에 이만큼 영향을 준다는 것으로 생각할 수 있다.

#####################################################################################################
