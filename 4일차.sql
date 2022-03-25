-- 표현식 CASE문 
SELECT employee_id 
     , salary
     , CASE WHEN salary > 15000 THEN 'A등급'
            WHEN salary > 5000 AND salary <=15000 THEN 'B등급'
            WHEN salary <= 5000 THEN 'C등급'
        ELSE '나머지'

        END as salary_grade
FROM employees; 

-- 문자 연산자 || 
SELECT employee_id
     , emp_name
     , '사번:' || employee_id || ' 이름:' ||emp_name as doc
FROM employees;
-- 수식 연산자 
SELECT emp_name 
      , salary                as 월급 
      , round(salary / 30,2)  as 일당 
      , salary * 12           as 연봉 
FROM employees;
-- 논리 연산자 
SELECT * FROM employees WHERE salary > 15000; -- 초과 
SELECT * FROM employees WHERE salary < 3000;  -- 미만 
SELECT * FROM employees WHERE salary >=15000; -- 이상  
SELECT * FROM employees WHERE salary <= 3000; -- 이하 
SELECT * FROM employees WHERE department_id != 50; --아닌 
SELECT * FROM employees WHERE department_id <> 50; --아닌 
SELECT * FROM employees WHERE department_id ^= 50; --아닌 

-- NULL (null 여부는 연산자를 사용하면 비교하지 못함)
SELECT *
FROM departments
WHERE parent_id is not null; -- null이 아닌

-- employees 테이블의 commission_pct 데이터가 
-- 널이면 '없음', 아니면 '있음' 을 출력하시오 
-- ex) case , is null
SELECT employee_id
     , emp_name
     , commission_pct
     , CASE WHEN commission_pct is null THEN '없음'
            ELSE '있음'
       END as p_yn
FROM employees;
-- ROWNUM : 의사컬럼_테이블에는 없지만 있는것 처럼 사용 
--BETWEEN a AND b  : a ~ b 사이 값인 로우 검색 
SELECT *
FROM (
        SELECT rownum  as rnum
              ,emp_name 
              ,employee_id
        FROM employees
      )
WHERE rnum BETWEEN 21 AND 30;



SELECT rownum  as rnum
      ,emp_name 
      ,employee_id
FROM employees
ORDER BY emp_name desc;

-- IN 조건식 
SELECT employee_id 
     , salary
FROM employees
--WHERE salary IN (2000,3000,4000); -- OR과 같음 
WHERE salary NOT IN (2000,3000,4000); -- not 아닌것 
-- 30,40번 부서 직원만 조회하시오 


SELECT emp_name
     , department_id
FROM employees
--WHERE department_id in (30,40);
WHERE department_id = 30
OR department_id = 40;

-- LIKE 조건식 **
SELECT emp_name
FROM employees
--WHERE emp_name LIKE 'A%';
--WHERE emp_name LIKE '%n';
WHERE emp_name LIKE '%Smith%';

CREATE TABLE ex4_1 (
 names varchar2(30)
);
INSERT INTO ex4_1 VALUES ('홍길');
INSERT INTO ex4_1 VALUES ('홍길동');
INSERT INTO ex4_1 VALUES ('홍길용');
INSERT INTO ex4_1 VALUES ('홍길용동');
SELECT *
FROM ex4_1 
WHERE names LIKE '_길_';


-- 직원 이름에 David 또는 King 이 들어가는 직원을 조회하시오 



SELECT *
FROM employees
WHERE emp_name like '%David%'
OR emp_name like '%King%';





SELECT employee_id
     , emp_name
     , commission_pct
     , case when commission_pct is null then '없음'
         else '있음'
       end as c_yn
FROM employees;










-- CUSTOMERS 테이블에서  1986년 이후 출생자를 조회하시오 
-- 어린 친구 
SELECT *
FROM CUSTOMERS
WHERE cust_year_of_birth >=1989
ORDER BY cust_year_of_birth desc;

desc CUSTOMERS;


-- 함수 : 오라클에서 함수는 무조건 리턴값이 1개 있어야함.
-- 문자 함수 : INITCAP, LOWER, UPPER 
SELECT emp_name
     , INITCAP(emp_name) -- 앞글자 대문자 
     , INITCAP('lee ap')
     , LOWER(emp_name)   -- 소문자 
     , UPPER(emp_name)   -- 대문자 
FROM employees;

SELECT *
FROM employees
WHERE lower(emp_name) like '%'||lower('david')||'%'
OR lower(emp_name) like '%'||lower('KinG')||'%';

--SUBSTR(char, pos, len)
--문자열인 char의 pos 번째 부터 len길이 만큼 자른뒤 반환 
--pos 값으로 0이 오면 디폴드 값인 1  즉 첫번째 문자를 의미함 
--음수가 오면 char 문자열 맨 끝에서 시작한 상대적 위치를 의미 
--len 값이 생략되면 pos 번째 부터 나머지 모든 문자 반환 
SELECT SUBSTR('ABCD EFG',2,4)
     , SUBSTR('ABCD EFG',0,4)
     , SUBSTR('ABCD EFG',-4,3)
     , SUBSTR('ABCD EFG',-4,1)
     , SUBSTR('ABCD EFG',5)
FROM DUAL;
-- INSTR 문자열 인덱스값 반환 
SELECT INSTR('ABC AB ABD AB','AB') as instr1
     , INSTR('ABC AB ABD AB','AB',1, 2) as instr2
     , INSTR('ABC AB ABD AB','AB',1, 3) as instr3
     , INSTR('ABC AB ABD AB','AB',1, 4) as instr4
     , INSTR('ABC AB ABD AB','AB',1, 5) as instr5
             --대상 문자열, 찾는문자열, 시작위치, 번째 
FROM dual;
-- REPLACE 치환 
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?','나','너')
FROM dual;

--customers 테이블에서 CUST_EMAIL 컬럼의 
--이메일 주소의 @ 기준으로 앞은 '아이디' 
--            @ 기준으로 뒤는 '도메인' 으로 출력하시오 
--ex) 1:인덱스 값을 구한다. 2:알맞게 자른다.

SELECT substr(cust_email, 1, instr(CUST_EMAIL,'@')-1) as 아이디
     , substr(cust_email,instr(CUST_EMAIL,'@')+1) as 도메인
     , cust_email
FROM customers;
SELECT length('오라클')
FROM customers;

-- 유저생성  study/study
create user study identified by study;
-- 권한부여 resouce, connect
grant connect, resource to study;
-- study 계정으로 접속 후 예제테이블 실행     



  






SELECT 
      cust_email
     , substr(cust_email, 1,instr(cust_email,'@')-1) as 아이디
     , substr(cust_email, instr(cust_email,'@')+1)   as 도메인 
FROM customers;



