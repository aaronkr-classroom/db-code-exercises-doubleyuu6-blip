----customer Table
CREATE TABLE Customor (
	customer_id INT PRIMARY KEY,
	name VARCHAR(100),
	phone VARCHAR(13),
	address VARCHAR(100)
);

--restaurant Table 
CREATE  TABLE Restarant (
	restaurant_id  INT PRIMARY KEY,
	name VARCHAR(100),
	Phone VARCHAR(13),
	address VARCHAR(100)

);


---Orders Table
CREATE TABLE orders (
	order_id INT PRIMARY KEY,
	customer_id INT,	
	restaurant_id INT,
	order_date TIMESTAMP,
	total_date NUMERIC,
	FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
	FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id)

);

--Delivery
CREATE TABLE Delivery(
	delivery_id INT PRIMARY KEY,
	order_id INT, 
	driver_name VARCHAR(100),
	status INT,
	FOREIGN KEY (order_id) REFERENCES Orders(order_id_)
);

---DATA삽입
INSERT INTO Customer VALUES
(1, 'Alice', '010-1111-2222', '충주'),
(2, '김수민', '010-2222-3333','청주');

INSERT INTO Restaurant VALUES
(1, 'Pizza place', '010-1234-5678', '세종'),
(2, '김밥천국', '063-9876-5432', '전주');

INSERT INTO Orders VALUES
(1, 1, '2026-04-13 15:17:00', 24000),
(2, 2, 2, '2026-04-13 12:17:00', 8000);


INSERT INTO Delivery VALUES
(1, 1, '지석준', 1), --0: 받았다, 1: 조리하다, 2: 배달중, 3: 배달완료 4: 취소
(2, 2, '송지현', 3);


---DB 퀴리 
SELECT * FROM Orders;
SELECT * FROM Orders ORDER BY total DESC;
SELECT & FROM Orders WHERE total >= 10000;
SELECT & FROM Delivery WHERE status === 3;


	