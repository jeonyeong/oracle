CREATE TABLE 강의내역 (
     강의내역번호 NUMBER(3)
    ,교수번호 NUMBER(3)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시  NUMBER(3)
    ,수강인원 NUMBER(5)
    ,년월 date
);

CREATE TABLE 과목 (
     과목번호 NUMBER(3)
    ,과목이름 VARCHAR2(50)
    ,학점 NUMBER(3)
);

CREATE TABLE 교수 (
     교수번호 NUMBER(3)
    ,교수이름 VARCHAR2(20)
    ,전공 VARCHAR2(50)
    ,학위 VARCHAR2(50)
    ,주소 VARCHAR2(100)
);

CREATE TABLE 수강내역 (
    수강내역번호 NUMBER(3)
    ,학번 NUMBER(10)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시 NUMBER(3)
    ,취득학점 VARCHAR(10)
    ,년월 DATE 
);

CREATE TABLE 학생 (
     학번 NUMBER(10)
    ,이름 VARCHAR2(50)
    ,주소 VARCHAR2(100)
    ,전공 VARCHAR2(50)
    ,부전공 VARCHAR2(500)
    ,생년월일 DATE
    ,학기 NUMBER(3)
    ,평점 NUMBER
);


COMMIT;




ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수강내역_수강내역번호 PRIMARY KEY (수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_과목내역_과목번호 PRIMARY KEY (과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_교수_교수번호 PRIMARY KEY (교수번호);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_과목_과목번호 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_교수_교수번호 FOREIGN KEY(교수번호)
REFERENCES 교수(교수번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_과목_과목번호2 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);

--ALTER TABLE 수강내역 DROP PRIMARY KEY;

COMMIT;


select *
from 학생;

select *
from 수강내역;

--동등 조인 = <= 등호를 사용하여 연결 
select a.학번  as 학생테이블 
     , b.학번  as 수강내역테이블
     , a.이름 
     , a.전공 
     , a.평점 
     , b.수강내역번호
     , c.과목이름 
from 학생     a
   , 수강내역  b
   , 과목     c
where a.학번 = b.학번 (+)
and   b.과목번호 = c.과목번호 (+)
and   a.이름 = '양지운';

--'모든 학생'의 수강 학점을 출력하시오 
select a.학번
     , a.이름 
     , nvl(sum(c.학점),0) as 수강학점합계 
from 학생 a, 수강내역 b,  과목 c
where a.학번 = b.학번 
and   b.과목번호 = c.과목번호 
group by a.학번, a.이름
order by 1;

select *
from member;
select *
from cart;


-- 모든 고객의 상품구매 수를 출력하시오 건수내림차순 
-- member, cart
select mem_id
     , mem_name
from member;

select  cart_member
      , cart_qty
from cart;


select mem_name
     , nvl(sum(cart_qty),0) as 상품구매건수 
from member
   , cart
where member.mem_id = cart.cart_member(+)
group by mem_id
       , mem_name
order by 2 desc;


-- 고객별 구매상품명, 구매건수, 상품별구매금액을 출력하시오 
-- member, cart, prod (정렬 이름,상품이름 오름차순)


select mem_name
     , prod_name
     , sum(cart_qty)             as 상품구매건수 
     , sum(cart_qty * prod_sale) as 상품총구매금액
from member
   , cart
   , prod 
where member.mem_id = cart.cart_member
and    cart.cart_prod = prod.prod_id
group by mem_name
     , prod_id
     , prod_name
order by 1, 2;


select count(*)
from member;





