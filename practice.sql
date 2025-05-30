-- member 테이블 생성
create table member
(id bigint auto_increment, name varchar(100), email varchar(100) not null,
password varchar(100) not null, role enum('user','seller') not null, primary key(id));

-- orders 테이블 생성
create table orders
(id bigint auto_increment, member_id bigint, order_date varchar(100), primary key(id), foreign key(member_id) references member(id));

-- product 테이블 생성
create table product
(id bigint auto_increment, member_id bigint, product_name varchar(10), 
product_price bigint, product_save bigint, foreign key(member_id) references member(id), primary key(id));

-- order_details 연결 테이블 생성
create table order_details
(id bigint auto_increment, orders_id bigint, product_id bigint, order_num bigint not null, primary key(id),
foreign key(orders_id) references orders(id), 
foreign key(product_id) references product(id));

-- 테스트
-- member 테스트 데이터 insert
insert into member(name, email, password, role) values('hong', 'hong@naver.com','1234','user');
insert into member(name, email, password, role) values('kim', 'kim@naver.com','2222','seller');
insert into member(name, email, password, role) values('lee', 'lee@naver.com','3333','seller');
insert into member(name, email, password, role) values('park', 'parkg@naver.com','4444','user');

-- orders 테스트 데이터 insert
insert into orders(member_id,order_date) values(1,'2025-05-01');
insert into orders(member_id,order_date) values(2,'2025-05-12');
insert into orders(member_id,order_date) values(3,'2025-07-03');
insert into orders(member_id,order_date) values(4,'2025-09-14');

-- product 테스트 데이터 insert
insert into product(member_id, product_name, product_price, product_save) values(1,'note',10000,10);
insert into product(member_id, product_name, product_price, product_save) values(2,'camera',800000,3);
insert into product(member_id, product_name, product_price, product_save) values(4,'sticker',5000,5);

-- order_details 테스트 데이터 insert
insert into order_details(orders_id, product_id, order_num) values(1,1,2),(1,2,1);
insert into order_details(orders_id, product_id, order_num) values(3,3,1);
insert into order_details(orders_id, product_id, order_num) values(4,2,1);

-- 조회 (주문 ID가 1인 상품 이름, 상품 가격, 주문상세_주문수량, 주문_일자 조회 -> 주문수량 기준 오름차순 정렬)
select name, p.product_name, p.product_price, od.order_num, o.order_date
from member m
inner join product p on m.id = p.id
inner join order_details od on p.id = od.product_id
inner join orders o on od.orders_id = o.id
where orders_id = 1
order by order_num;