# 📈 2022-2 파이낸스 애널리틱스 프로젝트  

<br>  

 2022년 코로나의 완화로 인해 세계 경제가 다시 회복세로 접어들자 미국이 지난 2년간 풀어놓았던 달러를 다시 거두고자 하는 정책을 펼치고 있습니다. 이에 달러 환율 상승에 따라 우리나라의 물가와 금리 역시 큰 폭으로 오르는 추세입니다.  
 
대부분 분식집에서 떡볶이와 김밥을 드시거나, 자장면을 시켜 드신 적이 있을 것이라 생각합니다. 생각해보면 예전에는 정말 대수롭지 않게 시켜먹었던 기억이 있는데, 최근 기사를 보면 김밥 한 줄과 떡볶이를 시키면 거의 9000원에 달하는 금액이 나온다는 인터뷰 내용이 나옵니다. 이처럼, 다들 몸소 체감하고 계시겠지만 물가가 정말 크게 올랐습니다.  
중앙일보에 따르면, 생활물가지수와 체감실업률을 고려하여 서민이 체감하는 경제적 어려움을 수치화한 서민경제고통지수가 관련 통계 집계를 시작한 2015년 이래 지난해 가장 높게 나타났습니다. 이에 더하여 지난해 경제고통지수 역시 큰 폭으로 상승했습니다. 이는 밥상물가를 중심으로 생필품의 가격이 크게 올랐을 뿐더러, 저희가 피부로 느끼는 일자리 사정이 나아지지 않았기 때문으로 보입니다.  
또한 산업통상자원부에 따르면 올해 상반기 무역적자는 103억 달러를 기록하면서 역대 최고기록이었던 91억 달러를 넘어섰다고 합니다. 이에 더해 한국은행은 올해 7월 경상수지 흑자가 지난해 동월 대비 66억 달러 감소한 10억 달러임을 발표하였습니다. 이렇게 우리나라 경제를 책임지는 두 수지가 악화됨과 동시에 환율이 상승하면서 저희는 물가가 계속해서 오르는 악순환을 겪고 있는 것입니다.  

<br>  

 이런 상황에 있어 물가의 상승에 가장 큰 영향을 미치는 경제적 요인은 무엇일지 알아보고 그에 대한 정책적 해결책을 마련하고자 본 프로젝트를 기획하였습니다.<br>  
 
 본 프로젝트에서 사용할 데이터는 2018.01부터 2021.12 까지의 각종 월별 경제적 지표 데이터입니다. 2022년 들어 물가가 굉장히 많이 폭등했기 때문에, 이를 데이터에 포함시키면 모델을 형성하는 과정에 있어서 해당 데이터에 큰 가중치가 적용될 것이 우려되어 배제하였습니다.<br>  
 
 
📈 이를 위해 선택한 경제적 지표는 아래와 같습니다.  

  - 소비자물가지수 (종속변수) : [KOSIS 소비자물가지수, 20221102](https://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1J20003&vw_cd=MT_ZTITLE&list_id=P2_6&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 국제수지 (정량) : [KOSIS 경상수지, 20221103](https://kosis.kr/statHtml/statHtml.do?orgId=301&tblId=DT_301Y013&vw_cd=MT_ZTITLE&list_id=S2_301008_001&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 국제유가 도입가 (정량) : [KOSIS 국제유가, 20221018](https://kosis.kr/statHtml/statHtml.do?orgId=392&tblId=DT_AA123&vw_cd=MT_ZTITLE&list_id=T_21&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 경상수지 (정량) : [KOSIS 경상수지, 20221111](https://kosis.kr/statHtml/statHtml.do?orgId=301&tblId=DT_301Y017&vw_cd=MT_ZTITLE&list_id=S2_301008_001&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 상품수지 (정량) : [KOSIS 상품수지, 20221111](https://kosis.kr/statHtml/statHtml.do?orgId=301&tblId=DT_301Y017&vw_cd=MT_ZTITLE&list_id=S2_301008_001&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 무역수지 (정량) : [KOSIS 수출입총괄, 20221021](https://kosis.kr/statHtml/statHtml.do?orgId=134&tblId=DT_134001_001&vw_cd=MT_ZTITLE&list_id=&scrId=&seqNo=&lang_mode=ko&obj_var_id=&itm_id=&conn_path=E1&docId=0388621915&markType=S&itmNm=%EC%A0%84%EA%B5%AD)
  - 기준금리 (정량) : [한국은행 기준금리 추이](https://www.bok.or.kr/portal/singl/baseRate/list.do?dataSeCd=01&menuNo=200643)
  - 환율 (정량) : [환율 (USD/KRW) ,20221103](https://kr.investing.com/currencies/usd-krw-historical-data)
  - 코스피지수 (정량) : [코스피지수 ,20221103](https://kr.investing.com/indices/kospi-historical-data)
  - COFIX 금리 (정량) : [은행연합회 소비자포털 COFIX 금리, 20221111](https://portal.kfb.or.kr/fingoods/cofix.php)
  - 코로나19 확진자 수 : [질병관리청 코로나바이러스19 누적 확진자 통계](https://ncov.kdca.go.kr/)  
<br>  
<br>  

# 📈 프로젝트 진행 상황 / 일정  

- [x] 💻 11/03 데이터 탐색 및 계획 수립<br>  
  
- [x] 💻 11/05 데이터 전처리 및 통합  
  - 소비자물가지수  
  - 국제수지  
  - 국제유가 도입가  
  - 경상수지  
  - 상품수지  
  - 무역수지  
  - 환율  
  - 코스피지수  
  - 코로나 발생 여부<br>  
  
- [x] 💻 11/10 데이터 추가 탐색 및 전처리, 데이터 통합  
  - 기준금리  
  - COFIX 금리  
  
- [x] 💻 11/17 시계열 데이터 생성 및 linear regression model 생성  
  - 코로나 확진자 수 데이터 추가
  - 시계열 데이터에의 독립변수들 간의 다중공선성 문제 해결  
  - 잔차들 간의 자기상관계수 파악  
  
- [x] 💻 11/24,25 가정 검정 및 최종 linear regression model 생성  
  - 독립변수 간의 잔차의 자기상관 제거를 위한 방법 고안  
  - 최종 모델 생성  
  - 잔차플롯 / QQ plot / standarded residual plot / leverage plot 을 통한 모델 평가  
  
<br>  


***
