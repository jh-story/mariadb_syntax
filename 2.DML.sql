-- insert: 테이블에 데이터 삽입
insert into 테이블명(컬럼1, 컬럼2, 컬럼3) vlaues(데이터1, 데이터2, 데이터3);
insert into author(id, name, email) values(3, 'hong3', 'hong3@naver.com'); --문자열

-- update: 테이블에 데이터 변경
update author set name ="홍길동", email="hong100@naver.com" where id=3;

-- select: 조회
select 컬럼1, 컬럼2 from 테이블명;
select name, email from author;
select * from author; -- *은 컬럼을 의미, 모든 데이터가 나오는 이유: where 조건이 없기 때문

-- delete: 삭제 
delete from 테이블명, where 조건절;
delete from author where id=3;

-- select 조건절 활용 조회
select * from author; -- 어떤 조회 조건 없이 모든 컬럼 조회
select * from author where id=4; -- where 뒤에 조회 조건을 통해 filtering
select * from author where name='hong2';
select * from author where id>3;
select * from author where id>2 and name='hong4'; -- and 조건 사용 가능
select * from author where author_id in (1,3,5) ;
select * from post where author_id in (select id from author where name = 'hong') ; -- 쿼리 안에 서브 쿼리 작성 가능

-- 테스트 데이터 삽입
-- insert문을 활용해서 author 데이터 3개, post 데이터 5개 추가
insert into author(id, name, email, password) values(5, 'hong5', 'hong5@naver.com', 5555);
insert into post(id, title, content, author_id) values(5, 'hi5', '55555', 1);

-- 중복 제거 조회
select name from author;
select distinct name from author;

-- 정렬: order by + 컬럼명
-- asc: 오름차순, desc: 내림차순 (오름차순이 default)
-- 아무런 정렬 조건 없이 조회할 경우에는, pk 기준으로 오름차순
select * from author order by name;

-- 중요한 부분!!!!
-- 멀티컬럼 order by: 여러 컬럼으로 정렬시에 먼저 쓴 컬럼 우선 정렬 / 중복시, 그 다음 정렬 옵션 적용
select * from author order by name desc, email asc; -- 이름으로 내림차순 정렬, 중복시 email 오름차순 정렬(asc는 생략 가능)

-- 결과값 개수 제한
select * from author order by id desc limit 1; - author에서 1개를 조회하는데, 내림차순(pk 즉, id 기준)

-- 별칭(alias)를 이용한 select
select name as '이름', email as '이메일' from author; -- 출력시 컬럼명을 원하는 별칭으로! (변경 X, 출력만)
select name, email from author as a;
select a.name, a.email from author as a; -- 쿼리가 길어지는 걸 방지하기 위에 약어를(a) 만들어서 사용할 수 있음 (여러 테이블 조회할 때 주로 사용)
select a.name, a.email from author a; -- as 생략하고 한 칸 띄우고 약어 사용도 가능

-- null을 조회 조건으로 활용
-- 공백과 null은 다름 (공백을 없애려면 esc키를 누르고 delete 누르면 null로 변경 가능)
select * from author where password is null;
select * from author where password is not null; -- null type은 =(equal) 사용 불가, is null/is not null 사용하기

-- 프로그래머스 sql 문제풀이
-- 문제 제목: 여러 기준으로 정렬하기
select ANIMAL_ID, NAME, DATETIME from ANIMAL_INS order by NAME asc, DATETIME desc;
-- 문제 제목: 상위 n개 레코드
select NAME from ANIMAL_INS order by DATETIME asc limit 1;