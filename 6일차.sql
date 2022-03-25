-- 집계함수 
SELECT COUNT(*)                      -- null 포함 
     , COUNT(department_id)          -- defualt all
     , COUNT(ALL department_id)      -- 중복포함 
     , COUNT(DISTINCT department_id) -- 중복 제거
FROM employees;

SELECT SUM(salary)  -- 합계 
     , AVG(salary)  -- 평균 
     , MIN(salary)  -- 최소 
     , MAX(salary)  -- 최대 값 
FROM employees;

-- 50번 부서의 평균 급여와 직원수를 구하시오 (employees)
-- 소수점 2째 자리까지 
select ROUND(AVG(salary),2) as 평균 
     , COUNT(employee_id) as 직원수 
from employees
where department_id = 50;
-- GROUP BY 절 
SELECT department_id
     , ROUND(AVG(salary),2) 부서월급평균
     , COUNT(employee_id)   직원수 
FROM employees
WHERE department_id is not null
GROUP BY department_id  -- 그룹집계 대상 
ORDER BY 1
;


SELECT department_id
     , job_id  
     , ROUND(AVG(salary),2) 부서월급평균
     , COUNT(employee_id)   직원수 
FROM employees
WHERE department_id is not null
GROUP BY department_id, job_id  -- 그룹집계 대상 
ORDER BY 1;

-- 2013년도의 지역별 총대출잔액을 조회하시오 
-- kor_loan_status 테이블 활용 
select period
     , region
     , sum(loan_jan_amt) 대출잔액
from kor_loan_status
--where period like '2013%'
where substr(period,1,4) = '2013'
group by period, region
order by 1 ;



-- '서울','대전','부산'의 
-- 년도별, 지역별 대출잔액합계를 구하시오 
select substr(period,1,4) as 년도 
      ,region 
      ,sum(loan_jan_amt)  as "대출 잔액합계"
from kor_loan_status
where region in('서울','대전','부산')
group by substr(period,1,4)
        ,region 
order by 1;

select COUNTRY_REGION
     , COUNTRY_SUBREGION
     , country_name
from countries
group by COUNTRY_REGION
       , COUNTRY_SUBREGION
       , country_name
order by 1;


-- 고용년도별 급여평균, 사원수를 출력하시오 
-- employees 테이블의 hire_date 활용
desc employees;
select to_char(hire_date,'YYYY') as 고용년도 
     , round(avg(salary),2) as 평균 
     , count(*) as 직원수 
from employees
group by to_char(hire_date,'YYYY')
having count(*) >= 10 -- 집계결과에 조건필요할때 
order by 직원수 ;
--FROM-> WHERE ->GROUP By-> HAVING ->SELECT ->ORDER BY 

-- 직원이 10명 이상인 부서만 출력하시오 (employees)
select department_id
    ,  count(*)
from employees
group by department_id 
having count(*) >=10;
/*
 ROLLUP(expr1, expr2...) 말아 올린다. 
 expr로 명시한 표현식을 기준으로 집계한 결과를 출력함 
 표현식 수가 n 개이면 n + 1 레벨까지 집계 
*/
SELECT period
     , gubun
     , sum(loan_jan_amt) 합계 
FROM kor_loan_status
where period like '2013%'
group by rollup(period, gubun);
/*
201310	기타대출   	676078      (3)  소계
201310	주택담보대출	411415.9    (3)  소계 
201310		        1087493.9   (2)  기간의 총계 
201311	기타대출	    681121.3    (3)  소계 
201311	주택담보대출	414236.9    (3)  소계 
201311		        1095358.2   (2)  기간의 총계 
    	            2182852.1   (1)  전체 총계 

*/
SELECT period
     , sum(loan_jan_amt) 합계 
FROM kor_loan_status
where period like '2013%'
group by rollup(period);

-- NULL 관련 함수 
select emp_name
      , salary
      , NVL(commission_pct,0) as commission_pct
      , salary * NVL(commission_pct,0) 
from employees;


select department_id
    , count(*) 직원수 
from employees
group by department_id
having count(*) >=10;




 
-- 집합 연산자 UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
 ORDER BY seq;

SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
 ORDER BY seq;
 
-- 중복 제거 집합 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';
 
 
 

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION ALL  -- 중복 상관 없이 출력결과를 결합 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';
 
 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT     -- 교집합 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
 
 
 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
MINUS  -- 차집합 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';  
 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
MINUS
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국';   
 
 
SELECT 1, goods   -- 집합은 컬럼의 수와 타입이 일치해야함 
  FROM exp_goods_asia
 WHERE country = '한국'
UNION 
SELECT seq, goods  
  FROM exp_goods_asia
 WHERE country = '일본'
 order by 1; 
 
 
 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '일본';  
 
 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '일본';  
 
SELECT seq
  FROM exp_goods_asia
 WHERE country = '한국'
UNION
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';   
 
 
 SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
 ORDER BY goods
UNION
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
 
 
 SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
  ORDER BY goods;  




select to_char(hire_date,'YYYY') 입사년도 
     , round(avg(salary),2)      급여평균
     , count(*)                  직원수 
from employees
group by to_char(hire_date,'YYYY')
order by 1;





select substr(period,1,4) as 년도 
     , region
     , sum(loan_jan_amt) 대출잔액
from kor_loan_status
where region in ('서울','대전','부산')
group by substr(period,1,4), region
order by 1 ;


desc kor_loan_status;




select region
    , sum(loan_jan_amt) 잔액
from kor_loan_status
where period like '2013%'
group by region
order by region ;







/*
employees 테이블 부서id가 있는 데이터에서 조회
부서별, 입사월의 사원수, 총급여  employees 테이블 , hire_date, salary 컬럼이용
ex) to_char, decode, sum, rollup 

               1월 2월 3월 4월 5월 6월 7월  8월 9월 10월 11월 12월 전체사원수 급여합산
            10	0	0	0	0	0	0	0	0	1	0	0	0	1	4400
            20	0	1	0	0	0	0	0	1	0	0	0	0	2	19000
            30	0	0	0	0	1	0	1	1	0	0	1	2	6	24900
            40	0	0	0	0	0	1	0	0	0	0	0	0	1	6500
            50	5	8	4	4	2	5	6	3	1	4	1	2	45	156400
            60	1	2	0	0	1	1	0	0	0	0	0	0	5	28800
            70	0	0	0	0	0	1	0	0	0	0	0	0	1	10000
            80	6	2	4	2	4	2	2	3	1	3	3	2	34	304500
            90	1	0	0	0	0	1	0	0	1	0	0	0	3	58000
            100	0	0	1	0	0	0	0	2	2	0	0	1	6	51608
            110	0	0	0	0	0	2	0	0	0	0	0	0	2	20308
	            13	13	9	6	8	13	9	10	6	7	5	7	106	684416
*/

desc employees;

select department_id
     , sum(decode(to_char(hire_date,'MM'),'01',1,0)) as jan
     , sum(decode(to_char(hire_date,'MM'),'02',1,0)) as fed
     , sum(decode(to_char(hire_date,'MM'),'03',1,0)) as mar
     , sum(decode(to_char(hire_date,'MM'),'04',1,0)) as apr
     , sum(decode(to_char(hire_date,'MM'),'05',1,0)) as may
     , sum(decode(to_char(hire_date,'MM'),'06',1,0)) as jun
     , sum(decode(to_char(hire_date,'MM'),'07',1,0)) as jly
     , sum(decode(to_char(hire_date,'MM'),'08',1,0)) as aug
     , sum(decode(to_char(hire_date,'MM'),'09',1,0)) as sep
     , sum(decode(to_char(hire_date,'MM'),'10',1,0)) as oct
     , sum(decode(to_char(hire_date,'MM'),'11',1,0)) as nov
     , sum(decode(to_char(hire_date,'MM'),'12',1,0)) as dec
     , count(*)    as tol_cnt
     , sum(salary) as tol_sum
from employees
where department_id is not null
group by rollup(department_id)
order by 1
;



/*
sales 테이블에서 '년도별' 상품 '매출액(amount_sold )'을 
일요일부터 월요일까지 구분해 출력하시오 
날짜(sales_date), 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일, 년총합의 
매출을 구하시오 
*/






 
SELECT to_char(sales_date,'yyyy') 날짜
         , to_char(SUM(DECODE(to_char(sales_date,'D'),'1',amount_sold,0)),'99,999,999.99') 일요일
         , to_char(SUM(DECODE(to_char(sales_date,'D'),'2',amount_sold,0)),'99,999,999.99') 월요일
         , to_char(SUM(DECODE(to_char(sales_date,'D'),'3',amount_sold,0)),'99,999,999.99') 화요일
         , to_char(SUM(DECODE(to_char(sales_date,'D'),'4',amount_sold,0)),'99,999,999.99') 수요일
         , to_char(SUM(DECODE(to_char(sales_date,'D'),'5',amount_sold,0)),'99,999,999.99') 목요일
         , to_char(SUM(DECODE(to_char(sales_date,'D'),'6',amount_sold,0)),'99,999,999.99') 금요일
         , to_char(SUM(DECODE(to_char(sales_date,'D'),'7',amount_sold,0)),'99,999,999.99') 토요일
         , to_char(sum(amount_sold),'99,999,999.99') as 총합 
FROM sales
group by rollup(to_char(sales_date,'yyyy'))