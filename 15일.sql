SET SERVEROUTPUT ON
/*익명블록 (이름이 없는 PL/SQL)*/
DECLARE
 --선언부 
 vi_num NUMBER;
BEGIN
 --실행부 
 vi_num :=100;  -- 변수 값 할당 
 -- 프린트 
 DBMS_OUTPUT.PUT_LINE('출력:'||vi_num);
END;
-- 결과 값만 보려면 [보기 - DBMS출력]



DECLARE
 -- 상수값 변경이 안됨, 선언부에서 무조건 값을 할당해야함. 
 vi_num CONSTANT NUMBER := 2; 
BEGIN
  -- 프린트 
 DBMS_OUTPUT.PUT_LINE('출력:'||vi_num);
END;


-- DML문 사용 
DECLARE 
 vs_emp_name VARCHAR2(80);
 vs_dep_name VARCHAR2(80);
BEGIN
 SELECT a.emp_name, b.department_name 
 INTO vs_emp_name, vs_dep_name
 FROM employees a
    , departments b
 WHERE a.department_id = b.department_id
 AND   a.employee_id = 100;
 DBMS_OUTPUT.PUT_LINE(vs_emp_name || '-' || vs_dep_name);
END;

-- 상수 : 값'최숙경' 을 선언하고 
-- 해당 상수로 학번을 조회하여 출력하시오 
DECLARE
 -- 상수 선언 및 값 할당 
 vs_name constant 학생.이름%type := :a;
 vn_num 학생.학번%type;
BEGIN
 SELECT 학번 
  INTO vn_num
 FROM 학생
 WHERE 이름 = vs_name;
 DBMS_OUTPUT.PUT_LINE(vs_name || ':' || vn_num);
END ;


-- 변수가 필요없을때 
BEGIN
 DBMS_OUTPUT.PUT_LINE('3 * 3 =' || 3 * 3 );
 DBMS_OUTPUT.PUT_LINE('3 * 4 =' || 3 * 4 );
END;
-- IF문 

DECLARE 
  vn_num number := :params;
BEGIN
  IF vn_num < 10 THEN 
     DBMS_OUTPUT.PUT_LINE('10 보다 작음');
  ELSIF vn_num < 100 THEN 
     DBMS_OUTPUT.PUT_LINE('100 보다 작음');
  ELSE 
     DBMS_OUTPUT.PUT_LINE('100 보다 큼');
  END IF;
END;

-- LOOP 문 (반복문) 
DECLARE 
 vn_base number := 3;
 vn_cnt  number := 1;
BEGIN
 LOOP
  DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_cnt || '=' || vn_base * vn_cnt);
   vn_cnt  := vn_cnt + 1;
  EXIT WHEN vn_cnt > 9; -- 루프종료
 END LOOP;
END;

DECLARE 
 i number := 2;
 j number;
BEGIN
 LOOP
   DBMS_OUTPUT.PUT_LINE(i || ' 단');
   j := 1;
   LOOP
        DBMS_OUTPUT.PUT_LINE(i||'*'||j||'='|| i * j);
        j := j + 1;
        EXIT WHEN j > 9;
   END LOOP;
   i := i + 1;
  EXIT WHEN i > 9;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('종료');
END;

-- WHILE 반복문 
DECLARE
 i number := 2;
 j number := 1;
BEGIN
 WHILE j <=9 -- 해당 조건이 true이면 반복 
 LOOP
  DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i * j);
  j := j + 1;
  EXIT WHEN j = 5;  -- 사용가능 
 END LOOP;
END;
-- FOR문 
DECLARE 
 i number := 2;
BEGIN
 FOR j IN 1..9
 LOOP
  DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i * j);
 END LOOP;
END;



-- 변수 선언 없이 구구단 2단 ~ 9단 까지 출력하시오 
BEGIN
  FOR i in 2..9
  LOOP
    DBMS_OUTPUT.PUT_LINE(i || '단 ========');
    FOR j IN 1..9
    LOOP
      DBMS_OUTPUT.PUT_LINE(i ||'*'||j ||'=' ||i * j);
    END LOOP;
  END LOOP;
END;

-- 입력받은 수 만큼 * 을 찍는 익명블록을 작성하시오 
-- 5  입력 *****
-- 10 입력 **********
DECLARE 
 vn_input number := :inparam;
 vs_star varchar2(4000);
BEGIN
 -- 별출력 
 FOR i IN 1..vn_input
 LOOP
  vs_star := vs_star || '*';
 END LOOP;
 DBMS_OUTPUT.PUT_LINE(vs_star);
END;


BEGIN
 FOR i IN REVERSE 1..9      --  <-- 방향으로 감소함 
 LOOP 
  CONTINUE WHEN i = 5;
  DBMS_OUTPUT.PUT_LINE(i);
 END LOOP;
END;





DECLARE 
 vn_input number := :inparam;
 vs_star varchar2(4000);
BEGIN
 FOR i IN 1..vn_input
 LOOP
  vs_star := vs_star ||'*';
 END LOOP;
 DBMS_OUTPUT.PUT_LINE(vn_input ||':입력'); 
 DBMS_OUTPUT.PUT_LINE(vs_star);  
END;












BEGIN
 FOR i IN 2..9
 LOOP
     DBMS_OUTPUT.PUT_LINE(i || '단 '||'===========');
     FOR j IN 1..9
     LOOP
        DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i * j);
     END LOOP;
 END LOOP;
END;






/**/
select my_mod(4,2)
from dual;


CREATE OR REPLACE FUNCTION my_mod(num1 number, num2 number)
 RETURN number -- 반환 타입 
IS 
 vn_remainder number := 0; -- 반환나머지 
 vn_quotient number := 0;  -- 몫
BEGIN
 vn_quotient := FLOOR(num1 / num2) ;
 vn_remainder := num1 - (num2 * vn_quotient); 
 RETURN vn_remainder; 
END;

select my_mod(4, 2)
from dual;
--학번을 입력받아 수강 건수를 리턴하는 함수를 작성하시오 
--함수명 : fn_score
--입력값 : 학번 (number)
--리턴값 : 수강건수 (number)

SELECT 학생.학번 
    , 학생.이름
    , count(수강내역.수강내역번호)
FROM 학생 
   , 수강내역 
WHERE 학생.학번 = 수강내역.학번(+) 
GROUP BY 학생.학번 
       , 학생.이름;
       
       
       
SELECT count(수강내역.수강내역번호)
FROM 학생 
   , 수강내역 
WHERE 학생.학번 = 수강내역.학번(+) 
AND 학생.학번 = 2001110141;

CREATE OR REPLACE FUNCTION fn_score(hak number)
 RETURN NUMBER
IS 
 vn_cnt number;
BEGIN
    SELECT count(수강내역.수강내역번호)
    INTO vn_cnt
    FROM 학생 
       , 수강내역 
    WHERE 학생.학번 = 수강내역.학번(+) 
    AND 학생.학번 = hak;
 RETURN vn_cnt;
END;








SELECT fn_score(2001110141)
FROM dual;

SELECT 이름 
     , fn_score(학번) as 수강건수 
FROM 학생;




CREATE OR REPLACE FUNCTION fn_score(hak number)
 RETURN number
IS 
 score number;
BEGIN
    SELECT count(수강내역.수강내역번호) 
    INTO score 
    FROM 학생
       , 수강내역 
    WHERE 학생.학번 = 수강내역.학번(+)
    AND 학생.학번 =hak;
    RETURN score;
END;














