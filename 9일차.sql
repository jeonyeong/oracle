
-----------1번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------
SELECT A.CUSTOMER_NAME
     , A.PHONE_NUMBER
FROM CUSTOMER A
   , ADDRESS B
WHERE A.ZIP_CODE = B.ZIP_CODE
AND ADDRESS_DETAIL = '강남구';
----------2번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
SELECT JOB 
     , COUNT(*) CNT
FROM CUSTOMER
WHERE JOB IS NOT NULL
GROUP BY JOB 
ORDER BY 2 DESC;
----------3-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
---------------------------------------------------------------------
SELECT *
FROM (
    SELECT TO_CHAR(FIRST_REG_DATE,'DAY') AS 요일
         , COUNT(*) 건수
    FROM CUSTOMER
    GROUP BY TO_CHAR(FIRST_REG_DATE,'DAY')
    ORDER BY 2 DESC
    )
WHERE ROWNUM = 1;
----------3-2번 문제 ---------------------------------------------------
-- 남녀 성비 집계를 출력하시오 
---------------------------------------------------------------------
SELECT DECODE(GENDER,'F','여자','M','남자','N','미등록','합계') as GENDER
     , CNT
FROM (
    SELECT GENDER
         , COUNT(*) as CNT
    FROM (SELECT DECODE(SEX_CODE,NULL,'N',SEX_CODE) as GENDER
          FROM CUSTOMER)
    GROUP BY ROLLUP(GENDER)
    )
;
--------------------------------------------------------------------
SELECT  DECODE(SEX_CODE,'M','남자','F','여자',NULL,'미등록') as GENDER
      , CNT
FROM (
    SELECT SEX_CODE
         , COUNT(*) as CNT
    FROM CUSTOMER
    GROUP BY SEX_CODE
    ORDER BY 2 DESC
    )
UNION 
SELECT '합계' as GENDER
     , CNT
FROM (
     SELECT COUNT(*) CNT
     FROM CUSTOMER
     );
-----------------------------------------------
SELECT CASE WHEN SEX_CODE = 'F' THEN '여자'
            WHEN SEX_CODE = 'M' THEN '남자'
            WHEN SEX_CODE IS NULL AND GROUPID = 0 THEN '미등록'
            ELSE '합계'
            END AS GENDER
    , CNT 
FROM (
    SELECT SEX_CODE
         , GROUPING_ID(SEX_CODE) as groupid
         , COUNT(*) as CNT
    FROM CUSTOMER
    GROUP BY ROLLUP(SEX_CODE)
    );
    
    
    
SELECT reserv_no
     , item_id
     , grouping_id(reserv_no, item_id)
     , sum(quantity)
     , sum(sales)
FROM order_info
group by rollup(reserv_no, item_id);
----------4번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
---------------------------------------------------------------------
SELECT TO_CHAR(TO_DATE(RESERV_DATE),'MM') AS 월
     , COUNT(*) 취소건수
FROM RESERVATION
WHERE CANCEL = 'Y'
GROUP BY TO_CHAR(TO_DATE(RESERV_DATE),'MM')
ORDER BY 2 DESC;

----------5번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------
SELECT C.product_name 상품이름, 
       SUM(B.sales) 상품매출
FROM reservation A, order_info B, item C 
WHERE A.reserv_no = B.reserv_no
AND   B.item_id   = C.item_id
GROUP BY C.item_id
       , C.product_name
ORDER BY SUM(B.sales) DESC;

---------- 6번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------
SELECT SUBSTR(A.reserv_date,1,6) 매출월,  
       SUM(DECODE(B.item_id,'M0001',B.sales,0)) SPECIAL_SET,
       SUM(DECODE(B.item_id,'M0002',B.sales,0)) PASTA,
       SUM(DECODE(B.item_id,'M0003',B.sales,0)) PIZZA,
       SUM(DECODE(B.item_id,'M0004',B.sales,0)) SEA_FOOD,
       SUM(DECODE(B.item_id,'M0005',B.sales,0)) STEAK,
       SUM(DECODE(B.item_id,'M0006',B.sales,0)) SALAD_BAR,
       SUM(DECODE(B.item_id,'M0007',B.sales,0)) SALAD,
       SUM(DECODE(B.item_id,'M0008',B.sales,0)) SANDWICH,
       SUM(DECODE(B.item_id,'M0009',B.sales,0)) WINE,
       SUM(DECODE(B.item_id,'M0010',B.sales,0)) JUICE
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no
GROUP BY SUBSTR(A.reserv_date,1,6)
ORDER BY SUBSTR(A.reserv_date,1,6);

select *
from order_info;

---------- 7번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
----------------------------------------------------------------------------
SELECT  SUBSTR(reserv_date,1,6) 날짜,  
          A.product_name 상품명,
          SUM(DECODE(A.WEEK,'1',A.sales,0)) 일요일,
          SUM(DECODE(A.WEEK,'2',A.sales,0)) 월요일,
          SUM(DECODE(A.WEEK,'3',A.sales,0)) 화요일,
          SUM(DECODE(A.WEEK,'4',A.sales,0)) 수요일,
          SUM(DECODE(A.WEEK,'5',A.sales,0)) 목요일,
          SUM(DECODE(A.WEEK,'6',A.sales,0)) 금요일,
          SUM(DECODE(A.WEEK,'7',A.sales,0)) 토요일   
FROM
      (
        SELECT A.reserv_date,
               C.product_name,
               TO_CHAR(TO_DATE(A.reserv_date, 'YYYYMMDD'),'d') WEEK,
               B.sales
        FROM reservation A, order_info B, item C
        WHERE A.reserv_no = B.reserv_no
        AND   B.item_id   = C.item_id
        AND   B.item_id = 'M0001'
      ) A
GROUP BY SUBSTR(reserv_date,1,6), A.product_name
ORDER BY SUBSTR(reserv_date,1,6);


---------- 8번 문제 ----------------------------------------------------
-- 고객수, 남자인원수, 여자인원수, 평균나이, 평균거래기간(월기준)을 구하시오 (성별 NULL 제외)
----------------------------------------------------------------------------
SELECT COUNT(customer_id) 고객수, 
       SUM(DECODE(sex_code,'M',1,0)) 남자, 
       SUM(DECODE(sex_code,'F',1,0)) 여자,
       ROUND(AVG(MONTHS_BETWEEN(sysdate,TO_DATE(birth,'YYYYMMDD'))/12),1) 평균나이,
       ROUND(AVG(MONTHS_BETWEEN(sysdate,first_reg_date)),1) 평균거래기간
FROM customer
WHERE sex_code IS NOT NULL
AND birth IS NOT NULL;

select to_char(first_reg_date,'YYYYMMDD HH24:MI:SS')
from customer;
---------- 9번 문제 ----------------------------------------------------
-- 주소, 우편번호, 해당지역 고객수를 출력하시오
--(고객의 주문내역은 많을 수 있기 때문에 해당지역에 고객 아이디가 중복되지 않게 Distinct 처리 해줘야 한다. 
----------------------------------------------------------------------------
SELECT B.address_detail 주소
     , COUNT(B.address_detail) 카운팅
FROM (
      SELECT DISTINCT A.customer_id, A.zip_code
      FROM  customer A, reservation B, order_info C
      WHERE A.customer_id = B.customer_id 
      AND   B.reserv_no   = C.reserv_no
      ) A, address B
WHERE A.zip_code = B.zip_code
GROUP BY B.address_detail, B.zip_code 
ORDER BY COUNT(B.address_detail) DESC;


