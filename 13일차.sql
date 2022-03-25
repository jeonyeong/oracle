/* Window절 
   Rows : 로우단위로 범위 지정
   Range : 논리적 단위로 범위 지정 
   
   unbounded preceding : 파티션으로 구분된 첫번째 로우가 시작지점 
   unbounded following : 파티션으로 구분된 마지막 로우가 끝지점 
   current row : 현재 로우 
*/
SELECT department_id 
      ,emp_name
      ,hire_date
      ,sum(salary) over(partition by department_id 
                        order by hire_date
                        rows between unbounded preceding 
                        and unbounded following 
                        ) as all_salary 
      ,salary
       ,sum(salary) over(partition by department_id 
                        order by hire_date
                        rows between unbounded preceding 
                        and current row 
                        ) as curr_salary 
FROM employees
WHERE department_id in(30,90);

/*  월별 누적금액을 출력하시오 
    reservation, order_info 사용 
    날짜 : reserv_date, 매출 : sales
*/

select reserv_no 
     , reserv_date 
from reservation;

select reserv_no
     , sales
from order_info;

select c.months
     , c.amt
     , sum(amt) over(order by months 
                     rows between unbounded preceding and current row) as 누적집계  
    , round(ratio_to_report(amt) over() * 100,2)  as 비율  
from (
        select substr(a.reserv_date,1,6) as months
             , sum(b.sales) amt
        from reservation a
            ,order_info b
        where a.reserv_no  = b.reserv_no
        group by substr(a.reserv_date,1,6)
    ) c;
    
    

select t1.months, nvl(c.amt,0) as 월매출 
     , nvl(sum(c.amt) over(order by t1.months 
                     rows between unbounded preceding and current row),0) as 누적집계 
from (select '2017' || lpad(level,2,'0') as months  from dual connect by level <= 12) t1
    ,(select substr(a.reserv_date,1,6) as months
             , sum(b.sales) amt
        from reservation a
            ,order_info b
       where a.reserv_no  = b.reserv_no
       group by substr(a.reserv_date,1,6) ) c
where t1.months = c.months(+);

select hire_date
    , salary
    , sum(salary) over(order by hire_date
                       rows between 3 preceding and 1 preceding ) pre3_1
    , sum(salary) over(order by hire_date
                      rows between 1 following and 3 following ) fol1_3
from employees
where department_id in (60,90);

-- range 논리적 범위 
select department_id
    , emp_name
    , hire_date
    , salary
    , sum(salary) over(partition by department_id 
                       order by hire_date
                       range 365 preceding) as pre365
    , sum(salary) over(partition by department_id
                      order by hire_date
                      range between 365 preceding and UNBOUNDED following) as cur365
from employees
where department_id in(30,60);

-- FIRST_VALUE 주어진 그룹에서 첫번째 , LAST_VALUE 주워진그룹에서 마지막 , NTH_VALUE n번째 
SELECT department_id, emp_name, hire_date, salary
      ,FIRST_VALUE(salary) over(partition by department_id order by hire_date
                                rows between unbounded preceding and current row) as fir
      ,LAST_VALUE(salary) over(partition by department_id order by hire_date
                                rows between unbounded preceding and current row) as las
      ,NTH_VALUE(salary,2) over(partition by department_id order by hire_date
                                rows between unbounded preceding and current row) as nt
FROM employees
WHERE department_id in (30,60);


select t1.*
     , round(ratio_to_report(t1.amt) over() * 100,2) || '%'as ratio
from ( select substr(period,1,4) as years
             , region 
             , sum(loan_jan_amt) as amt
        from kor_loan_status
        where substr(period,1,4) ='2013'
        group by substr(period,1,4)
               , region 
      ) t1;


                                




                       










/* WITH 
   별칭으로 사용한 select 문이 참조 가능함 
   반복되는 서브쿼리면 변수처럼 사용가능 
   통계쿼리나 튜닝시 많이 사용 
   temp 라는 임시 테이블을 사용해서 장시간 걸리는 쿼리결과를 저장하여 이용  oracle 9이상 지원 
   장점 : 가독성이 좋음 
   단점 : 메모리에 부담을 줄 수 있음 
*/
WITH a as ( select employee_id
                  ,emp_name
            from employees
)
select *
from a;

-- 학생의 학번과 수강내역건수 
select a.학번, a.이름, count(a.수강내역번호) as 수강내역건수
from (select 학생.학번 
             , 학생.이름
             , 학생.학기
             , 수강내역.수강내역번호 
             , 수강내역.과목번호 
        from 학생 
           , 수강내역
        where 학생.학번 = 수강내역.학번(+)
    ) a
group by a.학번 
       , a.이름 ;


WITH 별칭 as (
   select 
)
, 별칭2 as (
   select 
)
, 별칭3 as (
   select 
)
select *
from 별칭 ;


/*  고객별 매출 
    상품별 매출 
    요일별 매출 
    member, cart, prod 
*/
WITH t1 as (SELECT a.mem_id, a.mem_name, b.cart_qty, c.prod_id
                  ,c.prod_name,c.prod_sale
            FROM member a 
               , cart b
               , prod c
            WHERE a.mem_id = b.cart_member
            AND   b.cart_prod = c.prod_id           
)
, t2 as (-- 고객별 집계 
          SELECT t1.mem_id, t1.mem_name
                ,sum(t1.cart_qty *t1.prod_sale)
          FROM t1
          GROUP BY t1.mem_id, t1.mem_name 
)
--, t3 as (-- 상품별 집계 
          SELECT t1.prod_id , t1.prod_name
                ,sum(t1.cart_qty *t1.prod_sale)
          FROM t1
          GROUP BY t1.prod_id , t1.prod_name;













WITH t1 as (select 학생.학번 
                 , 학생.이름
                 , 학생.학기
                 , 수강내역.수강내역번호 
                 , 수강내역.과목번호 
            from 학생 
               , 수강내역
            where 학생.학번 = 수강내역.학번(+)
)
, t2 as ( 
          select t1.학번 
               , t1.이름
               , count(t1.수강내역번호) 
          from t1
          group by t1.학번 
                 , t1.이름;
)
, t3 as ( 
         select a.과목이름 
               ,a.과목번호 
               ,a.학점 
               ,t1.학번 
         from 과목 a
            , t1
         where a.과목번호 = t1.과목번호 
)
select *
from t3;























     
select '2017' || lpad(level,2,'0') as months
from dual 
connect by level <= 12;















SELECT t1.months
     ,nvl(c.sales,0) as 월매출
     ,nvl(SUM(c.sales) OVER(order by t1.months
                        rows between unbounded preceding and current row),0) as  누적집계
FROM (select '2017' || lpad(level,2,'0') as months
             from dual
             connect by level <=12
      ) t1
     ,( SELECT substr(a.reserv_date,1,6) as months
          , sum(b.sales) as sales
     FROM RESERVATION a 
         ,ORDER_INFO b
     WHERE a.reserv_no = b.reserv_no
     GROUP BY substr(a.reserv_date,1,6)
     ORDER BY 1 
     ) c
where t1.months = c.months (+)
     
;
             
             
select t1.months
      , nvl(t2.sales,0)
      , nvl(t2.누적집계,0)
from (select '2017' || lpad(level,2,'0') as months
             from dual
             connect by level <=12
      ) t1
    , (SELECT c.*
             ,SUM(c.sales) OVER(order by months
                                rows between unbounded preceding and current row) as  누적집계
        FROM ( SELECT substr(a.reserv_date,1,6) as months
                  , sum(b.sales) as sales
             FROM RESERVATION a 
                 ,ORDER_INFO b
             WHERE a.reserv_no = b.reserv_no
             GROUP BY substr(a.reserv_date,1,6)
             ORDER BY 1 ) c
       ) t2
where t1.months = t2.months(+)
order by 1;

      