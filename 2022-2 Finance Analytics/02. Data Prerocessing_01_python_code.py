import pandas as pd
import os
import seaborn as sns
import matplotlib.pyplot as plt

import warnings
warnings.filterwarnings('ignore')


# 1  환율 데이터
# 데이터가 저장된 경로 지정 후 환율 데이터 불러옴
# 2018-01-01 ~ 2022-11-01 까지의 매달 1일 측정한 달러/원 데이터
path = 'C:\\Users\mingu\Desktop\\Finance Analytics Data'
UK = pd.read_csv(os.path.join(path, 'USD_KRW 내역.csv'))

# raw 데이터에서 날짜, 종가 열만 추출하고 이전 날짜 순으로 정렬
UK = UK[['날짜','종가']].iloc[11:]
UK = UK.sort_values(by='날짜')

# raw 데이터의 날짜가 2022-11-01 의 형식이기 때문에, 일수를 없애고 년도와 달을 .으로 연결하는 for문 구현
# raw 데이터의 종가가 1,427.13 의 형식이기에 단위 구별을 위한 ,를 제거해 데이터를 문자열이 아닌 float 타입으로 받아들이도록 하는 for문 구현
for i in UK.index:
    UK['날짜'][i] = UK['날짜'][i][:4] + '.' + UK['날짜'][i][6:8]
    UK['종가'][i] = float(UK['종가'][i].replace(',',''))

# 전처리한 데이터의 종가를 float 타입으로 변경    
UK['종가'] = UK['종가'].astype('float')
UK.head()


# 2  유가
# 유가 데이터 불러옴. 열의 구분자가 한글과 영어의 혼합형이기 때문에 encoding = 'cp949' 옵션 사용
# 2018.04 ~ 2022.08 까지의 유가에 관련된 정보를 가진 데이터
OIL = pd.read_csv(os.path.join(path, '국제유가_도입현황_20221103191120.csv'), encoding='cp949')

# raw 데이터에서 사용할 열만 추출하고 열 이름 변경
OIL = OIL[['시점','도입단가 (US$/배럴)']].iloc[:48]
OIL.rename(columns={'시점':'날짜'}, inplace = True)

# OIL의 날짜가 float 타입이기 때문에 이를 문자열로 변경해서 처리해야함
OIL['날짜'] = OIL['날짜'].astype('string')

# 사용할 데이터들의 형식을 일치시키기 위해서 년도와 월수 사이의 공백 제거 for문 구현
for i in OIL.index:
    OIL['날짜'][i] = OIL['날짜'][i][:4] + '.' + OIL['날짜'][i][5:7]
    
# OIL의 날짜가 float 타입이기에 raw 데이터의 각 해의 10월달이 년도.10 이 아닌 년도.1 로 저장되어 있음. 
# 이러한 경우 뒤에 0을 붙여주는 for문 구현
for i in [9,21,33,45]:
    OIL['날짜'][i] = OIL['날짜'][i] + '0'

# 이전 날짜 순으로 정렬
OIL = OIL.sort_values(by='날짜')
OIL.head()


# 3  코스피
# 코스피 데이터에서 날짜와 종가만 추출하여 불러옴
# 이전 날짜 순으로 정렬
KOSPI = pd.read_csv(os.path.join(path, '코스피지수 내역.csv'))[['날짜','종가']]
KOSPI = KOSPI.sort_values(by = '날짜')

# raw 데이터는 2018-01-25와 같이 2018.01.02 ~ 2022.11.03 동안 종가가 매일 기록된 데이터임
# 2018.01~2022.11 기간 동안의 일별 종가들을 평균내어 월별 종가로 바꾸기 위한 코드 구현

# 공백 데이터프레임 c 선언
c = pd.DataFrame()

# raw 데이터의 날짜가 2018- 06- 16 과 같이 -(공백) 을 기준으로 구분되기 때문에 이를 나누는 코드가 필요함
# 이렇게 나눈 인덱스와 년,월,일을 tmp 데이터프레임에 저장
# 앞서 선언한 공백 데이터프레임에 tmp 데이터프레임을 concat 함수를 사용하여 상하로 이어붙임
# 이러한 과정을 KOSPI 데이터의 모든 행에 대해 실행함
# 최종 데이터프레임 c는 전체 기간에 대한 인덱스와 년,월,일을 가지고 있는 데이터프레임임
for i in KOSPI.index:
    b = KOSPI['날짜'][i].split('- ')
    tmp = pd.DataFrame(data = [b], index = [i])
    c = pd.concat([c,tmp])
    
# 만들어진 c 데이터프레임의 열 이름을 변경하고 년,월만을 .으로 이어붙여 new라는 새로운 열로 지정
# 기존의 year, month 열 삭제
c.columns = ['year','month','day']
c['new'] = c[['year','month']].apply('.'.join, axis = 1)
del c['year']
del c['month']

# c와 KOSPI 데이터를 merge 함수를 사용하여 인덱스를 기준으로 좌우로 이어붙임
# merge 할 때 인덱스를 기준으로 매핑하였기 때문에 2018년 1월의 모든 일자의 new 열은 2018.01임
# 이와 같은 방식으로 마지막 2022년 11월의 모든 일자의 new열은 2022.11 값을 가지도록 함
KOSPI = pd.merge(c,KOSPI, how = 'inner', left_index = True, right_index = True)

# raw 데이터의 종가가 2,479.65 의 형식이기에 단위 구별을 위한 ,를 제거해 데이터를 문자열이 아닌 float 타입으로 받아들이도록 하는 for문 구현
for i in KOSPI.index:
    KOSPI['종가'][i] = float(KOSPI['종가'][i].replace(',',''))

# 전처리한 데이터의 종가를 float 타입으로 변경
KOSPI['종가'] = KOSPI['종가'].astype('float')

# 위에서 merge를 통해 만든 KOSPI 데이터를 new 열을 기준으로 그룹화해서 종가의 평균을 구하는 코드 작성. 이후 인덱스로 지정되는 new를 제거
# new 열이 월별로 지정된 값이기 때문에 groupby 함수와 agg 함수를 사용해서 월별 KOSPI 지수의 종가 평균을 구할 수 있음
KOSPI = KOSPI.groupby('new').agg({'종가' : 'mean'}).reset_index()

# 다른 데이터들과 형식을 맞추기 위해 new 열의 이름을 날짜로 변경. 종가는 KOSPI로 변경
KOSPI.rename(columns = {'new' : '날짜', '종가' : 'KOSPI'}, inplace = True)
KOSPI = KOSPI.iloc[:48]
KOSPI.head()


# 4  COFIX
# COFIX 금리 데이터 가져옴 - 2018.01~2021.12 : 금리 적용 날짜 기준
# 원본 데이터의 열이 상관없는 header이기 때문에 .columns 메소드를 통해 열 이름 새롭게 지정
# 가장 첫번째 행 삭제 - 열 이름으로 구성된 행
# 이전 날짜를 먼저 확인하기 위해 sort.index 함수에 ascending=False 옵션을 줘서 인덱스 기준 내림차순 배열
# 5개의 데이터에 동일한 전처리 진행
COFIX_2018 = pd.read_excel(os.path.join(path, 'COFIX통계(2018년도)_20221110.xlsx'))
COFIX_2018.columns = ['공시일','날짜','신규취급액기준 COFIX', '잔액기준 COFIX', '신 잔액기준 COFIX']
COFIX_2018 = COFIX_2018.drop([0])
COFIX_2018 = COFIX_2018.sort_index(ascending=False)

COFIX_2019 = pd.read_excel(os.path.join(path, 'COFIX통계(2019년도)_20221110.xlsx'))
COFIX_2019.columns = ['공시일','날짜','신규취급액기준 COFIX', '잔액기준 COFIX', '신 잔액기준 COFIX']
COFIX_2019 = COFIX_2019.drop([0])
COFIX_2019 = COFIX_2019.sort_index(ascending=False)

COFIX_2020 = pd.read_excel(os.path.join(path, 'COFIX통계(2020년도)_20221110.xlsx'))
COFIX_2020.columns = ['공시일','날짜','신규취급액기준 COFIX', '잔액기준 COFIX', '신 잔액기준 COFIX']
COFIX_2020 = COFIX_2020.drop([0])
COFIX_2020 = COFIX_2020.sort_index(ascending=False)

COFIX_2021 = pd.read_excel(os.path.join(path, 'COFIX통계(2021년도)_20221110.xlsx'))
COFIX_2021.columns = ['공시일','날짜','신규취급액기준 COFIX', '잔액기준 COFIX', '신 잔액기준 COFIX']
COFIX_2021 = COFIX_2021.drop([0])
COFIX_2021 = COFIX_2021.sort_index(ascending=False)

COFIX_2022 = pd.read_excel(os.path.join(path, 'COFIX통계(2022년도)_20221110.xlsx'))
COFIX_2022.columns = ['공시일','날짜','신규취급액기준 COFIX', '잔액기준 COFIX', '신 잔액기준 COFIX']
COFIX_2022 = COFIX_2022.drop([0])
COFIX_2022 = COFIX_2022.sort_index(ascending=False)

# 전처리한 다섯개의 데이터프레임을 위아래로 이어붙임
# concat 함수에 axis = 0 옵션을 줘서 행 기준으로 이어붙임
# ignore_index 옵션을 통해 원래 데이터들의 인덱스가 아닌 합쳐진 데이터프레임을 기준으로 새로운 인덱스 제공
COFIX = pd.concat([COFIX_2018,COFIX_2019,COFIX_2020,COFIX_2021,COFIX_2022], axis = 0, ignore_index=True)

# 필요한 두 개의 열만 가져오고 필요한 날짜에 대해서만 슬라이싱
COFIX = COFIX[['날짜','신규취급액기준 COFIX']]
COFIX = COFIX.iloc[:49]
COFIX = COFIX.drop([0])

# 다른 데이터프레임들과 날짜 포맷을 동일하게 만들어줌
for i in COFIX.index:
    COFIX['날짜'][i] = COFIX['날짜'][i][:4] + '.' + COFIX['날짜'][i][5:7]

# 전처리된 데이터 자료형 변경    
COFIX['신규취급액기준 COFIX'] = COFIX['신규취급액기준 COFIX'].astype('float')
COFIX['날짜'] = COFIX['날짜'].astype('object')

COFIX.head()


# 5  데이터 통합
# 전처리한 모든 데이터를 merge 함수를 사용해서 통합
# 닐짜 열을 기준으로 통합하며, 모든 데이터에 공통으로 존재하는 날짜만 사용하기 위해 how = 'inner' 옵션 사용
# 통합 데이터프레임 : COMBINE
COMBINE = pd.merge(UK, OIL, on = '날짜', how = 'inner')
COMBINE = pd.merge(COMBINE, KOSPI, on = '날짜', how = 'inner')
COMBINE = pd.merge(COMBINE, COFIX, on = '날짜', how = 'inner')
COMBINE.head()


# 6  코로나
# 코로나의 영향을 알아보기 위한 범ㅁ주형 변수 생성
# 통합 데이터 COMBINE에 COVID 열을 만들고 '0' 값을 매핑
COMBINE['COVID'] = '0'

# 데이터의 년도가 2019, 2020, 2021년이면 코로나의 영향이 있다고 간주 - '1'값 매핑
# 그렇지 않은 년도에 대해서는 '0'값 그대로 매핑
for i in COMBINE.index:
    if (COMBINE['날짜'][i][:4] == '2019') | (COMBINE['날짜'][i][:4] == '2020') | (COMBINE['날짜'][i][:4] == '2021'):
        COMBINE['COVID'][i] = '1'
    else:
        COMBINE['COVID'][i] = '0'

COMBINE.head()   


# 7  통합 데이터 확인
COMBINE.info()
COMBINE.describe()


# 8 데이터 .csv 파일로 내보내기
os.chdir(path)
COMBINE.to_csv('통합본.csv', encoding='utf-8-sig', index = False)
