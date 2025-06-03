# window에서는 기본 설치 안 됨 -> 도커를 통한 redis 설치
docker run --name redis-container -d -p 6379:6379 redis

# redis 접속 명령어
redis-cli

# 컨테이너 ID 조회
docker ps

# docker redis 접속 명령어
docker exec -it 컨테이너ID redis-cli
docker exec -it 1d2e9685df3d redis-cli
1d2e9685df3d

# redis는 0~15번까지의 db로 구성 (default는 0번 db)
# db번호 선택
select db번호

# db내 모든 키 조회
keys *

# 가장 일반적인 String 자료구조

# set을 통해 key:value 세팅
set user1 hong1@naver.com
set user:email:1 hong1@naver.com
set user:email:2 hong2@naver.com
# 기존에 key:value가 존재할 경우 덮어쓰기
set user:email:1 hong3@naver.com
# key값이 이미 존재하면 pass, 없으면 set: nx 옵션 붙이기
set user:email:1 hong4@naver.com nx
# 만료시간(ttl) 설정 (초단위): ex 옵션
set user:email:5 hong5@naver.com ex 10
# redis 실전 활용: token 등 사용자 인증정보 저장 -> redis의 빠른 성능 활용용
set user:1:refresh_token abcdefg1234 ex 1800 

# key를 통해 value get
get user1
# 특정 key값 삭제 -> key 삭제시 value도 같이 삭제됨
del user1
# 현재 db내 모든 key값 삭제
flushdb

# redis 실전 활용2: 좋아요 기능 구현 -> 동시성 이슈 해결 (redis가 싱글스레드이기 때문)
set likes:posting:1 0 # redis는 기본적으로 모든 key:value가 문자열, 내부적으로는 "0"으로 저장장
incr likes:posting:1 # 특정 key값의 value를 1만큼 증가
decr likes:posting:1 # 특정 key값의 value를 1만큼 감소

# redis 실전 활용3: 재고 관리 -> 동시성 이슈 해결
set stocks:product:1 100
decr stocks:product:1 
incr stocks:product:1 

# redis 실전 활용4: 캐싱 기능 구현
# 1번 회원 정보 조회: select name, email, age from member where id=1;
# 위 데이터의 결과값을 spring서버를 통해 json으로 변형하여, redis에 캐싱
# 최종적인 데이터 형식: {"name":"hong", "email":"hong@daum.net", "age":30}
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

# list 자료구조
# redis의 list는 deque와 같은 자료구조, 즉 double ended queue 구조
# lpush: 데이터를 list 자료구조에 왼쪽부터 삽입
# rpush: 데이터를 list 자료구조에 오른쪽부터 삽입
lpush hongs hong1
lpush hongs hong2
rpush hongs hong3

# list 조회: 0은 list의 시작 인덱스를, -1은 list의 마지막 인덱스를 의미
lrange hongs 0 -1 # 전체조회
lrange hongs -1 -1 # 마지막 값만 조회
lrange hongs 0 0 # 0번째 값만 조회
lrange hogns -2 -1 # 마지막 2번째부터 마지막까지
lrange hongs 0 2 # 0번째부터 2번째까지
# list 값 꺼내기 -> 꺼내면서 삭제 처리
rpop hongs  
lpop hongs
# A리스트에서 rpop하여 B리스트에서 lpush
rpoplpush A리스트 B리스트

# list의 데이터 개수 조회
llen hongs
# ttl 적용
expire hongs 20
# ttl 조회
ttl hongs
# redis 실전 활용5: 최근 조회한 상품 목록
rpush user:1:recent:product apple 
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango
# 최근 본 상품 3개 조회
lrange user:1:recent:product -3 -1

# set 자료구조: 중복 없음, 순서 없음 (list와의 차이점)
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
sadd memberlist m3 # 중복 값을 넣으면 알아서 제거됨
# set 조회
smembers memberlist
# set 멤버 개수 조회
scard memberlist
# 특정 멤버가 set 안에 있는지 존재 여부 확인
sismember memberlist m2 # 있으면 1, 없으면 0

# redis 실전 활용6: 좋아요 구현
# 게시글 상세보기에 들어가면
scard posting:likes:1
sismember posting:likes:1 a1@naver.com # 응답 값이 1이면 이미 좋아요를 한 사람
# 게시글에 좋아요를 하면
sadd posting:likes:1 a1@naver.com
# 좋아요한 사람을 클릭하면
smembers posting:likes:1

# zset: sorted set (정렬된 set)
# zset을 활용해서 최근 시간순으로 정렬 가능
# zset도 set이므로 같은 상품을 add할 경우에 중복이 제거되고, score(시간) 값만 업데이트
zadd user:1:recent:product 091330 mango
zadd user:1:recent:product 091331 apple
zadd user:1:recent:product 091332 banana
zadd user:1:recent:product 091333 orange
zadd user:1:recent:product 091334 apple

# zset 조회: zrange(score 기준 오름차순), zrevrange(score 기준 내림차순)
# withscores: score까지 함께 출력력
zrange user:1:recent:product 0 2
zrange user:1:recent:product -3 -1 # 결과: banana, orange, apple
zrevrange user:1:recent:product 0 2 withscores # 결과: apple, orange, banana

# 주식 시세 저장 (실시간 변동)
# 종목: 삼성전자, 시세: 55000원, 시간: 현재시간(유닉스 타임스탬프) -> 년월일시간을 초단위로 변환한 것
zadd stock:price:se 1748911141 55000
zadd stock:price:lg 1748911141 100000
zadd stock:price:se 1748911142 55500
zadd stock:price:lg 1748911143 110000
# 삼성전자의 현재 시세
zrange stock:price:se 0 0
zrevrange stock:price:se -1 -1

# hashes: value가 map형태의 자료구조 (key:value, key:value ... 형태의 자료구조)
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}"
hset member:info:1 name hong email hong@daum.net age 30
# 특정값 조회
hget member:info:1 name
# 모든 객체값 조회
hgetall member:info:1
# 특정 요소값 수정
hset member:info:1 name hong3

# redis 활용 상황: 빈번하고 변경되는 객체값을 저장시 효율적
