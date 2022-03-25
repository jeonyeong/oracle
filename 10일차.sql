--grant create view to java;  system 계정에서 부여해야함 
create or replace view emp_dept as 
select a.employee_id
      ,a.emp_name
      ,a.department_id
      ,b.department_name
from employees a 
   , departments b 
where a.department_id = b.department_id;

select *
from emp_dept;
-- java 에서 study 계정에게 조회권한 부여 
grant select on emp_dept to study;
-- study 계정에서 조회 
select *
from java.emp_dept;

drop view emp_dept;

/* 시노님 
   synonym은 동의어란 뜻으로 객체 이름에 동의어를 만드는 것 
   public 모든사용자 접근가능 
   private 특정 사용자만 사용가능 
*/
grant create synonym to java; -- system계정에서 
create or replace synonym syn_channel
for channels;

select *
from syn_channel;
-- java 계정에서 study 계정으로 권한부여 
grant select on syn_channel to study;
-- study 계정에서 syn_channel 조회 
select *
from java.syn_channel;

create or replace public synonym syn
for java.channels ;
select *
from syn;

/* 시퀀스 sequence 는 자동 순번을 반환 
   nextval, currentval
*/
create sequence my_seq2
increment by 1 -- 증가숫자 
start with   1 -- 시작숫자 
minvalue     1 -- 최솟값 
maxvalue    999999 -- 최댓값 
nocycle         -- 최댓값 도달시 생성 중지 
nocache ;       -- 미리 값 할당 안함 
select my_seq1.nextval  -- 증가 
from dual;
select my_seq1.currval -- 현재 시퀀스값 
from dual;
create table ex10_1(
   seq number 
  ,update_dt timestamp  default systimestamp
);
insert into ex10_1 (seq) values(my_seq2.nextval);
select *
from ex10_1;

-- 최소 1, 최대 99999999, 1000부터 2씩 증가하는 
-- 시퀀스를 만들어 보시오 이름은 order_seq

create sequence order_seq
INCREMENT by 2
start with 1000
minvalue 1
maxvalue 99999999;

select order_seq.nextval
from dual;

delete  ex10_1;
commit;
select nvl(max(seq),0) + 1
from ex10_1;

insert into ex10_1 (seq) 
values((select nvl(max(seq),0) + 1
        from ex10_1)
      );
select *
from ex10_1;
    

drop sequence my_seq1;

      
SELECT *                              
FROM tb_info                          
WHERE check_yn = 'N'                    
ORDER BY DBMS_RANDOM.VALUE;



