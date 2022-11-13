############################################################################
##### 2022 파이낸스 어낼리틱스 4조 201800308 강민구 _ 201902732 이윤지 #####
############################################################################
# 경로 지정(working directory)
setwd("C:/Users/mingu/Desktop/Finance Analytics Data")

###################################################################
a <- read.csv("국제수지_20221103193403.csv", fileEncoding = 'euc-kr')
b <- read.csv("국제유가_도입현황_20221103191120.csv", fileEncoding = 'euc-kr')
c <- read.csv("소비자물가지수_2020100__20221103190937.csv", fileEncoding = 'euc-kr')
d <- read.csv("수출입총괄_20221103200616.csv", fileEncoding = 'euc-kr')
g <- read.csv("한국은행 기준금리.csv", fileEncoding = 'euc-kr')


library(dplyr)

# 국제수지
summary(a); head(a)

# 국제유가
summary(b); head(b)

# 소비자 물가지수
summary(c); head(c)
c <- c %>% rename("물가지수"="전국")

# 수출입총괄 : 무역수지
summary(d); head(d); tail(d)
d <- d %>% rename("무역수지"="무역수지..천불.")

# 한국은행 기준금리
summary(g); head(g)
g$변경월 <- substr(g$변경일자,1,2)
g$시점 <- paste(g$변경년도,".",g$변경월,sep="")
g1 <- g %>% filter(변경년도 < 2022 & 변경년도 > 2017)
str(g1)
g2 <- g1 %>% select(시점,기준금리)


##### 민구 : 코스피, 환율, 유가, 코로나 발생여부, 소비자 동향지수, COFIX 금리
##### 윤지 : 경상수지, 상품수지, 무역수지, 물가지수, 기준금리

data <- a %>% filter(as.numeric(substr(시점, 1,4))<2022) %>% select(시점, 경상수지, 상품수지) 
data1 <- d %>% filter(as.numeric(substr(시점, 1,4))<2022) %>% select(시점, 무역수지) 
data2 <- c %>% filter(as.numeric(substr(시점,1,4))<2022) %>% select(시점, 물가지수)

data$시점 <- as.character(data$시점)
data1$시점 <- as.character(data1$시점)
data2$시점 <- as.character(data2$시점)

for(i in 1:length(data$시점)){
  if(nchar(data$시점[i])==6){
    data$시점[i] <- paste(data$시점[i],"0",sep="")
  }
}

for(i in 1:length(data1$시점)){
  if(nchar(data1$시점[i])==6){
    data1$시점[i] <- paste(data1$시점[i],"0",sep="")
  }
}

for(i in 1:length(data2$시점)){
  if(nchar(data2$시점[i])==6){
    data2$시점[i] <- paste(data2$시점[i],"0",sep="")
  }
}

data <- left_join(data,g2,by='시점')
data <- left_join(data,data1,by='시점')
data <- left_join(data,data2,by='시점')

for(i in 1:length(data$시점)){
  if(is.na(data$기준금리[i])){
    if(i<11){data$기준금리[i] <- data$기준금리[11]}
    else if(i<19){data$기준금리[i] <- data$기준금리[19]}
    else if(i<22){data$기준금리[i] <- data$기준금리[22]}
    else if(i<27){data$기준금리[i] <- data$기준금리[27]}
    else if(i<29){data$기준금리[i] <- data$기준금리[29]}
    else if(i<44){data$기준금리[i] <- data$기준금리[44]}
    else if(i<47){data$기준금리[i] <- data$기준금리[47]}
    else{data$기준금리[i] <- 1.25}
  }
}

data
summary(data)

data_m <- read.csv("통합본.csv",header=T, encoding="UTF-8")
data_m
summary(data_m)
colnames(data_m)
data_m <- data_m %>% rename("시점"="날짜") %>% rename("유가"="도입단가..US..배럴.") %>% rename("COFIX금리"="신규취급액기준.COFIX") %>% rename("환율"="종가")

data_m$시점 <- as.character(data_m$시점)
for(i in 1:length(data_m$시점)){
  if(nchar(data_m$시점[i])==6){
    data_m$시점[i] <- paste(data_m$시점[i],"0",sep="")
  }
}

data <- full_join(data,data_m,by="시점")

data 

write.csv(data, file="물가 데이터_최종.csv", fileEncoding = 'CP949')
