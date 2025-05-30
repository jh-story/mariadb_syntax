-- 사용자 관리
-- 사용자 목록 조회
select * from mysql.user;

-- 사용자 생성
create user 'jhjh'@'%' identified by '4321';

-- 사용자에게 권한 부여
grant select on board.author to 'jhjh'@'%';
grant select, insert on board.* to 'jhjh'@'%';
grant all privileges on board.* to 'jhjh'@'%';

-- 사용자 권한 회수
revoke select on board.author from 'jhjh'@"%";
-- 사용자 권한 조회
show grants for 'jhjh'@"%";

-- 사용자 계정 삭제