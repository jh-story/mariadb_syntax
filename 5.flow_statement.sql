-- 흐름제어: case when, if, ifnull
-- if(a, b, c): a 조건이 참이면 b 반환, 그렇지 않으면 c를 반환
select id, if(name is null, '익명사용자', name) from author;

-- ifnull(a, b): a가 null이면 b를 반환, 그렇지 않으면(null이 아니면) a를 그대로 반환
select id, ifnull(name, '익명사용자') from author;

-- case when
select id, 
case 
    when name is null then '익명사용자' 
    when name ='hong4' then '홍길동'
    else name
end
from author;

-- 프로그래머스 문제 풀이
-- 경기도에 위치한 식품광고 목록 출력하기
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, IFNULL(FREEZER_YN, 'N') AS FREEZER_YN 
FROM FOOD_WAREHOUSE WHERE ADDRESS LIKE '경기도%' ORDER BY WAREHOUSE_ID;
-- 조건에 부합하는 중고거래 상태 조회하기
SELECT BOARD_ID, WRITER_ID, TITLE, PRICE,
CASE 
    WHEN STATUS = 'SALE' THEN '판매중'
    WHEN STATUS = 'RESERVED' THEN '예약중'
    ELSE '거래완료'
END AS 'STATUS'
FROM USED_GOODS_BOARD
WHERE CREATED_DATE LIKE '2022-10-05' 
ORDER BY BOARD_ID DESC;
-- 12세 이하인 여자 환자 목록 출력하기
SELECT PT_NAME, PT_NO, GEND_CD, AGE, IFNULL(TLNO, 'NONE') AS TLNO
FROM PATIENT 
WHERE AGE <= '12' AND GEND_CD = 'W'
ORDER BY AGE DESC, PT_NAME;
