# 📈 2022-2 파이낸스 애널리틱스 프로젝트  

<br>  

 2022년 코로나의 완화로 인해 세계 경제가 다시 회복세로 접어들자 미국이 지난 2년간 풀어놓았던 달러를 다시 거두고자 하는 정책을 펼치고 있다. 이에 달러 환율 상승에 따라 우리나라의 물가와 금리 역시 큰 폭으로 오르는 추세다. 이런 상황에 있어 물가의 상승에 가장 큰 영향을 미치는 경제적 요인은 무엇일지 알아보고 그에 대한 정책적 해결책을 마련하고자 본 프로젝트를 기획했다.<br>  
 
 본 프로젝트에서 사용할 데이터는 2018.01부터 2021.12 까지의 각종 월별 경제적 지표 데이터이다. 2022년 들어 물가가 굉장히 많이 폭등했기 때문에, 이를 데이터에 포함시키면 모델을 형성하는 과정에 있어서 해당 데이터에 큰 가중치가 적용될 것이 우려되어 배제했다.<br>  
 
 
📈 이를 위해 선택한 경제적 지표는 아래와 같다.  

  - 1. 소비자물가지수 (종속변수) : KOSIS 소비자물가지수, 20221102 (https://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1J20003&vw_cd=MT_ZTITLE&list_id=P2_6&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 2. 국제수지 (정량) : KOSIS 경상수지, 20221103 (https://kosis.kr/statHtml/statHtml.do?orgId=301&tblId=DT_301Y013&vw_cd=MT_ZTITLE&list_id=S2_301008_001&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 3. 국제유가 도입가 (정량) : KOSIS 국제유가, 20221018 (https://kosis.kr/statHtml/statHtml.do?orgId=392&tblId=DT_AA123&vw_cd=MT_ZTITLE&list_id=T_21&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 4. 경상수지 (정량) : KOSIS 경상수지, 20221111 (https://kosis.kr/statHtml/statHtml.do?orgId=301&tblId=DT_301Y017&vw_cd=MT_ZTITLE&list_id=S2_301008_001&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 5. 상품수지 (정량) : KOSIS 상품수지, 20221111 (https://kosis.kr/statHtml/statHtml.do?orgId=301&tblId=DT_301Y017&vw_cd=MT_ZTITLE&list_id=S2_301008_001&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=MT_ZTITLE)
  - 6. 무역수지 (정량) : KOSIS 수출입총괄, 20221021 (https://kosis.kr/statHtml/statHtml.do?orgId=134&tblId=DT_134001_001&vw_cd=MT_ZTITLE&list_id=&scrId=&seqNo=&lang_mode=ko&obj_var_id=&itm_id=&conn_path=E1&docId=0388621915&markType=S&itmNm=%EC%A0%84%EA%B5%AD)
  - 7. 기준금리 (정량) : 한국은행 기준금리 추이 (https://www.bok.or.kr/portal/singl/baseRate/list.do?dataSeCd=01&menuNo=200643)
  - 8. 환율 (정량) : 환율 (USD/KRW) ,20221103 (https://kr.investing.com/currencies/usd-krw-historical-data)
  - 9. 코스피지수 (정량) : 코스피지수 ,20221103 (https://kr.investing.com/indices/kospi-historical-data)
  - 10. COFIX 금리 (정량) : 은행연합회 소비자포털 COFIX 금리, 20221111 (https://portal.kfb.or.kr/fingoods/cofix.php)
  - 11. 코로나 발생 여부 (binary) : 2019~2021년도에는 COVID = 1 로 매핑하였음.  
<br>  
<br>  

# 📈 프로젝트 진행 상황 / 일정  

- 💻 11/03 데이터 탐색 및 계획 수립<br>  
  
- 💻 11/05 데이터 전처리 및 통합  
  - 소비자물가지수  
  - 국제수지  
  - 국제유가 도입가  
  - 경상수지  
  - 상품수지  
  - 무역수지  
  - 환율  
  - 코스피지수  
  - 코로나 발생 여부<br>  
  
- 💻 11/10 데이터 추가 탐색 및 전처리, 데이터 통합  
  - 기준금리  
  - COFIX 금리  
  
전처리 및 통합이 끝난 데이터는 아래와 같다.
