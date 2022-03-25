/* 분석함수 : 테이블에 있는 로우에 대해 특정 그룹별로 집계 값을 산출할 때 사용 
             보통은 그룹 쿼리를 사용하는 이때 GROUP BY 절에 의해 최종 쿼리 결과는 
             그룹렬로 로우수가 줄어 든다 
             하지만 분석함수를 사용하면 로우 손실 없이 집계값 산출 
   분석함수(매개변수) OVER (PARTITION BY expr1, expr2..
                         ORDER BY expr3, expr4...
                         WINDOW 절) 
*/
SELECT COUNT(employee_id)
FROM employees;
-- AVG, SUM, MAX, MIN, COUNT
SELECT COUNT(employee_id) OVER()
     , ROUND(AVG(salary) OVER(),2) as 평균급여 
     , ROUND(AVG(salary) OVER(PARTITION BY department_id),2) as 부서평균급여
     , department_id                      
     , emp_name
FROM employees;

SELECT *
FROM (SELECT rownum as rnum 
            , count(*) over() as 전체건수 
            ,a.*
       FROM (SELECT emp_name
                  , email
                  , salary
             FROM employees
             ORDER BY emp_name
        ) a
    )
WHERE rnum between 1 and 10
;
-- RANK()      '순위반환' 동일 값이 있을 경우 1 2 2 4 <- 중복 건너뜀 
-- DENSE_RANK()'순위반환' 동일 값이 있어도  건너 뛰지 않음  1 2 2 3
SELECT emp_name
    , department_id 
    , salary
    , RANK() OVER( PARTITION BY department_id 
                   ORDER BY salary desc ) as 부서별급여순위
    , DENSE_RANK() OVER( PARTITION BY department_id 
                   ORDER BY salary desc ) as 부서별급여순위2
    , RANK() OVER(ORDER BY salary desc ) as 전체급여순위
FROM employees;


-- 학생의 전공별 평점기준으로 순위를 출력하시오 DENSE_RANK 사용 



SELECT 이름 
     , 전공
     , 평점 
     , DENSE_RANK() OVER(PARTITION BY 전공 
                         ORDER BY 평점 desc) as 순위 
     , DENSE_RANK() OVER(ORDER BY 평점 desc) as 전체순위 
FROM 학생
ORDER BY 2;

SELECT*
FROM (SELECT 이름 
             , 전공
             , 평점 
             , DENSE_RANK() OVER(PARTITION BY 전공 
                                 ORDER BY 평점 desc) as 순위 
             , DENSE_RANK() OVER(ORDER BY 평점 desc) as 전체순위 
        FROM 학생
        ORDER BY 2
      )
WHERE 전체순위 <= 3
ORDER BY 전체순위
;
-- 전체순위  1 ~ 3등만 출력하시오 
/*
 NTILE(expr) 파티션별로 expr에 명시된 값 만큼 분할한 결과 반환 
 NTILE(3) 1 ~ 3 수를 반환 분할하는 수를 버킷 수라고 함. 
*/
SELECT department_id
    , emp_name 
    , salary
    , COUNT(*) OVER(PARTITION BY department_id) as cnt
    , NTILE(3) OVER(PARTITION BY department_id
                    ORDER BY salary ) as ntiles
FROM employees
WHERE department_id IN(30, 60);

-- 부서별 급여를 4분위로 나누었을때 1분위에 속하는 직원만 출력하시오 


SELECT *
FROM (
        SELECT department_id
            , emp_name 
            , salary
            , NTILE(4) OVER(PARTITION BY department_id
                            ORDER BY salary) as 분위
        FROM employees
     )
WHERE 분위 = 1;


SELECT department_id
            , emp_name 
            , salary
            , NTILE(4) OVER(PARTITION BY department_id
                            ORDER BY salary) as 분위
            , WIDTH_BUCKET(salary, 1000, 10000, 4) as width
            -- 1000 ~ 3250 , 3250 ~ 5500 ... 
FROM employees
WHERE department_id IN(30, 60);

/* LAG  선행로우 값 반환 
   LEAD 후행로우 값 반환 
*/
SELECT emp_name
     , salary
     , department_id
     , LAG(to_char(salary), 1, '가장높음') OVER(PARTITION BY department_id  
                                        ORDER BY salary DESC) as lag_name
     , LEAD(to_char(salary), 1, '가장낮음') OVER(PARTITION BY department_id  
                                        ORDER BY salary DESC) as lead_name
FROM employees
WHERE department_id = 30;

-- 학생의 '전공별' '평점'을 기준으로 한단계 위(점수 높은)의
-- '학생이름'과 '평점 차이'를 출력하시오  (점수 소수점 2째자리 반올림) 

SELECT 이름 
     , 전공
     , round(평점 ,2) as 평점 
     , ROUND(LAG(평점, 1, 평점) OVER(PARTITION BY 전공
                               ORDER BY 평점 desc) - 평점,2) 나보다위평점차이 
     , LAG(이름, 1, '1등') OVER(PARTITION BY 전공
                               ORDER BY 평점 desc) 나보다위
FROM 학생;



/* 2013년도 대출금이 많은 5개 지역의 정보를 출력하시오 (kor_loan_status)*/
-- 
select *
from (select a.*
            , rank() over(order by a.amt desc) as ranks
        from ( select substr(period, 1, 4) as years
                      ,region
                      ,sum(loan_jan_amt) as amt 
                from kor_loan_status
                where substr(period, 1, 4) = '2013'
                group by substr(period, 1, 4)
                        ,region
             ) a
      )
where ranks <= 5;
       
select *
from ( select substr(period, 1, 4) as years
              ,region
              ,sum(loan_jan_amt) as amt 
              ,rank() over(order by sum(loan_jan_amt) desc) as ranks
        from kor_loan_status
        where substr(period, 1, 4) = '2013'
        group by substr(period, 1, 4)
                ,region       
      )
where ranks <= 5
;








select *
from (
select substr(period,1,4) as 년도
     , region
     , sum(loan_jan_amt) as 대출합산금액
     , rank() over(order by  sum(loan_jan_amt) desc ) as  순위 
from kor_loan_status
where substr(period,1,4) = '2013'
group by substr(period,1,4)
      , region 
order by 4 )
where 순위 <= 5;






