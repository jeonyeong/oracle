/* 신입생이 들어왔습니다.    
   학생정보 입력 익명블록을 작성하시오 
   입력값 : 이름,주소,전공,생년월일은 
   학번은 생성(학번의 앞 4자리는 년도로 올해 년도와 같다면 마지막 학번 + 1로 생성 
                                   올해 년도와 같지 않다면 2022000001 번으로 생성 )
*/
DECLARE 
 vn_year varchar2(4) := TO_CHAR(SYSDATE, 'YYYY');
 -- 필요한 변수 생성  
 vn_max_no number;
 vn_make_no number;
BEGIN
 SELECT max(학번)
  INTO vn_max_no
 FROM 학생 ;
 
 IF vn_year = SUBSTR(TO_CHAR(vn_max_no),1,4) THEN 
  vn_make_no := vn_max_no + 1;
 ELSE
  vn_make_no := TO_NUMBER(vn_year || '000001');
 END IF;
 
 INSERT INTO 학생 (학번, 이름, 주소, 전공, 생년월일)
 VALUES (vn_make_no, :이름, :주소, :전공, TO_DATE(:생년월일)) ;
 
END;



 SELECT MAX(학번) 
 FROM 학생 ;

DECLARE 
 vn_year varchar2(4) := TO_CHAR(SYSDATE, 'YYYY');
 -- 필요한 변수 생성  
 vn_max_no number;
 vn_make_no number;
BEGIN
 -- 마지막 학번 조회 
 SELECT MAX(학번) 
  INTO vn_max_no
 FROM 학생 ;
 
 IF vn_year = SUBSTR(TO_CHAR(vn_max_no),1,4) THEN 
  DBMS_OUTPUT.PUT_LINE('같음');
  vn_make_no := vn_max_no + 1;
 ELSE
  DBMS_OUTPUT.PUT_LINE('다름');
  vn_make_no := TO_NUMBER(vn_year||'000001');
 END IF;
 -- 앞 4자리 비교  
 -- 학번 생성 
 INSERT INTO 학생 (학번, 이름, 주소, 전공, 생년월일)
 VALUES (vn_make_no, :이름, :주소, :전공, TO_DATE(:생년월일)) ;
END;

/* 
   YYYYMMDD 형식의 문자타입 데이터를 입력 받아 
   오늘 날짜와 비교하여 지났다면 얼마나 지났는지 
          안지났다면 얼마나 남았는지 출력하시오(네이버dday기준)
   2022.12.25    오늘부터 기준일까지는 292일 남았습니다.
   2022.01.01    기준일부터 67일 째 되는 날입니다.
   입력 : 문자열           오늘 날짜와 큰지, 같은지, 작은지 조건에 따른 계산  
   리턴 : 문자열 
   (1) 입력받은 날짜와 오늘날짜와 계산 
   (2) 계산한값에 따른 조건문 및 값 할당 
   (3) 값 리턴                          ex) 사용변수, TRUNC, TO_DATE, ABS  */
SELECT fn_dday('20221225'), fn_dday('20220308'), fn_dday('20220101')
FROM DUAL;

CREATE OR REPLACE FUNCTION fn_dday(dd varchar2)
 RETURN varchar2
IS 
 vn_num number ;
 vs_dday varchar2(1000);
BEGIN
   vn_num := TRUNC(TO_DATE(dd) - SYSDATE);
    
   IF vn_num > 0 THEN 
    vs_dday := '오늘부터 기준일까지는 ' || (vn_num + + 1) || '일 남았습니다.';
   ELSIF vn_num = 0 THEN 
    vs_dday := '오늘은 기준일부터 1일 째 되는 날입니다.';
   ELSE
    vs_dday := '기준일부터 ' || ABS((vn_num + -1)) || '일 째 되는 날입니다.';
   END IF;
   RETURN vs_dday;
END;

