-- tinyint: 1128 ~ -127까지 표현 (unsigned시에 0~255까지)
-- author 테이블에 age 컬럼 변경
alter table author modify column age tinyint unsigned;
insert into author(id, email, age) values(6, abc@naver.com, 300); -- 범위 255를 넘어갔기 때문에 에러
insert into author(id, email, age) values(6, abc@naver.com, 200); -- 범위 255 안에 들어가기 때문에 추가 가능

-- int: 4바이트 (대략, 40억의 숫자 범위)

-- bigint: 8바이트
-- author, post 테이블의 id값 bigint로 변경
alter table author modify column id bigint primary key;
alter table post modify column id int;

-- decimal(총 자리수, 소수부 자리수)
alter table post add column price decimal(10,3);
-- decimal 소수점 초과시 잘림 현상 발생 (확인용) -> 에러 발생 X
insert into post(id, title, price, author_id) values (7,'hello python', 10.33412, 3);

-- 문자 타입: 고정길이(char), 가변길이(varchar, text)
alter table author add column gender char(10); 
alter table author modify column gender char(1); -- char 길이를 1로 변경 (변경 전에 1자 넘어가는 데이터 있다면 수정해서 apply후 modify 실행)

alter table author add column self_introduction text; -- text는 괄호로 따로 최대치 지정 X

-- blob(바이너리 데이터) 타입 실습
-- 일반적으로 blob을 저장하기 보다, varchar를 설계하고 이미지 경로만을 저장함
alter table author add column profile_image longblob; -- longblob: blob에서 길이만 길게 설정된 타입
insert into author(id, email, profile_image) values(9, 'bbb@nvaer.com', LOAD_FILE("C:\\images.jpg"));

-- enum: 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- 사용자가 입력하지 않으면 null인데, not null로 null일 수 없게 설정
-- 그러나 null일 경우 에러나는 게 싫으면 아래처럼 default 설정어로 지정 가능
alter table author add column role enum('admin','user') not null default 'user'; 

-- enum에 지정된 값이 아닌 경우우
insert into author(id, email, role) values(10, 'sss@naver.com', 'admin2');
-- role을 지정 안 한 경우
insert into author(id, email) values(11, 'sss@naver.com');
-- enum에 지정된 값인 경우
insert into author(id, email, role) values(12, 'zzz@naver.com', 'admin');
-- admin 조회: 문자열처럼 조건 주고 조회
select * from author where role = "admin";

-- date와 datetime
-- 날짜 타입의 입력, 수정, 조회시에 문자열 형식을 사용용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, author_id, created_time) values(7, 'hello', 3, '2025-05-23 14:36:30');

alter table post modify column created_time datetime default current_timestamp();
insert into post(id, title, author_id) values(13, 'hello', 3);

-- 비교연산자
select * from author where id>=2 and id<=4;
select * from author where id between 2 and 4; -- 위 구문과 같은 구문
select * from author where id in(2,3,4); -- 위 구문과 같은 구문

-- like: 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%';
select * from post where title like '%h';
select * from post where title like '%h%';

-- regexp: 정규표현식을 활용한 조회
select * from post where title regexp '[a-z]'; -- 하나라도 알파벳 소문자가 들어있으면
select * from post where title regexp '[가-힣];'; -- 하나라도 한글이 들어있으면

-- 숫자 -> 날짜
select cast(20250523 as date); -- 결과값: 2025-05-23
-- 문자 -> 날짜
select cast('20250523' as date); -- 결과값: 2025-05-23
-- 문자 -> 숫자
select cast('12' as unsigned); -- int로는 잘 사용하지 X (signed 또는 unsigned 사용)

-- 날짜 조회 방법: 2025-05-23 14:30:25
-- like 패턴, 부등호 활용, date_format
select * from post where created_time like '2025-05%'; -- 문자열처럼 조회
-- 2025-05-01 이상 2025-05-21 미만 (5/1부터 5/20까지), 날짜만 입력시 시간 부분은 00:00:00이 자동으로 붙음
select * from post where created_time >= '2025-05-01' and created_time < '2025-05-21'; 

-- date_format 활용
-- Y(4자리 연도), y(2자리 연도), H(24시간 형식), h(12시간 형식)
select date_format(created_time, '%Y-%m-%d') from post; -- 연-월-일일
select date_format(created_time, '%H:%i:%s') as '시간만' from post; -- 시-분-초, as를 사용해서 컬렴명 깔끔하게 변경 가능
select * from post where date_format(created_time,  '%m') = '05';

-- cast와 date_format 같이 활용 (unsigned로 받기 때문에 월을 숫자로 비교 가능)
select * from post where cast(date_format(created_time, '%m') as unsigned)=5;