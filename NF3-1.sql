BEGIN TRANSACTION;
CREATE TABLE "CLASS" (
	"student_dept"	varchar(30),
	"student_grade"	INTEGER,
	"student_class"	varchar(1),
	CONSTRAINT PK_CLASS PRIMARY KEY("student_dept", "student_grade", "student_class")
);
CREATE TABLE "STUDENT" (
	"student_name"		varchar(20),
	"student_status"	varchar(2),
	"student_dept"	varchar(30),
	"student_grade"	INTEGER,
	"student_class"	varchar(1),
	CONSTRAINT PK_STUDENT PRIMARY KEY("student_name", "student_status", "student_dept", "student_grade", "student_class"),
    CONSTRAINT FK_STUDENT_CLASS FOREIGN KEY ("student_dept", "student_grade", "student_class") 
        REFERENCES "CLASS" ("student_dept", "student_grade", "student_class"),
	CONSTRAINT chk_status CHECK ("student_status" IN ('在學', '休學', '退學'))
);
CREATE TABLE "TEACHER" (
	"teacher_name"	varchar(20) PRIMARY KEY
);
CREATE TABLE "TIME" (
	"day" 			char,
	"session"		INTEGER,
	CONSTRAINT PK_TIME PRIMARY KEY("day", "session")
);
CREATE TABLE "FIELD" (
	"curriculum_field"	varchar(40) PRIMARY KEY
);
CREATE TABLE "CLASSROOM" (
	"course_room"	varchar(20) PRIMARY KEY,
	"course_building"	varchar(20)
);
CREATE TABLE "COURSE" (
	"semester"	varchar(4),
	"course_no"	varchar(5),
	"course_name"	varchar(255),
	"course_type"	varchar(2),
	"course_credit"	INTEGER,
	"course_limit"	INTEGER,
	"course_status"	varchar(2),
	"course_room"	varchar(20),
	CONSTRAINT PK_COURSE PRIMARY KEY("semester", "course_no"),
    CONSTRAINT FK_COURSE_CLASSROOM FOREIGN KEY ("course_room") 
        REFERENCES "CLASSROOM" ("course_room"),
	CONSTRAINT chk_course_type CHECK ("course_type" IN ('必修', '選修')),
	CONSTRAINT chk_course_status CHECK ("course_status" IN ('開課', '停開'))
);
CREATE TABLE "BelongField" (
	"curriculum_field"	varchar(40),
	"semester"	varchar(4),
	"course_no"	varchar(5),
	CONSTRAINT PK_BelongField PRIMARY KEY("curriculum_field", "semester", "course_no"),
    CONSTRAINT FK_BelongField_COURSE FOREIGN KEY ("semester", "course_no") 
        REFERENCES "COURSE" ("semester", "course_no"),
    CONSTRAINT FK_BelongField_FIELD FOREIGN KEY ("curriculum_field") 
        REFERENCES "FIELD" ("curriculum_field")
);
CREATE TABLE "TeachBy" (
	"teacher_name"	varchar(20),
	"semester"	varchar(4),
	"course_no"	varchar(5),
	CONSTRAINT PK_TeachBy PRIMARY KEY("teacher_name", "semester", "course_no"),
    CONSTRAINT FK_TeachBy_COURSE FOREIGN KEY ("semester", "course_no") 
        REFERENCES "COURSE" ("semester", "course_no"),
    CONSTRAINT FK_TeachBy_TEACHER FOREIGN KEY ("teacher_name") 
        REFERENCES "TEACHER" ("teacher_name")
);
CREATE TABLE "TakeBy" (
	"student_name"		varchar(20),
	"student_status"	varchar(2),
	"student_dept"	varchar(30),
	"student_grade"	INTEGER,
	"student_class"	varchar(1),
	"semester"	varchar(4),
	"course_no"	varchar(5),
	"select_result"	varchar(2),
	"course_score"	NUMERIC,
	"feedback_rank"	INTEGER,
	CONSTRAINT PK_TakeBy PRIMARY KEY("student_name", "student_status", "student_dept", "student_grade", "student_class", "semester", "course_no"),
    CONSTRAINT FK_TakeBy_COURSE FOREIGN KEY ("semester", "course_no") 
        REFERENCES "COURSE" ("semester", "course_no"),
    CONSTRAINT FK_TakeBy_STUDENT FOREIGN KEY ("student_name", "student_status", "student_dept", "student_grade", "student_class") 
        REFERENCES "STUDENT" ("student_name", "student_status", "student_dept", "student_grade", "student_class"),
	CONSTRAINT chk_select_result CHECK ("select_result" IN ('中選', '落選')),
	CONSTRAINT chk_feedback_rank CHECK ("feedback_rank" >=1 AND "feedback_rank" <= 5),
);
CREATE TABLE "TakeTime" (
	"day" 			char,
	"session"		INTEGER,
	"semester"	varchar(4),
	"course_no"	varchar(5),
	CONSTRAINT PK_TakeTime PRIMARY KEY("day", "session", "semester", "course_no"),
    CONSTRAINT FK_TakeTime_COURSE FOREIGN KEY ("semester", "course_no") 
        REFERENCES "COURSE" ("semester", "course_no"),
    CONSTRAINT FK_TakeTime_TIME FOREIGN KEY ("day", "session") 
        REFERENCES "TIME" ("day", "session")
);
COMMIT;