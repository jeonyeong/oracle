-- 데이터 조작어 DML  Data Manipulation Language
-- SELECT, INSERT, UPDATE, DELETE .. 
-- CRUD 대부분의 소프트웨어가 가지는 기본적인 데이터 처리기능 
-- Create, Read, Update, Delete

SELECT *  -- * 전체 
FROM employees;

SELECT emp_name
     , hire_date
     , salary
FROM employees;
-- alias 별칭  as 
SELECT emp_name as en
     , hire_date
     , salary 
     , salary  * 12  as 연봉 
FROM employees;

-- 검색 조건 WHERE , OR, AND 
SELECT emp_name 
     , hire_date
     , salary 
FROM employees
WHERE department_id= 90
AND salary >= 20000;
-- 정렬 ORDER BY 
SELECT emp_name 
     , hire_date
     , salary 
FROM employees
WHERE department_id= 50
--ORDER BY salary desc , emp_name   -- asc 디폴트 
ORDER BY 3 desc ,1   -- 위랑 결과 동일 
;
SELECT *
FROM TB_INFO
WHERE NM = '이앞길';

SELECT *
FROM TB_INFO
ORDER BY NM ;

--INSERT 
--1 전체 
CREATE TABLE ex3_1 (
  col1 VARCHAR2(10)
 ,col2 NUMBER
 ,col3 DATE 
);
INSERT INTO ex3_1 VALUES ('abc',10 , sysdate);
INSERT INTO ex3_1 VALUES ('abc','100' , sysdate);
--2.특정 컬럼에만 
INSERT INTO ex3_1 (col3) VALUES (sysdate);
--3.조회결과를 삽입 
CREATE TABLE ex3_2 (
   info_no number
 , nm varchar2(20)
 );
INSERT INTO ex3_2
SELECT info_no
     , nm
FROM TB_INFO;

SELECT *
FROM ex3_2;
-- UPDATE  수정 
UPDATE tb_info
SET hobby = '요리'
  , pc_no ='SSSAM'
WHERE nm ='이앞길';

commit;
select *
from tb_info;


SELECT *
FROM TB_INFO;
--192.168.20.2 
-- 본인 취미를 업데이트 하시오 





-- 오늘에 문제 
/*
  다음과 같은 구조의 테이블을 생성해 보자.
- 테이블 :  ORDERS
- 컬럼  :   ORDER_ID    NUMBER(12,0)
           ORDER_DATE   DATE
           ORDER_MODE  VARCHAR2(8 BYTE)
           CUSTOMER_ID NUMBER(6,0)
           ORDER_STATUS NUMBER(2,0)
           ORDER_TOTAL NUMBER(8,2)
           SALES_REP_ID NUMBER(6,0)
           PROMOTION_ID NUMBER(6,0)
- 제약사항 : 기본키는 ORDER_ID  
             ORDER_MODE에는 'direct', 'online'만 입력가능
             ORDER_TOTAL의 디폴트 값은 0

          
*/






