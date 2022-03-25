/* 
  테이블 table 
   1.테이블명 컬럼명의 최대 크기는 30바이트 
   2.테이블명 컬럼명으로 예약어는 사용할 수 없다 
   3.테이블명 컬럼명으로 문자, 숫자, _, $, # 사용 가능 
     첫글짜는 문자만 가능 
   4.한 테이블에 사용가능한 컬럼은 최대 255개 
*/
CREATE TABLE ex2_1 (
    col1 CHAR(10)      -- 고정형 
   ,col2 VARCHAR2(10)  -- 유동형 
);
INSERT INTO ex2_1 (col1, col2)
VALUES ('abc','abc');

SELECT col1
      ,length(col1)
      ,col2
      ,length(col2)
FROM ex2_1;

-- char 고정형으로 저장 공간의 효율화를 위해 varchar2 사용
CREATE TABLE ex2_2 (
  col1 VARCHAR2(3)       -- 디폴트 byte
 ,col2 VARCHAR2(3 byte)
 ,col3 VARCHAR2(3 char)
);
-- 한글 1 글자는 3byte 
INSERT INTO ex2_2 (col3) values('오라클');
INSERT INTO ex2_2 (col1) values('오라클');  -- 오류

INSERT INTO ex2_2 (col1) values('abc');  

SELECT length(col1)
      ,length(col3) 
      ,lengthb(col1) 
      ,lengthb(col3) 
FROM ex2_2;

/* number(p, s) p : 최대 유효숫자 자리수 
                s : 소수점 기준 자리수 
   s 디폴트 0 
   s가 양수이면 소수점 이하 , 음수이면 소수점 이상 유효자리수 
   s에 명시한 숫자 이상을 입력하면 s에 명시한 숫자까지 반올림 
   s가 음수이면 소수점 기준으로 왼쪽으로 반올림 
 
*/
CREATE TABLE ex2_3(
    col1 number(3)
   ,col2 number(3,2)
   ,col3 number(5,-2)
);
INSERT INTO ex2_3 (col1) values(0.7898); -- 반올림
INSERT INTO ex2_3 (col1) values(99.5);   -- 반올림 
INSERT INTO ex2_3 (col1) values(1004);   --오류 
SELECT * FROM ex2_3;

INSERT INTO ex2_3 (col2) values(0.7898); -- 반올림
INSERT INTO ex2_3 (col2) values(99.5);   -- 오류 

INSERT INTO ex2_3 (col3) values(12345.2346);
INSERT INTO ex2_3 (col3) values(12367.2346);

-- 날짜 데이터 타입 
CREATE TABLE ex2_4(
    col1 DATE      -- 년월일시분초
   ,col2 TIMESTAMP -- 년월일시분초.밀리세컨드 
);
INSERT INTO ex2_4 VALUES(sysdate, systimestamp);

SELECT * FROM ex2_4;

-- 제약조건 not null
CREATE TABLE ex2_5(
  col1 varchar2(20)
 ,col2 varchar2(20) not null
);
INSERT INTO ex2_5 VALUES('abc','efg');
INSERT INTO ex2_5 (col1) VALUES('abc'); --  오류 
INSERT INTO ex2_5 (col2) VALUES('abc'); --  성공  
SELECT *
FROM ex2_5;
-- unique 
CREATE TABLE ex2_6(
   col1 varchar2(20)
  ,col2 varchar2(20) unique
);
INSERT INTO ex2_6 VALUES('abc','abc');
INSERT INTO ex2_6 VALUES('abc','abc'); -- 오류 
INSERT INTO ex2_6 VALUES('abc','ABC');
SELECT * FROM ex2_6;

SELECT employee_id 
     , emp_name 
     , department_name
FROM employees
   , departments
WHERE employees.department_id = departments.department_id;

SELECT *
FROM departments;

-- check 제약조건 
create table ex2_7(
   name varchar2(30) not null
  ,age number(3) check (age between 1 and 150)
  ,gender char(1)  check(gender in ('F','M'))
--  ,constraint ck_ex2_7 check(gender in ('F','M'))
);
INSERT INTO ex2_7 VALUES('팽수',10,'M');
INSERT INTO ex2_7 VALUES('팽수',10,'A');
INSERT INTO ex2_7 VALUES('팽수',1000,'M');

-- 디폴트 
CREATE TABLE ex2_8 (
     col1 varchar2(100)
    ,col2 date default sysdate
    ,col3 number default 0
);
INSERT INTO ex2_8 (col1) VALUES ('팽수');
INSERT INTO ex2_8 (col1,col3) VALUES ('팽수2',100);
SELECT * FROM ex2_8;
-- 테이블 삭제 
DROP TABLE ex2_1;

-- PRIMARY KEY(기본키), FOREIGN KEY(외래키)
-- PK, FK 
CREATE TABLE dep(
   deptno number(3) primary key
  ,deptname varchar2(20)
  ,floor number(5)
);
CREATE TABLE emp( 
     empno number(5) primary key
    ,empname varchar2(50)
    ,dno number(3) constraint emp_fk 
     references dep(deptno)   
);
INSERT INTO dep values(1, '영업', 8);
INSERT INTO dep values(2, '기획', 10);
INSERT INTO dep values(3, '개발', 9);
INSERT INTO emp values(101, '팽수', 1);
INSERT INTO emp values(102, '길동', 3);--참조 데이터가 없음 
select * from emp;
INSERT INTO dep (deptname, floor) values( '홍보', 9);

DROP TABLE dep; -- 오류 참조하고 있는 테이블이 있기 때문 

DROP TABLE dep CASCADE CONSTRAINTS;
-- 수정 ALTER 
CREATE TABLE ex2_10 (
   col1 varchar2(10) not null unique
  ,col2 varchar2(10) null
  ,col3 date default sysdate
);
-- 컬럼명 수정 
ALTER TABLE ex2_10 RENAME COLUMN col1 to nm;
DESC ex2_10;
-- 타입 수정 
ALTER TABLE ex2_10 MODIFY col2 varchar2(30);
-- 컬럼 추가 
ALTER TABLE ex2_10 ADD col4 number;
--컬럼 삭제 
ALTER TABLE ex2_10 DROP COLUMN col2;

CREATE TABLE TB_INFO(
 INFO_NO NUMBER(3) PRIMARY KEY
,PC_NO VARCHAR2(10)  NOT NULL 
,NM VARCHAR2(20)
,EMAIL VARCHAR2(100)
,HOBBY VARCHAR2(1000)
);


DROP table TB_INFO;

-- 설명 넣기 
COMMENT ON TABLE TB_INFO IS '학생정보';
COMMENT ON COLUMN TB_INFO.INFO_NO IS '기본번호';
COMMENT ON COLUMN TB_INFO.PC_NO IS 'pc번호';
COMMENT ON COLUMN TB_INFO.NM IS '이름';
COMMENT ON COLUMN TB_INFO.EMAIL IS '메일주소';
COMMENT ON COLUMN TB_INFO.HOBBY IS '취미';




