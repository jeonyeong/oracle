-- 주석
-- 테이블 스페이스생성 
create TABLESPACE myts
datafile '/u01/app/oracle/oradata/XE/myts.dbf'
size 100M autoextend on next 5M;

-- 사용자 생성 (java/oracle)
create user java identified by oracle
default TABLESPACE myts
temporary tablespace temp;
-- 권한 설정 
grant connect, resource to java;
