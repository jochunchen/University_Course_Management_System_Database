BEGIN TRANSACTION;
-- 插入数据到 CLASS 表
INSERT INTO CLASS (student_dept, student_grade, student_class) 
SELECT DISTINCT student_dept, student_grade, student_class FROM course_data;

-- 插入数据到 STUDENT 表
INSERT INTO STUDENT (student_name, student_status, student_dept, student_grade, student_class)
SELECT DISTINCT student_name, student_status, student_dept, student_grade, student_class FROM course_data;

-- 插入数据到 TEACHER 表
INSERT INTO TEACHER (teacher_name)
SELECT DISTINCT teacher_name FROM course_data;

-- 插入数据到 FIELD 表
INSERT INTO FIELD (curriculum_field)
SELECT DISTINCT curriculum_field FROM course_data;

-- 插入数据到 CLASSROOM 表
INSERT INTO CLASSROOM (course_room, course_building)
SELECT DISTINCT course_room, course_building FROM course_data;

-- 插入数据到 COURSE 表
INSERT INTO COURSE (semester, course_no, course_name, course_type, course_credit, course_limit, course_status, course_room)
SELECT DISTINCT semester, course_no, course_name, course_type, course_credit, course_limit, course_status, course_room FROM course_data;

-- 插入数据到 BelongField 表
INSERT INTO BelongField (curriculum_field, semester, course_no)
SELECT DISTINCT curriculum_field, semester, course_no FROM course_data;

-- 插入数据到 TeachBy 表
INSERT INTO TeachBy (teacher_name, semester, course_no)
SELECT DISTINCT teacher_name, semester, course_no FROM course_data;

-- 插入数据到 TakeBy 表
INSERT INTO TakeBy (student_name, student_status, student_dept, student_grade, student_class, semester, course_no, select_result, course_score, feedback_rank)
SELECT DISTINCT student_name, student_status, student_dept, student_grade, student_class, semester, course_no, select_result, course_score, feedback_rank FROM course_data;

CREATE TABLE RawData (
    id INT IDENTITY,
	"course_time"	varchar(20),
	"semester"	varchar(4),
	"course_no"	varchar(5),
);

INSERT INTO RawData (course_time, semester, course_no) SELECT DISTINCT course_time, semester, course_no FROM course_data;

create TABLE split1(
  id INT IDENTITY,
  course_time TEXT,
  semester varchar(4),
  course_no varchar(5)
 );

INSERT INTO split1 ("course_time", "semester", "course_no")
SELECT DISTINCT "value" AS course_time, "semester", "course_no" -- 将拆分的值转换为整数（如果需要）
FROM RawData
CROSS APPLY STRING_SPLIT(course_time, ',');

DROP TABLE "RawData";

create TABLE TimeTable(
  "day" varchar(1),
  "session" INT,
  semester varchar(4),
  course_no varchar(5)
 );
 
-- 步骤3：从原表中提取字符串，拆分并插入新的表中
INSERT INTO TimeTable ("day", "session", "semester", "course_no")
SELECT DISTINCT
    SUBSTRING(course_time, 1, 1) AS "day",
    CAST(c.CharValue AS INT) AS "session",
    "semester", "course_no"
FROM
    split1
CROSS APPLY
    SplitStringToChars(SUBSTRING(course_time, 2, Datalength(course_time)-1)) c

DROP TABLE split1;

-- 插入数据到 TIME 表
INSERT INTO TIME ("day", "session")
SELECT DISTINCT "day", "session" FROM "TimeTable";

-- 插入数据到 TakeTime 表
INSERT INTO TakeTime ("day", "session", semester, course_no)
SELECT DISTINCT "day", "session", semester, course_no FROM "TimeTable";

DROP TABLE "TimeTable"
COMMIT;