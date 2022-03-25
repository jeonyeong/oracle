-- 1.유저생성  study/study      <-- DBA권한이 필요함 
-- 2.권한부여 resouce, connect  <-- DBA권한이 필요함 
-- 3.study 계정으로 접속 후 예제테이블 실행
-- 4.member 테이블에서 김씨만 출력하시오

SELECT *
FROM member;

-- 대전에 거주하는 고객을 조회하시오 직업이(주부, 학생)인  
SELECT mem_name                           /*고객이름 */
     , mem_add1 ||' ' ||mem_add2 as 주소  /*주소    */
     , mem_job                            /*직업    */
FROM member
WHERE MEM_add1 like '%대전%'
AND mem_job in ('주부','학생')
ORDER BY 1 ;

/* 숫자 함수 */
-- ABS 절대값 반환 
SELECT ABS(-10)       
    ,  ABS(-10.123)
FROM dual;
-- ROUND(n, i ) n을 소수점 기준 (i + 1) 번째에서 반올림 
SELECT ROUND(10.154)
     , ROUND(10.541)
     , ROUND(10.154, 1)
     , ROUND(10.154, 2)
     , ROUND(11.154, -1) -- 음수 소수점 기준 왼쪽 i 반올림 
FROM dual;
-- TRUNC 버림 나머지는 ROUND와 동일 
-- MOD(m, n) m 을 n으로 나우었을때 나머지 반환 
SELECT MOD(4,2) 
     , MOD(19,4)
FROM dual;

-- 날짜 함수 
SELECT ADD_MONTHS(sysdate, 1)
     , ADD_MONTHS(sysdate,-1)
FROM dual ;

-- MONTHS_BETWEEN 차이 계산 
SELECT MONTHS_BETWEEN(sysdate, ADD_MONTHS(sysdate, 1)) 
     , MONTHS_BETWEEN(ADD_MONTHS(sysdate, 1), sysdate)
FROM dual;
-- LAST_DAY 
SELECT LAST_DAY(sysdate) -- 마지막 일자 반환 
      , sysdate + 1
      , sysdate + 2
      , LAST_DAY(sysdate) -  sysdate
FROM dual;
-- NEXT_DAY 다음 해당 요일의 날짜 반환 
SELECT NEXT_DAY(sysdate, '토요일')
FROM dual;
-- 20050101
-- 변환 함수 TO_CHAR 문자 데이터타입으로 
--          TO_DATE 날짜 데이터타입으로 
--          TO_NUMBER 숫자 데이터타입으로 
SELECT TO_CHAR(123456789, '999,999,999')
     , TO_CHAR(sysdate, 'YYYY.MM.DD')
     , TO_CHAR(sysdate, 'YYYY')
     , TO_CHAR(sysdate, 'YYYYMMDD HH:MI:SS')
     , TO_CHAR(sysdate, 'YYYYMMDD HH24:MI:SS')
     ,sysdate
FROM dual;
 
 SELECT TO_DATE('20140101', 'YYYYMMDD')
      , SYSDATE - TO_DATE('20140101', 'YYYYMMDD')
      , TO_DATE('2014_01_01', 'YYYY_MM_DD')
      , TO_DATE('2014_01_01 11:12:30', 'YYYY_MM_DD HH24:MI:SS')
 FROM dual;
 
 select *
 from MEMBER;
 
 -- 고객의 나이를 출력하시오 
 -- 나이계산은 2022년 - 출생년 으로 계산 
 DESC member;
 
SELECT mem_name
      ,to_char(sysdate,'YYYY') - to_char(mem_bir,'YYYY') as 나이
FROM member
WHERE to_char(sysdate,'YYYY') - to_char(mem_bir,'YYYY') >= 50 
ORDER BY 2;
-- 50세 이상만 조회하시오                                                                                                                            
CREATE TABLE ex5_1 (
  col1 varchar2(100)
);
INSERT INTO ex5_1 VALUES('112');
INSERT INTO ex5_1 VALUES('99');
INSERT INTO ex5_1 VALUES('999');
INSERT INTO ex5_1 VALUES('1111');

select *
from ex5_1 
order by to_number(col1) desc;
 
 
 
 SELECT mem_name
      , to_char(sysdate,'YYYY') - to_char(mem_bir,'YYYY')  as 나이 
      , mem_bir
 FROM member;

-- 문자함수 TRIM 공백제거 
SELECT LTRIM(' ABC ')  -- 왼쪽 
     , RTRIM(' ABC ')  -- 오른쪽 
     , TRIM(' ABC ')   -- 양쪽 
FROM dual;
-- PAD  RPAD 오른쪽 채우기, LPAD 왼쪽 
SELECT LPAD(123, 5, '0')
     , LPAD(12, 5, '0')
     , LPAD(1, 5, '0')
     , LPAD(122226, 5, '0')
     , RPAD(123, 5, '0')
FROM dual;


SELECT CASE WHEN cust_gender = 'M' THEN '남자'
           WHEN  cust_gender = 'F' THEN '여자'
       END as gender
     , DECODE(cust_gender, 'M','남자','여자') as 성별
                        -- 조건1 결과1 조건2 결과2 ....
FROM customers;
-- 문제 member 고객의 이름과 성별을 출력하시오 
-- ex) substr, decode 
SELECT  mem_name
      , decode(substr(mem_regno2,1,1),1,'남자',2,'여자') as 성별
FROM member;

--고객 hometel 전화번호 표현을 
--042-621-4615	-> (042)621-4615
--02-888-9999	-> (02)888-9999  아래와 같이 만들어 주세요 




SELECT mem_name
     ,mem_hometel
     ,'('||substr(mem_hometel, 1, instr(mem_hometel,'-')-1)||')'||
          substr(mem_hometel,instr(mem_hometel,'-')+1) as 전화번호 
FROM member;


---- [문제1]
---- 현재일자를 기준으로 사원 테이블에서 (employees)
---- 근속 년수가 20년 이상인 사원을 출력하시오 근속년수 내림차순으로 
---- ex) 1년은 365일, round 사용 
--SELECT employee_id
--     , emp_name
--     , to_char(sysdate,'YYYY') - to_char(hire_date,'YYYY') as 근속년수
--     , hire_date
--FROM employees
--WHERE to_char(sysdate,'YYYY') - to_char(hire_date,'YYYY') >= 20
--ORDER BY 3 desc;


/*
 2022.02.18 오늘에 문제 
 고객의 출생년도를 활용하여 (customers)테이블 
 30대, 40대, 50대를 구분하여 출력하시오 (나머지지는 기타) 
 ex) trunc, decode, to_char 사용 
*/


SELECT cust_name
     , cust_year_of_birth
     , to_char(sysdate,'YYYY') - cust_year_of_birth as 나이
     , decode(trunc((to_char(sysdate,'YYYY') - cust_year_of_birth)/10)
             ,3,'30대',4,'40대',5,'50대','기타') generation
from customers
order by 1
;


















SELECT mem_name
     , mem_add1 || ' ' ||mem_add2 as 주소
     , mem_job
FROM member
WHERE mem_job in ('주부','학생')
AND mem_add1 like '%대전%'
order by 1;









