/* DROP FUNCTION 함수이름  -- 함수 삭제 
*/
DROP FUNCTION my_mod;

-- 국가번호를 입력받아 국가 테이블에서 국가명을 반환하는 함수 작성 
-- 국가 명이 없을 경우 '해당국가 없음'을 반환 
DECLARE 
 vs_con varchar2(100);
BEGIN
 SELECT country_name
 INTO vs_con
 FROM countries
 WHERE country_id = 1234;
 DBMS_OUTPUT.PUT_LINE(vs_con);
END;

CREATE OR REPLACE FUNCTION fn_get_name(p_country_id number)
 RETURN varchar2
IS 
 vn_cnt number;
 vs_country_name countries.country_name%type;
BEGIN
 SELECT COUNT(*)
 INTO vn_cnt
 FROM countries
 WHERE country_id =  p_country_id;
 IF vn_cnt = 0 THEN 
  vs_country_name := '해당국가 없음';
 ELSE 
  SELECT country_name
  INTO vs_country_name
  FROM countries
  WHERE country_id = p_country_id;
 END IF;
 RETURN vs_country_name;
END;

select *
from countries22;

SELECT fn_get_name(52790), fn_get_name(1243)
FROM dual;

/* PROCEDURE 프로시져 
   함수와 가장 큰 차이점은 리턴 값을 0 ~ n 개로 설정할 수 있다. 
   DML문에서 사용 불가 
   프로시져는 DB SERVER에서 실행, 함수는 CLIENT 클라이언트 쪽에서 실행 
    
   IN( 프로시져 내부에서만 사용) 
   OUT( 리턴에 사용)
   IN OUT(내부, 리턴 모두 사용)
*/
CREATE OR REPLACE PROCEDURE my_test_proc(
     p_var1 varchar2   -- default in 
    ,p_var2 out varchar2
    ,p_var3 in out varchar2  )
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('p_var1 :' || p_var1);
  DBMS_OUTPUT.PUT_LINE('p_var2 :' || p_var2);
  DBMS_OUTPUT.PUT_LINE('p_var3 :' || p_var3);
  p_var2 := 'B2';
  p_var3 := 'C2';
END;

DECLARE 
 v_var1 varchar2(10) := 'A';
 v_var2 varchar2(10) := 'B';
 v_var3 varchar2(10) := 'C';
BEGIN
 my_test_proc(v_var1, 'B', v_var3);
 DBMS_OUTPUT.PUT_LINE('프로시져 실행 후 ');
 DBMS_OUTPUT.PUT_LINE('p_var2 :' || v_var2);
 DBMS_OUTPUT.PUT_LINE('p_var3 :' || v_var3);
END;



CREATE OR REPLACE PROCEDURE my_test_proc2(
     p_var1 varchar2   -- default in  
     )
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('p_var1 :' || p_var1);
END;

exec my_test_proc2('hi');

/* 시스템 예외 (오라클에서 정의한오류)
*/
CREATE OR REPLACE PROCEDURE no_exception_proc 
IS
 vi_num number:= 0;
BEGIN
 vi_num := 10 / 0;
 DBMS_OUTPUT.PUT_LINE('success!');
END;

CREATE OR REPLACE PROCEDURE exception_proc 
IS
 vi_num number:= 0;
BEGIN
 vi_num := 10 / 0;
 DBMS_OUTPUT.PUT_LINE('success!');
EXCEPTION WHEN ZERO_DIVIDE THEN
            -- SQLCODE : 오류 코드리턴, SQLERRM : 오류 메세지 리턴 
            -- DBMS_UTILITY.FORMAT_ERROR_BACKTRACE  <-- 오류 프로시져 및 오류라인 출력 
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            DBMS_OUTPUT.PUT_LINE('영으로 나눌수 없는 오류');
          WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('오류남!');
END;



BEGIN
  no_exception_proc;   -- 오류나서 멈춤 
  dbms_output.put_line('성공');
END;

BEGIN
  exception_proc;      -- 오류가 났지만 예외처리 후 다음로직 수행 
  dbms_output.put_line('성공');
END;

/*  구분, 부서아이디, 부서명 를 입력받아 
    구분의 값에 따라 (I or U or D)
    INSERT, UPDATE, DELETE 하는 프로시져를 작성하시오 
    exec dep_proc('I', 300, '빅데이터팀');  부서 테이블에 id:300, name:빅데이터팀 삽입
    exec dep_proc('U', 300, '인공지능팀');  부서 테이블에 id:300의 name 값 수정 
    exec dep_proc('D', 300); 부서 테이블에 id:300 삭제 
*/
CREATE OR REPLACE PROCEDURE dep_proc(
    p_flag varchar2
   ,p_id   number
   ,p_nm   varchar2 default null -- 해당자리에 매개변수 없을때 default값으로 매핑 
)
IS
BEGIN
 IF p_flag = 'I' THEN
  INSERT INTO departments (department_id, department_name) 
       VALUES(p_id, p_nm);
 ELSIF p_flag = 'U' THEN
  UPDATE departments
  SET department_name = p_nm
  WHERE department_id = p_id;
 ELSIF p_flag = 'D' THEN
  DELETE departments
  WHERE department_id = p_id;
 END IF;
 COMMIT;
 DBMS_OUTPUT.PUT_LINE('정상 종료');
END;


select *
from departments;

exec dep_proc('I', 280, '빅데이터팀');
exec dep_proc('U', 280, '인공지능팀');
exec dep_proc('D', 280);



