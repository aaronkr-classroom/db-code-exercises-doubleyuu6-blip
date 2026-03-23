-- 테이블 생성
CREATE TABLE MEMBER (
    member_id  SERIAL PRIMARY KEY,
    name       VARCHAR(50)  NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    phone      VARCHAR(20),
    join_date  DATE         NOT NULL
);

CREATE TABLE PRODUCT (
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    price      INT          NOT NULL,
    stock      INT          DEFAULT 0,
    category   VARCHAR(50)
);

CREATE TABLE ORDER_ITEM (
    order_id    SERIAL PRIMARY KEY,
    member_id   INT  NOT NULL,
    product_id  INT  NOT NULL,
    quantity    INT  DEFAULT 1,
    order_date  DATE NOT NULL,
    FOREIGN KEY (member_id)  REFERENCES MEMBER(member_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
);

-- 데이터 삽입
INSERT INTO MEMBER (name, email, phone, join_date) VALUES
('김민준', 'minjun@email.com', '010-1111-2222', '2024-01-10'),
('이서연', 'seoyeon@email.com', '010-3333-4444', '2024-02-15'),
('박도윤', 'doyun@email.com', '010-5555-6666', '2024-03-05'),
('최지아', 'jia@email.com', '010-7777-8888', '2024-04-20'),
('정하은', 'haeun@email.com', '010-9999-0000', '2024-05-30');

INSERT INTO PRODUCT (name, price, stock, category) VALUES
('무선 마우스', 25000, 100, '전자기기'),
('노트북 파우치', 18000, 50,  '액세서리'),
('USB 허브',    32000, 80,  '전자기기'),
('모니터 받침대', 45000, 30,  '가구'),
('웹캠 HD',     67000, 20,  '전자기기');

INSERT INTO ORDER_ITEM (member_id, product_id, quantity, order_date) VALUES
(1, 1, 1, '2024-06-01'),
(2, 3, 2, '2024-06-03'),
(3, 5, 1, '2024-06-05'),
(4, 2, 3, '2024-06-07'),
(5, 4, 1, '2024-06-10');

-- 쿼리 (a) 전체 조회
SELECT * FROM MEMBER;
SELECT * FROM PRODUCT;

-- 쿼리 (b) 정렬