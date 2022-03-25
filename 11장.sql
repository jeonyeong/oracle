SELECT department_id, 
       department_name, 
       0 AS PARENT_ID,
       1 as levels,
        parent_id || department_id AS sort
FROM departments 
WHERE parent_id IS NULL
UNION ALL
SELECT t2.department_id, 
       LPAD(' ' , 3 * (2-1)) || t2.department_name AS department_name, 
       t2.parent_id,
       2 AS levels,
       t2.parent_id || t2.department_id AS sort
FROM departments t1,
     departments t2
WHERE t1.parent_id is null
  AND t2.parent_id = t1.department_id
UNION ALL
SELECT t3.department_id, 
       LPAD(' ' , 3 * (3-1)) || t3.department_name AS department_name, 
       t3.parent_id,
       3 as levels,
       t2.parent_id || t3.parent_id || t3.department_id as sort
FROM departments t1,
     departments t2,
     departments t3
WHERE t1.parent_id IS NULL
  AND t2.parent_id = t1.department_id
  AND t3.parent_id = t2.department_id
UNION ALL
SELECT t4.department_id, 
       LPAD(' ' , 3 * (4-1)) || t4.department_name as department_name, 
       t4.parent_id,
       4 as levels,
       t2.parent_id || t3.parent_id || t4.parent_id || t4.department_id AS sort
FROM departments t1,
     departments t2,
     departments t3,
     departments t4
WHERE t1.parent_id IS NULL
  AND t2.parent_id = t1.department_id
  AND t3.parent_id = t2.department_id
  and t4.parent_id = t3.department_id
ORDER BY sort;

-- 계층형쿼리 사용 

select department_id
     , parent_id
     , lpad(' ', 3 * (level - 1)) ||department_name as 부서 
     , level
from departments
start with parent_id is null                 -- 시작 지점
connect by prior department_id = parent_id;-- 어떤 식으로 연결 되는지 

INSERT INTO departments (department_id
                       , department_name
                       , parent_id) 
VALUES ((select nvl(max(department_id),0) + 10
         from departments )
         ,'빅데이터 팀'
         , 230
        );
    commit;

select a.employee_id 
     , a.manager_id
     , lpad(' ', 3 * (level - 1)) || a.emp_name as nm
     , level
     , b.department_name
     , a.department_id
     , connect_by_root department_name as root_name
     , sys_connect_by_path(department_name, '|') as path
     , connect_by_isleaf as leaf -- 마지막노드 1, 자식있으면 0 
from employees a
    ,departments b 
where a.department_id = b.department_id
start with a.manager_id is null
connect by prior a.employee_id = a.manager_id
order siblings by department_name
;

/*
  아래처럼 출력 되도록 테이블을 생성,데이터 인서트 후 출력하시오 
  ex) 아이디, 이름, 직책, 상위아이디 
  
이사장	사장	                1
김부장	   부장	            2
서차장	      차장	        3
장과장	         과장	    4
이대리	            대리	    5
최사원	               사원	6
강사원	               사원	6
박과장	         과장	    4
김대리	            대리	    5
강사원	               사원	6
*/


create table 팀 (
    아이디 number
  , 이름 varchar2(10)
  , 직책 varchar2(10)
  , 상위아이디 number
);
-- (1) 시작점 
-- (2) 연결 컬럼과 데이터 

insert into 팀 values(1,'이사장', '사장', null);
insert into 팀 values(2,'김부장', '부장',1);
insert into 팀 values(3,'서차장', '차장',2);
insert into 팀 values(4,'장과장', '과장',3);
insert into 팀 values(5,'박과장', '과장',3);
insert into 팀 values(6,'이대리', '대리',4);
insert into 팀 values(6,'김대리', '대리',5);
insert into 팀 values(8,'최사원', '사원',6);
insert into 팀 values(9,'강사원', '사원',6);
insert into 팀 values(10,'강사원', '사원',7);

select 이름 
    , lpad(' ', 3 * (level-1)) || 직책  as 직책
    , level 
from 팀
start with 상위아이디 = 100
connect by prior 아이디 = 상위아이디 
;
/* level 은 오라클에서 실행되는 모든 쿼리 내에서 사용가능 (connect by 절과함께)
   level은 가상의 열로 트리 내에서 단계(level)에 있는지 나타내는 정수값 
*/
select '2013' ||lpad(level,2,'0') as months 
from dual
connect by level <= 12;


select period as months 
    , sum(loan_jan_amt) as amt
from kor_loan_status
where period like '2013%'
group by period ;

select a.months 
     , nvl(b.amt,0) as amt
from (select '2013' ||lpad(level,2,'0') as months 
        from dual
        connect by level <= 12
     ) a
   , (select period as months 
            , sum(loan_jan_amt) as amt
        from kor_loan_status
        where period like '2013%'
        group by period
      ) b
where a.months = b.months(+)
order by 1;


-- 해당월의 일자를 출력 


select level
from dual 
connect by level <= (to_date('20210831') - to_date('20210801') + 1);

-- 이번달 20220201 ~ 20220228 출력 하시오 
-- (1)connect by 절에서 해당월의 마지막날과 첫째날을 계산 하여 
--    일수 만큼 level이 나오도록 
-- (2)level을 활용하여 해당월 + level 문자열 결합 
select last_day(sysdate)
     , to_date(to_char(sysdate,'YYYYMM') || '01' )
     , trunc(sysdate,'month')
     , to_date(to_char(last_day(sysdate),'YYYYMMDD'))
          - to_date(to_char(sysdate,'YYYYMM') || '01' ) + 1
     , trunc(last_day(sysdate) 
          - to_date(to_char(sysdate,'YYYYMM') || '01' )) + 1
    ,  trunc(last_day(sysdate)  - trunc(sysdate,'month')) + 1
from dual;

select to_char(sysdate,'YYYYMM')  ||  lpad(level,2,'0') as days
from dual 
connect by level <= trunc(last_day(sysdate)  - trunc(sysdate,'month')) + 1;

-- study 






select to_char(last_day(sysdate),'YYYYMMDD')
    ,  to_char(sysdate,'YYYYMM') || '01'
    , to_date(to_char(last_day(sysdate),'YYYYMMDD')) - to_date(to_char(sysdate,'YYYYMM') || '01') + 1
from dual ;
select to_char(sysdate,'YYYYMM')|| lpad(level,2,'0') as days
from dual 
connect by level <=  to_date(to_char(last_day(sysdate),'YYYYMMDD')) - to_date(to_char(sysdate,'YYYYMM') || '01') + 1
;



/*
문제 

 모든상품의 월별 매출액을 구하시오 
 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
 
  1 ~ 12월까지 통계자료를 출력하시오 (전체 합계포함)
  */
SELECT '2017' || lpad(level,2,'0')  as 매출월 
FROM dual
CONNECT BY level <= 12;

 
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
GROUP BY rollup(SUBSTR(A.reserv_date,1,6))
ORDER BY SUBSTR(A.reserv_date,1,6);


select T1.매출월 
      ,SUM(NVL(T2.SPECIAL_SET,0)) SPECIAL_SET
from (  SELECT '2017' || lpad(level,2,'0')  as 매출월 
        FROM dual
        CONNECT BY level <= 12) T1
    ,(SELECT SUBSTR(A.reserv_date,1,6) 매출월,  
               DECODE(B.item_id,'M0001',B.sales,0) SPECIAL_SET
      FROM reservation A, order_info B
      WHERE A.reserv_no = B.reserv_no
      ORDER BY SUBSTR(A.reserv_date,1,6)) T2
where T1.매출월 = T2.매출월(+)
GROUP BY ROLLUP(T1.매출월)
ORDER BY 1;








SELECT SUBSTR(A.reserv_date,1,6) 매출월,  
       DECODE(B.item_id,'M0001',B.sales,0) SPECIAL_SET,
       DECODE(B.item_id,'M0002',B.sales,0) PASTA,
       DECODE(B.item_id,'M0003',B.sales,0) PIZZA,
       DECODE(B.item_id,'M0004',B.sales,0) SEA_FOOD,
       DECODE(B.item_id,'M0005',B.sales,0) STEAK,
       DECODE(B.item_id,'M0006',B.sales,0) SALAD_BAR,
       DECODE(B.item_id,'M0007',B.sales,0) SALAD,
       DECODE(B.item_id,'M0008',B.sales,0) SANDWICH,
       DECODE(B.item_id,'M0009',B.sales,0) WINE,
       DECODE(B.item_id,'M0010',B.sales,0) JUICE
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no;

select 
      decode(GROUPING_ID(a.매출월),0,a.매출월,1,'전체') as 매출월 
    , SUM(NVL(b.SPECIAL_SET,0)) as SPECIAL_SET
    , SUM(NVL(b.PASTA,0)) as PASTA
    , SUM(NVL(b.PIZZA,0)) as PIZZA
    , SUM(NVL(b.SEA_FOOD,0)) as SEA_FOOD
    , SUM(NVL(b.STEAK,0)) as STEAK
    , SUM(NVL(b.SALAD_BAR,0)) as SALAD_BAR
    , SUM(NVL(b.SALAD,0)) as SALAD
    , SUM(NVL(b.SANDWICH,0)) as SANDWICH
    , SUM(NVL(b.WINE,0)) as WINE
    , SUM(NVL(b.JUICE,0)) as JUICE
from (SELECT '2017'||lpad(level,2,'0') as 매출월 
        FROM dual
      CONNECT BY level <= 12) a
    ,(SELECT SUBSTR(A.reserv_date,1,6) 매출월,  
               DECODE(B.item_id,'M0001',B.sales,0) SPECIAL_SET,
               DECODE(B.item_id,'M0002',B.sales,0) PASTA,
               DECODE(B.item_id,'M0003',B.sales,0) PIZZA,
               DECODE(B.item_id,'M0004',B.sales,0) SEA_FOOD,
               DECODE(B.item_id,'M0005',B.sales,0) STEAK,
               DECODE(B.item_id,'M0006',B.sales,0) SALAD_BAR,
               DECODE(B.item_id,'M0007',B.sales,0) SALAD,
               DECODE(B.item_id,'M0008',B.sales,0) SANDWICH,
               DECODE(B.item_id,'M0009',B.sales,0) WINE,
               DECODE(B.item_id,'M0010',B.sales,0) JUICE
        FROM reservation A, order_info B
        WHERE A.reserv_no = B.reserv_no)b
where a.매출월 = b.매출월(+)
group by rollup(a.매출월)
order by 1;


