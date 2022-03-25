/*
 제출과제 2

 아래 문제를 출력 SQL을 작성 및 테스트 후 
 이름_수행쿼리2.sql 파일을 제출 하세요 
 (문제에 대한 출력물은 이미지 참고)
*/
-----------1번 문제 ----------------------------------------------
--ITEM 테이블에서 카테고리 아이디가 FOOD인 것만 출력하시오.
---------------------------------------------------------------------
SELECT category_id
     , product_name
     , product_desc
FROM item
WHERE category_id = 'FOOD';

---------------------------------------------------------------------
-----------2번 문제 ------------------------------------------------
/*
CUSTOMER 테이블에서 출생년도가 1996년 부터 조회하시오 (1996 ~ 2020)
MAIL_ID 컬럼은 이메일 앞부분@
MAIL_DOMAIN 컬럼은 이메일 @뒷부분
REG_DATE, BIRTH 은 'YYYY-MM-DD'형태로 
*/
---------------------------------------------------------------------
SELECT customer_name
     , phone_number
     , substr(email,0, instr(email,'@') -1) as mail_id
     , substr(email,instr(email,'@') + 1 ) as mail_domain
     , decode(sex_code,'M','남자','F','여자') as gender
     , birth
     , substr(zip_code,1,3)  || '-' ||  substr(zip_code,4) as zipcode
FROM customer
WHERE substr(birth,1,4) > 1995 
ORDER BY first_reg_date;


-----------3-1번 문제 ---------------------------------------------------
/*
CUSTOMER에 있는 회원의 ZIP_CODE를 활용하여 
서울의 구별로 남자,여자,회원정보없는,전체 인원 수를 출력하시오 
*/
--------------------------------------------------------------------
----------3-2번 문제 ---------------------------------------------------
--
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 
--직업 NULL은 제외 

-----------4번 문제 ---------------------------------------------------
/*
고객별 지점 방문횟수와 방문객의 합을 출력하시오 
방문횟수가 4번이상만 조회 (예약 취소건 제외) 
*/
---------------------------------------------------------------------
SELECT CUSTOMER_ID
     , CUSTOMER_NAME
FROM CUSTOMER;

SELECT CUSTOMER_ID
      ,BRANCH
      ,VISITOR_CNT
FROM RESERVATION;


SELECT a.customer_id
     , a.customer_name
     , b.branch
     , count(b.branch)    as branch_cnt
     , sum(b.visitor_cnt) as visitor_cnt_cnt 
FROM CUSTOMER a 
   , RESERVATION b
WHERE a.customer_id = b.customer_id 
AND b.cancel = 'N'
GROUP BY a.customer_id
       , a.customer_name
       , b.branch
HAVING count(b.branch) >= 4
ORDER BY 4 desc, 5 desc;

-----------5번 문제 ---------------------------------------------------
/*
    4번 문제에서 가장많이 동일지점에 방문한 1명만 출력하시오 
*/
---------------------------------------------------------------------
select customer_id
from (SELECT a.customer_id
             , a.customer_name
             , b.branch
             , count(b.branch)    as branch_cnt
             , sum(b.visitor_cnt) as visitor_cnt_cnt 
        FROM CUSTOMER a 
           , RESERVATION b
        WHERE a.customer_id = b.customer_id 
        AND b.cancel = 'N'
        GROUP BY a.customer_id
               , a.customer_name
               , b.branch
        HAVING count(b.branch) >= 4
        ORDER BY 4 desc, 5 desc
      )
where rownum = 1
;
-----------6번 문제 ---------------------------------------------------
/*
5번 문제 고객의 구매 품목별 합산금액을 출력하시오(5번문제의 쿼리를 활용하여)
*/
--W1338910
---------------------------------------------------------------------

SELECT (select product_name from item  where item_id = a.item_id) as item_name
     , sum(sales) as sum_sales
FROM order_info a 
WHERE reserv_no IN (SELECT reserv_no
                    FROM reservation
                    WHERE customer_id = 'W1338910')
GROUP BY item_id
ORDER BY 2 desc;

-- 수강 학점이 가장 많은 학생의 수강 과목을 출력하시오 
-- (1) 조인, (2)가장 학점이 많은 학생 학번구하기, (3) 해당 학번으로 학생 및 과목 출력 
select 학번 
from ( select a.학번 
            ,  sum(c.학점)
        from 학생 a
           , 수강내역 b
           , 과목 c
        where a.학번 = b.학번 
          and b.과목번호 = c.과목번호 
        group by a.학번 
        order by 2 desc
     )
where rownum = 1;

-- 1997131542
select a.이름,  c.과목이름 
from 학생 a, 수강내역 b, 과목 c
where a.학번 = b.학번 
  and b.과목번호 = c.과목번호 
  and a.학번 = (select 학번 
                from ( select a.학번 
                            ,  sum(c.학점)
                        from 학생 a
                           , 수강내역 b
                           , 과목 c
                        where a.학번 = b.학번 
                          and b.과목번호 = c.과목번호 
                        group by a.학번 
                        order by 2 desc
                     )
                where rownum = 1);

-----------7번 문제 ---------------------------------------------------
/*
ITEM 테이블에 신규 데이터를 입력하는 구문의 첫번째 데이터인 코드값 ()에 들어갈 쿼리를 완성하여 입력하시오.
ITEM 코드 값을 조회해서 생성하는 SQL을 작성하시오 

EX) SELECT ITEM_ID FROM ITEM 로 조회되는 값의 수에 +1 즉 총자리수는 5자리임 문자1 + 숫자5 현재 M0010 있으니 M0011 이 입력되어야함.

INSERT INTO ITEM VALUES ((    ),'SOUP','스프','FOOD',7000);
*/
---------------------------------------------------------------------
SELECT 'M'||LPAD(NVL(MAX(TO_NUMBER(SUBSTR(ITEM_ID,2))),0) + 1,4,'0')
FROM ITEM;

INSERT INTO ITEM VALUES ((SELECT 'M'||LPAD(NVL(MAX(TO_NUMBER(SUBSTR(ITEM_ID,2))),0) + 1,4,'0')
                          FROM ITEM )
                          ,'SOUP','스프','FOOD',7000);
select *
from item;
-----------8번 문제 ---------------------------------------------------
/*
7번 문제 스프 -> 수프로 
     7000 -> 7500 으로 수정하는 SQL을 작성하시오 
*/
---------------------------------------------------------------------
UPDATE item
SET product_desc = '수프'
  , price  = 7500
WHERE item_id = 'M0011';

-----------9번 문제 ---------------------------------------------------
/*
전체 상품의 총 판매량과 총 매출액, 전용 상품의 판매량과 매출액을 출력하시오 
 reservation, order_info 테이블을 활용하여 
 온라인 전용상품의 총매출을 구하시오 
 */
-------------------------------------------------------------------------
SELECT sum(sales)  as 총매출 
     , sum(quantity) as 판매량 
     , sum(decode(item_id, 'M0001' , sales , 0)) as 전용상품매출 
     , sum(decode(item_id, 'M0001' , quantity , 0)) as 전용상품판매량  
     , sum(decode(item_id, 'M0001' , 0 ,quantity)) as 그밖에판매량    
FROM order_info;


-----------10번 문제 ---------------------------------------------------
/*
매출월별 총매출, 전용상품이외의 매출, 전용상품 매출, 전용상품판매율
      , 총예약건, 예약완료건, 예약취소건, 예약취소율을 출력하시오 
*/
---------------------------------------------------------------------
SELECT substr(a.reserv_date,1,6) as 매출월 
      ,SUM(DECODE(a.cancel, 'N', 1, 0)) as 완료건 
      ,SUM(DECODE(a.cancel, 'Y', 1, 0)) as 취소건 
      ,COUNT(*) as 전체 
FROM RESERVATION a
   , ORDER_INFO b 
WHERE a.reserv_no = b.reserv_no(+)
GROUP BY substr(a.reserv_date,1,6);



SELECT substr(a.reserv_date,1,6)                                   as 매출월 
      ,sum(b.sales)                                                as 총매출 
      ,sum(b.sales) - sum(decode(b.item_id , 'M0001', b.sales, 0)) as 전용상품외매출 
      ,sum(decode(b.item_id , 'M0001', b.sales, 0))                as 전용상품매출 
FROM RESERVATION a
   , ORDER_INFO b 
WHERE a.reserv_no = b.reserv_no
GROUP BY substr(a.reserv_date,1,6)
ORDER BY 1 ;



SELECT substr(a.reserv_date,1,6) as 매출월 
      ,SUM(DECODE(a.cancel, 'N', 1, 0)) as 예약완료건 
      ,SUM(DECODE(a.cancel, 'Y', 1, 0)) as 예약취소건 
FROM RESERVATION a
GROUP BY substr(a.reserv_date,1,6);

SELECT t1.매출월 
      ,t1.총매출
      ,t1.전용상품외매출
      ,t1.전용상품매출
      ,t2.예약완료건
      ,t2.예약취소건 
FROM (SELECT substr(a.reserv_date,1,6)                                     as 매출월 
              ,sum(b.sales)                                                as 총매출 
              ,sum(b.sales) - sum(decode(b.item_id , 'M0001', b.sales, 0)) as 전용상품외매출 
              ,sum(decode(b.item_id , 'M0001', b.sales, 0))                as 전용상품매출 
        FROM RESERVATION a
           , ORDER_INFO b 
        WHERE a.reserv_no = b.reserv_no
        GROUP BY substr(a.reserv_date,1,6)
        ORDER BY 1 
        ) t1
   , ( SELECT substr(a.reserv_date,1,6)         as 매출월 
              ,SUM(DECODE(a.cancel, 'N', 1, 0)) as 예약완료건 
              ,SUM(DECODE(a.cancel, 'Y', 1, 0)) as 예약취소건 
        FROM RESERVATION a
        GROUP BY substr(a.reserv_date,1,6)
        ) t2
WHERE t1.매출월 = t2.매출월 ;
    




--(1) 구매 내역이 없는 고객을 출력하시오(member, cart, prod)

SELECT *
FROM member a
WHERE not exists (select * 
                  from cart 
                  where cart_member = a.mem_id);

SELECT *
FROM member a
   , cart b
WHERE a.mem_id = b.cart_member (+)
AND b.cart_member is null;


--2문제 :고객별 가장 돈을 많이 쓴 상품을 출력하시오 (member, cart, prod)
--(1) 조인
--(2) 고객별, 상품별 구매금액(수량 * 판매금액[prod_sale]) 큰순으로 랭킹 구하기 
--(3) 랭킹 1 조회 

---------------------------------------------------------------------------------------------------------------------------- 총문제 10개 
