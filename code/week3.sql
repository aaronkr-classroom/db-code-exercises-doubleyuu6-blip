/*
[Entities / 개체]
-professor


-[professor/ 속성]
-id				(BIGSERIAL)__자동으로 증가하는 숫자
- name			(VARCHAR(30))
-dept			(VARCHAR(50))
-salary 		(NUMERIC)
-salary_level 	(NUMERIC)
-hire_date		(DATE) -- 'YYYY'
*/
CREATE TABLE prof(
	id bigserial,
	name varchar(30),
	dept varchar(30),
	salary numeric,
	hire_date date	
);

TABLE prof;

-- 데이터 삽입하기
INSERT INTO prof (name, dept, salary, salary_level, hire_date)
VALUES
	('김정운','컴퓨터공학', 100000, 2, '1998-12-31'),
	('박지선','AI공학', 100000, 1, '2001-3-1'),
	('이재삭','정보통신공학', 100000, 1, '2003-4-1'),
	('류현진','간호학과', 100000, 1, '2004-4-14'),
	('양정호','소프트웨어공학', 100000, 9, '1998-12-31')

--데이터 접속하기
	SELECT * FROM prof;

SELECT name, salary FROM prof;
SELECT name, salary FROM prof ORDER BY salary DESC; --ASC
SELECT name, salary FROM prof WHERE salary > 90000; 

/*
[Entities / 개체]
-professor


-[professor/ 속성]
-id				(BIGSERIAL)__자동으로 증가하는 숫자
- name			(VARCHAR(30))
-dept			(VARCHAR(50))
-salary 		(NUMERIC)
-salary_level 	(NUMERIC)
-hire_date		(DATE) -- 'YYYY'
*/
CREATE TABLE prof(
	id bigserial,
	name varchar(30),
	dept varchar(30),
	salary numeric,
	hire_date date	
);

TABLE prof;

-- 데이터 삽입하기
INSERT INTO prof (name, dept, salary, salary_level, hire_date)
VALUES
	('김정운','컴퓨터공학', 100000, 2, '1998-12-31'),
	('박지선','AI공학', 100000, 1, '2001-3-1'),
	('이재삭','정보통신공학', 100000, 1, '2003-4-1'),
	('류현진','간호학과', 100000, 1, '2004-4-14'),
	('양정호','소프트웨어공학', 100000, 9, '1998-12-31')

--데이터 접속하기
	SELECT * FROM prof;

SELECT name, salary FROM prof;
SELECT name, salary FROM prof ORDER BY salary DESC; --ASC
SELECT name, salary FROM prof WHERE salary > 90000; 
SELECT name, salary FROM prof WHERE name LIKE '김%'; -- postgreSQL ILIKE 대/소문자 상관없다
SELECT name, dept FROM prof
	WHERE dept LIKE '공%'
	ORDER BY dept DESC;

SELECT name, salary FROM prof WHERE salary BETWEEN 70001 AND 89999;
