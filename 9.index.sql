-- pk, fk, unique 제약조건 추가시에 해당 컬럼에 대해 index 페이지 자동 생성됨
-- index가 만들어지면, 조회 성능 향상, 추가/수정/삭제 성능 하락

-- index 조회
show index from author;

-- index 삭제
alter table author drop index 인덱스명;

-- index 생성
create index 인덱스명 on 테이블(컬럼명);

-- index를 통해 조회 성능 향상을 얻으려면, 반드시 where 조건에 해당 컬럼에 대한 조건이 있어야 함
select * from author where 

-- 만약 where 조건에서 2컬럼으로 조회시에, 1컬럼에만 index가 있다면,
select * from author where name='hong' and email='hongildong@naver.com';

-- 만약 where 조건에서 2컬럼으로 조회시에, 2컬럼 모두 각각에 index가 있다면
-- 이 경우 db엔진에서 최적의 알고리즘 실행
select * from author where name='hong' and email='hongildong@naver.com';

-- index는 1컬럼 뿐만아니라, 2컬럼을 대상으로 1개의 index를 설정하는 것도 가능
-- 이 경우 2컬럼을 and 조건으로 조회해야만 index를 사용
-- 복합 인덱스 생성
create index 인덱스명 on 테이블명(컬럼1, 컬럼2);

-- 기존 테이블 삭제 후 아래 테이블로 신규 생성
create table author(id bigint auto_increment, email varchar(255), name varchar(255), primary key(id));
