/* 서브쿼리 sub query 
   SQL문장안에 보조로 사용되는 또다른 select 문 
   형태에 따라 
   1.일반 서브쿼리  (select 절 ) : 스칼라서브쿼리라고도 함. 
   2.인라인 뷰      (from 절) 
   3.중첩 쿼리      (where 절)  
*/

select a.emp_name
     , b.department_name
from employees a 
   , departments b
where a.department_id = b.department_id;

--1.조회 대상건이 1건만 조회되어야함 
--2.메인 쿼리의 모든 행이 검색을 하기 때문에 
--  대상 테이블의 건수가 적어야 함.
select a.emp_name
     , (select department_name 
        from departments 
        where department_id = a.department_id ) as nm
    , (select job_title 
       from jobs 
       where  job_id = a.job_id) as job_nm
from employees a;

-- 인라인 뷰 (from절) : select 결과를 테이블처럼 사용 
select rownum as rnum
     , a.*
from employees a
where rnum between 1 and 10;
        

select  rownum as rnum
      , a.*
from employees a
order by emp_name;


select *
from (
        select rownum as rnum 
            , b.*
        from (
                select a.*
                from employees a
                where a.emp_name =''
                order by emp_name
             )b
    ) 
where rnum between 1 and 10;

--3.where 에 오는 중첩쿼리 

-- 직원 평균 급여이상을 받는 직원의 수 
select count(*)
from employees
where salary >= (select avg(salary)
                 from employees);

select count(*)
from employees
where salary >=6461.831775700934579439252336448598130841;




-- 스칼라 서브쿼리를 사용하여 수강 과목명을 출력하시오 

select  이름
      , 과목번호 
      , (select 과목이름 
         from 과목 
         where 과목번호 = 수강내역.과목번호) as 과목명 
from 학생 
   , 수강내역 
where 학생.학번 = 수강내역.학번;








-- 평점평균 이상인 학생만 조회하시오

select 이름, 평점 
from 학생 
where 평점 >= (select avg(평점)
              from 학생)
;


-- 수강이력이 가장 많은 학생 학번을 출력히시오 
-- ex) 1.수강내역 건수조회 
--     2.수강내역 내림차순 정렬 
--     3.1건만 출력 

select *
from 학생 
where 학번 = (select 학번 
               from (select 학번 
                         , count(*)
                     from 수강내역
                     group by 학번 
                     order by 2 desc)
               where rownum = 1    );
-- 세미조인  exists 존재하는지 체크 
select *
from 학생 a
where not exists (select 12
              from 수강내역 
              where 학번 = a.학번);
select *
from 학생 a
where a.학번 not in (select 학번 
                    from 수강내역 );
                    
                    
-- job_history 가있는 부서의 부서 id, name을 출력하시오 
-- exists 활용,(departments, job_history 테이블 활용)

select a.department_id
     , a.department_name
from departments a
where exists (select * 
             from job_history 
             where department_id = a.department_id);



select *
from 학생 
where rownum = 2;





-- 중첩쿼리 활용 (where)
select 학번 
from (select  학번
             ,count(*)
      from 수강내역
      group by 학번 
      order by 1
     )
where rownum =1 ;
    








select 이름 , 평점 
from 학생 
where 평점 >= (select avg(평점) 
              from 학생);


-- 일반 동등조인
select *
from 학생
   , 수강내역 
   , 과목 
where 학생.학번 = 수강내역.학번
and   수강내역.과목번호 = 과목.과목번호 ;
-- ANSI 동등조인 
select *
from 학생 
inner join 수강내역 
on (학생.학번 = 수강내역.학번)
inner join 과목 
on (수강내역.과목번호 = 과목.과목번호);
-- 외부조인 outer join 
select *
from 학생
   , 수강내역 
   , 과목 
where 학생.학번 = 수강내역.학번(+)
and   수강내역.과목번호 = 과목.과목번호(+);
-- ANSI 외부조인 LEFT, RIGHT
select *
from 학생
left outer join 수강내역 
on(학생.학번 = 수강내역.학번)
left join 과목 
on(수강내역.과목번호 = 과목.과목번호);



select 학번 
    ,  학생.이름 
from 학생 
inner join 수강내역 
using (학번); -- 컬럼명이 동일할때 

-- full outer join 
create table test_a (emp_id number);
create table test_b (emp_id number);
insert into test_a values (10);
insert into test_a values (20);
insert into test_a values (40);
insert into test_b values (10);
insert into test_b values (20);
insert into test_b values (30);

select *
from test_a a
   , test_b b
where a.emp_id(+) = b.emp_id(+); --문법 오류 
select *
from test_a a
full outer join test_b b
on(a.emp_id = b.emp_id);          -- ansi 가능 




/* sales, customers, countries 테이블 활용 
관련컬럼:sales_month, amount_sold, country_name

  2000년 이탈리아 평균 매출액(연평균) 
  보다 큰 월평균 매출액을 구하시오 
  
  ex) 검색 조건 2000년 매출 
      이탈리아 
      1.연평균, 2.월평균, 3.비교 
*/



SELECT a.* 
  FROM ( SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
           FROM sales a,
                customers b,
                countries c
          WHERE a.sales_month BETWEEN '200001' AND '200012'
            AND a.cust_id = b.CUST_ID
            AND b.COUNTRY_ID = c.COUNTRY_ID
            AND c.COUNTRY_NAME = 'Italy'     
          GROUP BY a.sales_month  
       )  a,
       ( SELECT ROUND(AVG(a.amount_sold)) AS year_avg
           FROM sales a,
                customers b,
                countries c
          WHERE a.sales_month BETWEEN '200001' AND '200012'
            AND a.cust_id = b.CUST_ID
            AND b.COUNTRY_ID = c.COUNTRY_ID
            AND c.COUNTRY_NAME = 'Italy'       
       ) b
 WHERE a.month_avg > b.year_avg ;




-- 구매금액이 가장 많은 고객의 
-- 구매 상품의 제품별, 수량, 구매금액을 출력하시오 