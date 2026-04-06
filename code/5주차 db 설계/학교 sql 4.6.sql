---dbdiagram.io를 위해 수정하기
DROP TABLE professor;
CREAT TABLE professer(
	professor_id int [pk],
	professor_name varchar(100),
	department varchar(100),
	salary numeric,
	salary_level numeric,
	hire_date date

CREATE TABLE Course ( 
	course_id int,
	section_id int,
	professor_id int,
	course_name varchar(100),
	PRIMARY KEY (course_id, section_id ), --복합키
	FOREGIN KEY (professor_id, 

CREATE TABLE Enrollment (
	student_id int,
	course_int,
	grade varchar(2),
	points numeric, -- 99.65
	enrolled_at DATE, 
	PRIMARY KEY(student_id, course_id),
	FOREGIN(student_id) REFERENCES student(student_id),
	--FOREGIN KEY (course_Id) REFERENCES Course(course_id) -- Course의 복합키 때문에 오류
	
