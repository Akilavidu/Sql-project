--create database
CREATE DATABASE NSBM;
--creating tables
CREATE TABLE Student(
  student_id VARCHAR(10) PRIMARY KEY,
  nic INT NOT NULL,
  name VARCHAR(10) NOT NULL,
  contact_no VARCHAR(10) CHECK (contact_no LIKE '[0-9]%' AND LEN(contact_no) = 10),
  address VARCHAR(20),
  birthday DATE,
  registration_id VARCHAR(10),
  semester_fee_id VARCHAR(10),
  degree_id VARCHAR(10),
  library_id VARCHAR(10),
  faculty_id VARCHAR(10),
  result_id VARCHAR(10),
);

CREATE TABLE Coursework(
  coursework_id VARCHAR(10),
  module_id VARCHAR(10),
  coursework_name varchar(20),
  submission_date date,
  PRIMARY KEY (coursework_id)
  );
  ALTER TABLE Student
ALTER COLUMN name VARCHAR(50);
  ALTER TABLE Student
ALTER COLUMN nic VARCHAR(50);
ALTER TABLE Student
ALTER COLUMN address VARCHAR(100);
  CREATE TABLE Exam(
  exam_id varchar(10),
  exam_date date,
  module_id varchar(10),
  result INT,
  PRIMARY KEY(exam_id)
  );

  CREATE TABLE Semester_fee(
  semester_fee_id varchar(10),
  Pdate date,
  payment_method varchar(10),
  semester_id varchar(10),
  PRIMARY KEY (semester_fee_id)
  );

  CREATE TABLE Semester(
  semester_id VARCHAR(10),
  st_date date,
  finish_date date,
  PRIMARY KEY(semester_id)
  );

  CREATE TABLE Employee (

   employee_id VARCHAR(10),
   ename varchar(100),
   contact_no VARCHAR(10) CHECK (contact_no LIKE '[0-9]%' AND LEN(contact_no) = 10),
   birthday date,
   employee_type VARCHAR(5),
   PRIMARY KEY(employee_id)
  );

CREATE TABLE Lecture(
  lecture_id VARCHAR(10),
  lname VARCHAR(10),
  employee_id VARCHAR(10),
  PRIMARY KEY(lecture_id)
  );
ALTER TABLE Lecture
ALTER COLUMN lname varchar(50);
CREATE TABLE Degree(
   degree_id VARCHAR(10),
   ofered_by VARCHAR(5),
   department_id VARCHAR(10),
   degree_name varchar(100),
   PRIMARY KEY (degree_id)
   );

CREATE TABLE Registration(
  registration_id VARCHAR(10),
  rdate date,
  batch_id VARCHAR(10),
  registration_fee int,
  PRIMARY KEY(registration_id)
  );

CREATE TABLE batch (
  batch_id VARCHAR(10),
  batch_year DATE,
  PRIMARY KEY(batch_id),
);

CREATE TABLE Department(
  department_id VARCHAR(10),
  department_name varchar(100),
  department_head varchar(150),
   PRIMARY KEY(department_id)
  );

CREATE TABLE Faculty (
   faculty_id VARCHAR(10),
   faculty_name varchar(50),
   dean varchar (100),
   contact_no VARCHAR(10) CHECK (contact_no LIKE '[0-9]%' AND LEN(contact_no) = 10),
   PRIMARY KEY(faculty_id)
  );

CREATE TABLE Library (
   library_id VARCHAR(10),
   book_id VARCHAR(10),
   issued_date date,
   return_date date,
   PRIMARY KEY(library_id)
  );

CREATE TABLE Module(
    module_id VARCHAR(10),
    semester_name varchar(10),
    module_leader varchar(10),
    PRIMARY KEY ( module_id)
  );
ALTER TABLE Module
ALTER COLUMN module_leader varchar(50);

  CREATE TABLE result(
     result_id VARCHAR(10),
    exam_id VARCHAR(10),
    coursework_id VARCHAR(10),
    total int,
    PRIMARY KEY (result_id)
);
CREATE TABLE Employee_faculty(
  employee_id VARCHAR(10),
  faculty_id VARCHAR(10),
  PRIMARY KEY(faculty_id,employee_id)
  );
CREATE TABLE Lecture_Department(
  department_id varchar(10),
  lecture_id varchar(10),
 PRIMARY KEY (department_id,lecture_id)
  )
CREATE TABLE guardian (
  student_id VARCHAR(10),
  guardian_name VARCHAR(100),
  contact_no varchar(10),
  PRIMARY KEY (student_id, guardian_name)
);
ALTER TABLE guardian 
ADD CONSTRAINT CHK_contact_no 
CHECK (contact_no LIKE '[0-9]%' AND LEN(contact_no) = 10);

CREATE TABLE Dep_fac(
      faculty_id VARCHAR(10),
      department_id VARCHAR(10)
);
CREATE TABLE degree_semester(
    degree_id VARCHAR (10),
    semester_id VARCHAR(10),
  PRIMARY KEY ( degree_id,semester_id)
  );

CREATE TABLE Module_semester(
    module_id VARCHAR(10),
    semester_id VARCHAR(10),
    PRIMARY KEY (module_id,semester_id)
  );
CREATE TABLE module_lecturer(
    module_id VARCHAR (10),
    lecture_id VARCHAR(10),
    PRIMARY KEY ( module_id,lecture_id)
  );
--creating foreign key procedure
CREATE PROCEDURE foreignkey
    @ctn NVARCHAR(20),
    @ccn NVARCHAR(20),
    @ptn NVARCHAR(20),
    @pcn NVARCHAR(20),
    @cons_name NVARCHAR(20)
AS
BEGIN
    DECLARE @fk_exists INT;
    SELECT @fk_exists = COUNT(*)
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_NAME = @ctn
      AND CONSTRAINT_NAME = @cons_name;

    IF @fk_exists = 0
    BEGIN
        DECLARE @alter_sql NVARCHAR(MAX);
        SET @alter_sql = 'ALTER TABLE ' + QUOTENAME(@ctn) +
                          ' ADD CONSTRAINT ' + QUOTENAME(@cons_name) +
                          ' FOREIGN KEY (' + QUOTENAME(@ccn) + ') ' +
                          ' REFERENCES ' + QUOTENAME(@ptn) +
                          '(' + QUOTENAME(@pcn) + ')';
        EXEC sp_executesql @alter_sql;

        SELECT 'Foreign key added successfully' AS Result;
    END
    ELSE
        SELECT 'Foreign key already exists' AS Result;
END;
--executinf foreign key procedure
EXEC foreignkey 
    @ctn = 'Student', 
    @ccn =  'registration_id',
    @ptn = 'Registration', 
    @pcn = 'registration_id', 
    @cons_name = 'fk_stid_regid';
EXEC foreignkey 
    @ctn = 'guardian', 
    @ccn =  'student_id',
    @ptn = 'Student', 
    @pcn = 'student_id', 
    @cons_name = 'fk_gu_stud';
EXEC foreignkey 
    @ctn = 'Student', 
    @ccn =  'semester_fee_id',
    @ptn = 'Semester_fee', 
    @pcn = 'semester_fee_id', 
    @cons_name = 'fk_stid_semfe';

EXEC foreignkey 
    @ctn = 'Student', 
    @ccn =  'degree_id',
    @ptn = 'Degree', 
    @pcn = 'degree_id', 
    @cons_name = 'fk_stid_degr';

EXEC foreignkey 
    @ctn = 'Student', 
    @ccn =  'library_id',
    @ptn = 'Library', 
    @pcn = 'library_id', 
    @cons_name = 'fk_stid_lib';

EXEC foreignkey 
    @ctn = 'Student', 
    @ccn =  'faculty_id',
    @ptn = 'Faculty', 
    @pcn = 'faculty_id', 
    @cons_name = 'fk_stid_fac';

EXEC foreignkey 
    @ctn = 'Student', 
    @ccn =  'result_id',
    @ptn = 'result', 
    @pcn = 'result_id', 
    @cons_name = 'fk_stid_res';


EXEC foreignkey 
    @ctn = 'Dep_fac',
    @ccn =  'faculty_id',
    @ptn = 'Faculty',
    @pcn = 'faculty_id',
    @cons_name = 'fk_dep_fac_fac';

EXEC foreignkey 
    @ctn = 'Dep_fac',
    @ccn =  'department_id',
    @ptn = 'Department',
    @pcn = 'department_id',
    @cons_name = 'fk_dep_fac_dep';
EXEC foreignkey 
    @ctn = 'Student', 
    @ccn =  'result_id',
    @ptn = 'result', 
    @pcn = 'result_id', 
    @cons_name = 'fk_stid_res';

EXEC foreignkey 
    @ctn = 'result', 
    @ccn =  'exam_id',
    @ptn = 'exam', 
    @pcn = 'exam_id', 
    @cons_name ='fk_res_exam';

EXEC foreignkey 
    @ctn = 'result', 
    @ccn =  'coursework_id',
    @ptn = 'coursework', 
    @pcn = 'coursework_id', 
    @cons_name ='fk_res_course';

EXEC foreignkey 
    @ctn = 'registration', 
    @ccn =  'batch_id',
    @ptn = 'batch', 
    @pcn = 'batch_id', 
    @cons_name ='fk_reg_batch';

EXEC foreignkey 
    @ctn = 'degree', 
    @ccn =  'department_id',
    @ptn = 'department', 
    @pcn = 'department_id', 
    @cons_name ='fk_deg_dep';

EXEC foreignkey 
    @ctn = 'Student', 
    @ccn =  'result_id',
    @ptn = 'employee',  
    @pcn = 'employee_id',
	@cons_name ='fk_lec_emp';

EXEC foreignkey 
    @ctn = 'semester_fee', 
    @ccn =  'semester_id',
    @ptn = 'semester', 
    @pcn = 'semester_id', 
    @cons_name ='fk_semf_sem';

EXEC foreignkey 
    @ctn = 'exam', 
    @ccn =  'module_id',
    @ptn = 'module', 
    @pcn = 'module_id', 
    @cons_name ='fk_exam_mod';

EXEC foreignkey 
    @ctn = 'coursework', 
    @ccn =  'module_id',
    @ptn = 'module', 
    @pcn = 'module_id', 
    @cons_name ='fk_course_mod';
--making triggers
CREATE TRIGGER trg_exam
ON Exam
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE result
    SET total = COALESCE(total, 0) + ISNULL(i.result, 0)
    FROM result
    INNER JOIN inserted i ON result.exam_id = i.exam_id
    WHERE result.result_id IN (SELECT result_id FROM inserted);
END;
ALTER TABLE Coursework
ADD result INT;

CREATE TRIGGER trg_course
ON Coursework
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE result
    SET total = COALESCE(total, 0) + ISNULL(i.result, 0)
    FROM result
    INNER JOIN inserted i ON result.coursework_id = i.coursework_id
    WHERE result.result_id IN (SELECT result_id FROM inserted);
END;
CREATE TRIGGER trg_Semester_fee
ON Semester_fee
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Semester_fee
    SET payment_method = 'Online'
    WHERE payment_method IS NULL AND semester_fee_id IN (SELECT semester_fee_id FROM inserted);
END;
CREATE TRIGGER trg_UpdateSemesterDates
ON Semester
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Semester
    SET finish_date = DATEADD(MONTH, 4, st_date)
    WHERE semester_id IN (SELECT semester_id FROM inserted);
END;
--making functions
CREATE FUNCTION dbo.total_students()
RETURNS INT
AS
BEGIN
    DECLARE @TotalStudents INT;

    SELECT @TotalStudents = COUNT(student_id)
    FROM Student;

    RETURN @TotalStudents;
END;
DECLARE @Result INT = (SELECT dbo.total_students());

CREATE FUNCTION dbo.students_by_degree()
RETURNS @Result TABLE
(
    degree_id VARCHAR(10),
    student_count INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT degree_id, COUNT(student_id) as student_count
    FROM Student
    GROUP BY degree_id;

    RETURN;
END;
SELECT * FROM dbo.students_by_degree();
CREATE FUNCTION dbo.employeecount(@employee_type VARCHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @EmployeeCount INT;

    SELECT @EmployeeCount = COUNT(e.employee_id)
    FROM Employee e
    WHERE e.employee_type = @employee_type;

    RETURN @EmployeeCount;
END;
--making database views
CREATE VIEW student_result
AS
SELECT
    s.student_id,
    s.name,
    COALESCE(r.total, 0) AS result
FROM
    Student s
LEFT JOIN
    result r ON s.result_id = r.result_id;

CREATE VIEW unpaid
AS
SELECT student_id
FROM Student
WHERE semester_fee_id IS NULL;

CREATE PROCEDURE Unpaiddet
    @studentid VARCHAR(10)
AS
BEGIN
    DECLARE @lastpaid DATE;

    SELECT @lastpaid = MAX(Pdate)
    FROM Semester_fee
    WHERE semester_fee_id = (
        SELECT TOP 1 semester_fee_id
        FROM unpaid
        WHERE student_id = @studentid
        ORDER BY semester_fee_id DESC
    );

    IF DATEDIFF(MONTH, @lastpaid, GETDATE()) > 6
    BEGIN
        PRINT 'Unpaid';
    END
END;

CREATE VIEW vw_StudentResults
AS
SELECT
    s.student_id,
    s.name AS student_name,
    s.contact_no,
    s.birthday,
    d.degree_name,
    r.total AS result_total
FROM
    Student s
LEFT JOIN
    Degree d ON s.degree_id = d.degree_id
LEFT JOIN
    result r ON s.result_id = r.result_id;

CREATE VIEW vw_UnpaidSemesterFees
AS
SELECT
    s.student_id,
    s.name AS student_name,
    sf.semester_fee_id,
    sf.Pdate AS last_payment_date
FROM
    Student s
LEFT JOIN
    Semester_fee sf ON s.semester_fee_id = sf.semester_fee_id
WHERE
    s.semester_fee_id IS NULL
    OR sf.Pdate < DATEADD(MONTH, -6, GETDATE());

CREATE VIEW vw_ModuleSemesterInfo
AS
SELECT
    m.module_id,
    m.semester_name,
    m.module_leader,
    ms.semester_id
FROM
    Module m
LEFT JOIN
    module_semester ms ON m.module_id = ms.module_id;

CREATE FUNCTION dbo.students_in_faculty(@faculty_id VARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @TotalStudents INT;

    SELECT @TotalStudents = COUNT(s.student_id)
    FROM Student s
    WHERE s.faculty_id = @faculty_id;

    RETURN @TotalStudents;
END;
--making insert procedures
CREATE PROCEDURE InsertStudent
    @student_id VARCHAR(10),
    @name VARCHAR(50),
    @contact_no VARCHAR(10),
    @birthdate DATE,
    @nic VARCHAR(15),
    @address VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Student (student_id, name, contact_no, birthday, nic, address)
        VALUES (@student_id, @name, @contact_no, @birthdate, @nic, @address);

        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful. Error: ' + ERROR_MESSAGE();
    END CATCH
END;
CREATE PROCEDURE InsertGuardian
    @student_id VARCHAR(10),
    @guardian_name VARCHAR(100),
    @contact_no VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO guardian (student_id, guardian_name, contact_no)
        VALUES (@student_id, @guardian_name, @contact_no);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE InsertCourse
    @coursework_id VARCHAR(10),
    @module_id VARCHAR(10),
    @coursework_name VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Coursework (coursework_id, module_id, coursework_name)
        VALUES (@coursework_id, @module_id, @coursework_name);

        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE InsertExam
    @coursework_id VARCHAR(10),
    @module_id VARCHAR(10),
    @coursework_name VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Coursework (coursework_id, module_id, coursework_name)
        VALUES (@coursework_id, @module_id, @coursework_name);

        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE InsertSemesterFee
    @semester_fee_id VARCHAR(10),
    @payment_method VARCHAR(10),
    @semester_id VARCHAR(10)
AS
BEGIN
    DECLARE @date DATE = GETDATE();
    
    BEGIN TRY
        INSERT INTO Semester_fee (semester_fee_id, Pdate, payment_method, semester_id)
        VALUES (@semester_fee_id, @date, @payment_method, @semester_id);

        PRINT 'Insert successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertLectureDepartment
    @department_id varchar(10),
    @lecture_id varchar(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO lecture_department (department_id, lecture_id)
        VALUES (@department_id, @lecture_id);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertBatch
    @batch_id varchar(10),
    @batch_year date
AS
BEGIN
    BEGIN TRY
        INSERT INTO batch (batch_id, batch_year)
        VALUES (@batch_id, @batch_year);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;


CREATE PROCEDURE InsertDepartment
    @department_id varchar(10),
    @department_name varchar(50),
    @department_head varchar(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO department (department_id, department_name, department_head)
        VALUES (@department_id, @department_name, @department_head);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertEmployee
    @employee_id varchar(10),
    @name varchar(100), -- Update the length to 100 to match the table definition
    @contact_no varchar(10),
    @birthday date,
    @employee_type varchar(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO employee (employee_id, ename, contact_no, birthday, employee_type)
        VALUES (@employee_id, @name, @contact_no, @birthday, @employee_type); 
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful. Error: ' + ERROR_MESSAGE();
    END CATCH
END;

CREATE PROCEDURE InsertFaculty
    @faculty_id varchar(10),
    @faculty_name varchar(50),
    @dean varchar(50),
    @contact_no varchar(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO faculty (faculty_id, faculty_name, dean, contact_no)
        VALUES (@faculty_id, @faculty_name, @dean, @contact_no);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE InsertLibrary
    @library_id varchar(10),
    @book_id varchar(10),
    @issued_date date,
    @return_date date
AS
BEGIN
    BEGIN TRY
        INSERT INTO library (library_id, book_id, issued_date, return_date)
        VALUES (@library_id, @book_id, @issued_date, @return_date);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertModule
    @module_id varchar(10),
    @module_leader varchar(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO module(module_id, module_leader)
        VALUES (@module_id,@module_leader);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE InsertResult
    @result_id varchar(10),
    @total int
AS
BEGIN
    BEGIN TRY
        INSERT INTO result(result_id, total)
        VALUES (@result_id, @total);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE InsertRegistration
    @registration_id varchar(10),
    @date date,
    @registration_fee int
AS
BEGIN
    BEGIN TRY
        INSERT INTO registration(registration_id, rdate, registration_fee)
        VALUES (@registration_id, @date, @registration_fee);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE InsertDegree
    @degree_id varchar(10),
    @degree_name varchar(50),
    @offered_by varchar(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO degree(degree_id, degree_name,ofered_by)
        VALUES (@degree_id, @degree_name, @offered_by);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE InsertLecture_Department
    @department_id varchar(10),
    @lecture_id varchar(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO lecture_department(department_id, lecture_id)
        VALUES (@department_id, @lecture_id);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertLecture
    @lecture_id varchar(10),
    @name varchar(50),
    @employee_id varchar(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO lecture (lecture_id, lname)
        VALUES (@lecture_id, @name);
        INSERT INTO employee (employee_id, ename)
        VALUES (@employee_id, @name);

        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertModule_Lecture
    @module_id varchar(10),
    @lecture_id varchar(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO module_lecturer(module_id, lecture_id)
        VALUES (@module_id, @lecture_id);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertModule_Semester
    @module_id varchar(10),
    @semester_id varchar(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO module_semester (module_id, semester_id)
        VALUES (@module_id, @semester_id);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertDegree_Semester
    @degree_id varchar(10),
    @semester_id varchar(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO degree_semester (degree_id, semester_id)
        VALUES (@degree_id, @semester_id);
        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE InsertSemester
    @semester_id VARCHAR(10),
    @start_date DATE,
    @finish_date DATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO Semester (semester_id, st_date, finish_date)
        VALUES (@semester_id, @start_date, @finish_date);

        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful. Error: ' + ERROR_MESSAGE();
    END CATCH
END;
CREATE PROCEDURE InsertEmployeeFaculty
    @faculty_id VARCHAR(10),
    @employee_id VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO employee_faculty (faculty_id, employee_id)
        VALUES (@faculty_id, @employee_id);

        PRINT 'Insert Successful';
    END TRY
    BEGIN CATCH
        PRINT 'Insert Unsuccessful. Error: ' + ERROR_MESSAGE();
    END CATCH
END;
--making update procedures
CREATE PROCEDURE UpdateStudent
    @student_id VARCHAR(10),
    @name VARCHAR(50),
    @contact_no varchar(10),
    @birthdate date
AS
BEGIN
    BEGIN TRY
        UPDATE Student
        SET 
            name = @name,
            contact_no = @contact_no,
            birthday = @birthdate
        WHERE student_id = @student_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateBatch
    @batch_id VARCHAR(10),
    @batch_year DATE
AS
BEGIN
    BEGIN TRY
        UPDATE batch
        SET 
            batch_year = @batch_year
        WHERE batch_id = @batch_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateDepartment
   @department_id varchar(10),
   @department_name varchar(50),
   @department_head varchar(50)
AS
BEGIN
    BEGIN TRY
        UPDATE department
        SET 
            department_name = @department_name
            department_head = @department_head
            
        WHERE department_id = @department_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE UpdateEmployee
   @employee_id varchar(10),
   @name varchar(50),
   @contact_no int,
   @birthday date,
   @employee_type varchar(50)
AS
BEGIN
    BEGIN TRY
        UPDATE employee
        SET 
            ename = @name,
            contact_no = @contact_no,
            birthday = @birthday,
            employee_type = @employee_type
            
        WHERE employee_id = @employee_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE UpdateFaculty
   @faculty_id varchar(10),
   @faculty_name varchar(50),
   @dean varchar(50),
   @contact_no int
AS
BEGIN
    BEGIN TRY
        UPDATE faculty
        SET 
            faculty_name = @faculty_name,
            dean = @dean,
            contact_no = @contact_no
        WHERE faculty_id = @faculty_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE UpdateLibrary
   @library_id varchar(10),
   @book_id varchar(10),
   @issued_date date,
   @return_date date
AS
BEGIN
    BEGIN TRY
        UPDATE library
        SET 
            book_id = @book_id, 
            issued_date = @issued_date, 
            return_date = @return_date
        WHERE library_id = @library_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE Updatedegree_semester
    @degree_id varchar(10),
    @semester_id varchar(10)
AS
BEGIN
    BEGIN TRY
        UPDATE degree_semester
        SET 
            -- Add your SET statements here
            
        WHERE degree_id = @degree_id AND semester_id = @semester_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateModule
   @module_id varchar(10),
   @module_name varchar(50),
   @module_leader varchar(50)
AS
BEGIN
    BEGIN TRY
        UPDATE module
        SET 
            semester_name = @module_name,
            module_leader = @module_leader
             
        WHERE  module_id = @module_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;

CREATE PROCEDURE UpdateResult  
   @result_id varchar(10),
   @total int
AS
BEGIN
    BEGIN TRY
        UPDATE result
        SET 
            total = @total
            
        WHERE result_id = @result_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateRegistration  
     @registration_id varchar(10),
     @date date,
     @registration_fee int
AS 
BEGIN
    BEGIN TRY
        UPDATE registration 
        SET 
            rdate = @date,
            registration_fee = @registration_fee
  
        WHERE registration_id = @registration_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateDegree  
   @degree_id varchar(10),
   @degree_name varchar(50),
   @offered_by varchar(50)
AS
BEGIN
    BEGIN TRY
        UPDATE degree
        SET 
            degree_name = @degree_name,
            ofered_by = @offered_by
            
        WHERE degree_id = @degree_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateLecture  
   @lecture_id varchar(10),
   @name varchar(50)
AS
BEGIN
    BEGIN TRY
        UPDATE lecture
        SET 
            lname = @name
        WHERE lecture_id = @lecture_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateSemester
   @semester_id varchar(10),
   @start_date date,
   @finish_date date
AS
BEGIN
    BEGIN TRY
        UPDATE semester
        SET 
           st_date = @start_date,
           finish_date = @finish_date
        	
        WHERE semester_id = @semester_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateCoursework
   @coursework_id VARCHAR(10),
   @coursework_name VARCHAR(20),
   @submission_date date
AS
BEGIN
    BEGIN TRY
        UPDATE coursework
        SET
          coursework_name = @coursework_name,
          submission_date = @submission_date 
        WHERE coursework_id = @coursework_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateExam
   @exam_id VARCHAR(10),
   @exam_date date,
   @result int
AS
BEGIN
    BEGIN TRY
        UPDATE exam
        SET 
          exam_date = @exam_date,
   		  result = @result
        	
        WHERE exam_id = @exam_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;
CREATE PROCEDURE UpdateSemester_fee
   @semester_fee_id varchar(10),
   @date date,
   @payment_method varchar(10)
AS
BEGIN
    BEGIN TRY
        UPDATE semester_fee
        SET 
          pdate = @date,
          payment_method = @payment_method
        	
        WHERE semester_fee_id = @semester_fee_id;

        IF @@ROWCOUNT > 0
            PRINT 'Update Successful';
        ELSE
            PRINT 'No rows were updated';
    END TRY
    BEGIN CATCH
        PRINT 'Update Unsuccessful';
    END CATCH
END;

--data dictionary
USE NSBM;
;

CREATE VIEW datadictionary
AS
WITH vars
AS (
  SELECT 
    DB_NAME()  AS v_SchemaName
  , 'NO'       AS v_TablesOnly
)

, baseTbl
AS (
  SELECT TABLE_CATALOG AS SchemaName, table_type, table_name, table_schema
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_CATALOG = (SELECT v_SchemaName FROM vars) 
    AND (    (TABLE_TYPE = 'BASE TABLE')
       OR  ((SELECT v_TablesOnly FROM vars) = 'NO')  
      )
)

, metadata
AS (
  SELECT
    bt.SchemaName                                              AS schema_nm
  , bt.table_name                                              AS table_nm
  , CASE WHEN bt.table_type = 'BASE TABLE' THEN 'TBL'
         WHEN bt.table_type = 'VIEW'       THEN 'VW'
     ELSE 'UK'
    END                                                        AS obj_typ
  , RIGHT('000' + CAST(tut.ORDINAL_POSITION AS VARCHAR(3)), 3) AS ord_pos
  , tut.column_name                                            AS column_nm
  , COALESCE(tut.data_type, 'unknown') + 
    CASE WHEN tut.data_type IN('varchar','nvarchar')    THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
       WHEN tut.data_type IN('char','nchar')          THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
       WHEN tut.data_type ='date'                     THEN '(' + CAST(tut.DATETIME_PRECISION AS VARCHAR(10)) + ')'
       WHEN tut.data_type ='datetime'                 THEN '(' + CAST(tut.DATETIME_PRECISION AS VARCHAR(10)) + ')'
       WHEN tut.data_type in('bigint','int','smallint', 'tinyint') THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10))  + ')'
       WHEN tut.data_type = 'uniqueidentifier'        THEN '(16)'
       WHEN tut.data_type = 'money'                   THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ')'
       WHEN tut.data_type = 'decimal'                 THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(tut.NUMERIC_SCALE AS VARCHAR(10)) + ')'
       WHEN tut.data_type = 'numeric'                 THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(tut.NUMERIC_SCALE AS VARCHAR(10)) + ')'
       WHEN tut.data_type = 'varbinary'               THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
       WHEN tut.data_type = 'xml'                     THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
       WHEN tut.data_type IN('char','nchar')          THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
       WHEN tut.CHARACTER_MAXIMUM_LENGTH IS NOT NULL  THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
     WHEN tut.DATETIME_PRECISION IS NOT NULL        THEN '(' + CAST(tut.DATETIME_PRECISION AS VARCHAR(10)) + ')'
       WHEN tut.NUMERIC_PRECISION IS NOT NULL
      AND tut.NUMERIC_SCALE     IS NULL             THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ')'
       WHEN tut.NUMERIC_PRECISION IS NOT NULL
      AND tut.NUMERIC_SCALE     IS NOT NULL         THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(tut.NUMERIC_SCALE AS VARCHAR(10)) + ')'
     ELSE ''
    END AS data_typ
  , CASE WHEN tut.IS_NULLABLE = 'YES' THEN 'NULL' ELSE 'NOT NULL' END AS nullable
  FROM       INFORMATION_SCHEMA.COLUMNS tut
  INNER JOIN baseTbl                    bt  ON bt.SchemaName = tut.TABLE_CATALOG AND bt.table_name = tut.table_name
)

, descr
AS (
  SELECT 
    bt.SchemaName          AS schema_nm
  , bt.table_name          AS table_nm
  , tut.column_name        AS column_nm
  , STRING_AGG(CAST(de.value AS VARCHAR(1024)), '.  ') WITHIN GROUP (ORDER BY de.value) AS description
  FROM       INFORMATION_SCHEMA.COLUMNS tut
  INNER JOIN baseTbl                    bt  ON bt.SchemaName = tut.TABLE_CATALOG AND bt.table_name = tut.table_name
  LEFT JOIN  sys.extended_properties    de  ON de.major_id = OBJECT_ID(bt.table_schema + '.' + bt.table_name) 
                                           AND de.minor_id = tut.ORDINAL_POSITION
                                           AND de.name = 'MS_Description'
  GROUP BY bt.SchemaName, bt.table_name, tut.column_name
)

, metadata_keys
AS (
  SELECT schema_nm, table_nm, column_nm
  , STRING_AGG(key_typ, ',') WITHIN GROUP (ORDER BY key_typ) AS is_key 
  FROM (  
    SELECT 
      cons.TABLE_CATALOG AS schema_nm
    , cons.TABLE_NAME    AS table_nm
    , kcu.COLUMN_NAME    AS column_nm
    , CASE WHEN cons.CONSTRAINT_TYPE = 'PRIMARY KEY' THEN 'PK'
           WHEN cons.CONSTRAINT_TYPE = 'UNIQUE'      THEN 'UK'
           WHEN cons.CONSTRAINT_TYPE = 'FOREIGN KEY' THEN 'FK'
       ELSE 'X'
      END AS key_typ
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS      cons 
    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu 
             ON cons.TABLE_CATALOG = kcu.TABLE_CATALOG  
            AND cons.TABLE_NAME = kcu.TABLE_NAME
            AND cons.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    WHERE cons.TABLE_CATALOG = (SELECT v_SchemaName FROM vars)
      AND cons.table_name IN(SELECT DISTINCT table_name FROM baseTbl)
      AND cons.constraint_type IN('PRIMARY KEY','FOREIGN KEY','UNIQUE') 
    GROUP BY cons.TABLE_CATALOG, cons.TABLE_NAME, kcu.COLUMN_NAME, cons.CONSTRAINT_TYPE
  ) AS t
  GROUP BY schema_nm, table_nm, column_nm
)

SELECT md.schema_nm, md.table_nm, md.obj_typ, md.ord_pos
, COALESCE(mk.is_key, ' ') AS keys
, md.column_nm, md.data_typ, md.nullable
, de.[description]
FROM      metadata      md
LEFT JOIN descr         de ON de.schema_nm = md.schema_nm  AND  de.table_nm = md.table_nm  AND  de.column_nm = md.column_nm
LEFT JOIN metadata_keys mk ON mk.schema_nm = md.schema_nm  AND  mk.table_nm = md.table_nm  AND  mk.column_nm = md.column_nm;
--executing data dictionary
SELECT * FROM datadictionary ORDER BY schema_nm, table_nm, ord_pos;

--data insertion
--student
EXEC InsertStudent
    @student_id = 'S2109',
    @name = 'Dhanuka Rathnayaka',
    @contact_no = '0799999999',
    @birthdate = '2002/04/10',
	@nic='20014789663322';

EXEC InsertStudent
    @student_id = 'S2106',
    @name = 'Ashan Fernando',
    @contact_no = '0766666666',
    @birthdate = '2022/03/12',
    @nic = '200204899633';
UPDATE Student SET address = 'No 100 station rd' WHERE student_id = 'S2106';
UPDATE Student SET address = 'No 170 police rd' WHERE student_id = 'S2109';

select * from Student;
--batch
EXEC InsertBatch
    @batch_id = '20.1',
    @batch_year = '2020/02/03';
EXEC InsertBatch
    @batch_id = '21.1',
    @batch_year = '2021-01-01';

EXEC InsertBatch
    @batch_id = '22.1',
    @batch_year = '2022-01-01';

EXEC InsertBatch
    @batch_id = '23.1',
    @batch_year = '2023-01-01';

EXEC InsertBatch
    @batch_id = '24.1',
    @batch_year = '2024-01-01';

EXEC InsertBatch
    @batch_id = '25.1',
    @batch_year = '2025-01-01';

EXEC InsertBatch
    @batch_id = '26.1',
    @batch_year = '2026-01-01';

EXEC InsertBatch
    @batch_id = '27.1',
    @batch_year = '2027-01-01';

EXEC InsertBatch
    @batch_id = '28.1',
    @batch_year = '2028-01-01';

EXEC InsertBatch
    @batch_id = '29.1',
    @batch_year = '2029-01-01';
--Department
EXEC InsertDepartment
    @department_id = 'D1000',
    @department_name = 'Department of Computer Science and Data Science',
    @department_head = 'Anton Jayakody';

EXEC InsertDepartment
    @department_id = 'D1001',
    @department_name = 'Department of Software Engineering',
    @department_head = 'Nawaloka Edward';

EXEC InsertDepartment
    @department_id = 'D1002',
    @department_name = 'Department of Cyber security',
    @department_head = 'Syber Randiv';

EXEC InsertDepartment
    @department_id = 'D1003',
    @department_name = 'Department of Imformation management',
    @department_head = 'Selena Pavithra';

EXEC InsertDepartment
    @department_id = 'D1004',
    @department_name = 'Department of Architecture & Interior Designing',
    @department_head = 'Yovi Fernando';

EXEC InsertDepartment
    @department_id = 'D1005',
    @department_name = 'Department of Civil Engineering',
    @department_head = 'Avishka Jayathilaka';

EXEC InsertDepartment
    @department_id = 'D1006', 
    @department_name = 'Department of Bio Medical Science',
    @department_head = 'Vidumini Perera';
--employee
EXEC InsertEmployee
    @employee_id = 'E6000',
    @name = 'Ona Klocko',
    @contact_no = '0786932145',
    @birthday = '2022-06-01',
    @employee_type = 'Non_academic';

EXEC InsertEmployee
    @employee_id = 'E6002',
    @name = 'Brian Mayer',
    @contact_no = '0789635214',
    @birthday = '2022-06-02',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6003',
    @name = 'Rickie Windler',
    @contact_no = '0789636654',
    @birthday = '2022-06-03',
    @employee_type = 'Non_academic';

EXEC InsertEmployee
    @employee_id = 'E6004',
    @name = 'Effie Halvorson',
    @contact_no = '0453689789',
    @birthday = '2022-06-04',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6005',
    @name = 'Orville Nolan',
    @contact_no = '0784512369',
    @birthday = '2022-06-05',
    @employee_type = 'Non_academic';

EXEC InsertEmployee
    @employee_id = 'E6006',
    @name = 'Rebeca Sipes',
    @contact_no = '0893645123',
    @birthday = '2022-06-06',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6007',
    @name = 'Fidel Ziemann',
    @contact_no = '0784156321',
    @birthday = '2022-06-07',
    @employee_type = 'Non_academic';

EXEC InsertEmployee
    @employee_id = 'E6008',
    @name = 'Granville Emmerich',
    @contact_no = '0915642478',
    @birthday = '2022-06-08',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6009',
    @name = 'Emmie Runteh',
    @contact_no = '0785694125',
    @birthday = '2022-06-09',
    @employee_type = 'Non_academic';


EXEC InsertEmployee
    @employee_id = 'E6010',
    @name = 'Amari Davis',
    @contact_no = '1899999999',
    @birthday = '2022-06-10',
    @employee_type = 'Non_academic';
ALTER TABLE Employee
ALTER COLUMN employee_type VARCHAR(20);
select * from Employee;
--faculty
EXEC InsertFaculty
    @faculty_id = 'F550',
    @faculty_name = 'Computer Faculty',
    @contact_no = '0601234567',
    @dean = 'Fredy Skiles';

EXEC InsertFaculty
    @faculty_id = 'F551',
    @faculty_name = 'Business Faculty',
    @contact_no = '0612345678',
    @dean = 'Tad Casper';

EXEC InsertFaculty
    @faculty_id = 'F552',
    @faculty_name = 'Engineering Faculty',
    @contact_no = '0623456789',
    @dean = 'Keanu Pouros';

EXEC InsertFaculty
    @faculty_id = 'F553',
    @faculty_name = 'Science Faculty',
    @contact_no = '0634567890',
    @dean = 'Jada Crona';
--library
EXEC InsertLibrary
    @library_id = '1AAA',
    @book_id = '1.AA',
    @issued_date = '2023/01/01',
    @return_date = '2023/02/01';

EXEC InsertLibrary
    @library_id = '1AAB',
    @book_id = '1.AB',
    @issued_date = '2023/02/01',
    @return_date = '2023/02/02';

EXEC InsertLibrary
    @library_id = '1AAC',
    @book_id = '1.AC',
    @issued_date = '2023/03/01',
    @return_date = '2023/03/02';

EXEC InsertLibrary
    @library_id = '1AAD',
    @book_id = '1.AD',
    @issued_date = '2023/04/01',
    @return_date = '2023/04/02';

EXEC InsertLibrary
    @library_id = '1AAE',
    @book_id = '1.AE',
    @issued_date = '2023/05/01',
    @return_date = '2023/05/02';

EXEC InsertLibrary
    @library_id = '1AAF',
    @book_id = '1.AF',
    @issued_date = '2023/04/01',
    @return_date = '2023/04/02';

EXEC InsertLibrary
    @library_id = '1AAG',
    @book_id = '1.AG',
    @issued_date = '2023/05/01',
    @return_date = '2023/05/02';

EXEC InsertLibrary
    @library_id = '1AAH',
    @book_id = '1.AH',
    @issued_date = '2023/06/01',
    @return_date = '2023/06/02';

EXEC InsertLibrary
    @library_id = '1AAI',
    @book_id = '1.AI',
    @issued_date = '2023/07/01',
    @return_date = '2023/07/02';

EXEC InsertLibrary
    @library_id = '1AAJ',
    @book_id = '1.AJ',
    @issued_date = '2023/08/01',
    @return_date = '2023/08/02';
--module
EXEC InsertModule
    @module_id = 'M101',
    @module_leader = 'Levi Lesch';

EXEC InsertModule
    @module_id = 'M102',
    @module_leader = 'Jeramie Berge';

EXEC InsertModule
    @module_id = 'M103',
    @module_leader = 'Alessia Schmeler';

EXEC InsertModule
    @module_id = 'M104',
    @module_leader = 'Jeramy Osinski';

EXEC InsertModule
    @module_id = 'M105',
    @module_leader = 'Makayla Simonis';

EXEC InsertModule
    @module_id = 'M106',
    @module_leader = 'Blake Gleichner';

EXEC InsertModule
    @module_id = 'M107',
    @module_leader = 'Kane Bartell';

EXEC InsertModule
    @module_id = 'M108',
    @module_leader = 'Maritza Bogisich';

EXEC InsertModule
    @module_id = 'M109',
    @module_leader = 'Kristian Hane';

EXEC InsertModule
    @module_id = 'M110',
    @module_leader = 'Coralie Nitzsche';
--result
EXEC InsertResult
    @result_id = 'R101',
    @total = 80;

EXEC InsertResult
    @result_id = 'R102',
    @total = 80;

EXEC InsertResult
    @result_id = 'R103',
    @total = 80;

EXEC InsertResult
    @result_id = 'R104',
    @total = 80;

EXEC InsertResult
    @result_id = 'R105',
    @total = 80;

EXEC InsertResult
    @result_id = 'R106',
    @total = 80;

EXEC InsertResult
    @result_id = 'R107',
    @total = 80;

EXEC InsertResult
    @result_id = 'R108',
    @total = 80;

EXEC InsertResult
    @result_id = 'R109',
    @total = 80;

EXEC InsertResult
    @result_id = 'R110',
    @total = 80;

--registration
EXEC InsertRegistration
    @registration_id = 'RID1',
    @date = '2023/09/01',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID2',
    @date = '2023/09/02',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID3',
    @date = '2023/09/03',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID4',
    @date = '2023/09/04',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID5',
    @date = '2023/09/05',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID6',
    @date = '2023/09/06',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID7',
    @date = '2023/09/07',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID8',
    @date = '2023/09/08',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID9',
    @date = '2023/09/09',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID10',
    @date = '2023/09/10',
    @registration_fee = 10000;
--degree
EXEC InsertDegree
    @degree_id = 'DE1',
    @degree_name = 'Computer Science',
    @offered_by = 'ply';

EXEC InsertDegree
    @degree_id = 'DE2',
    @degree_name = 'Data Science',
    @offered_by = 'ugc';

EXEC InsertDegree
    @degree_id = 'DE3',
    @degree_name = 'Software Engineering',
    @offered_by = 'vu';

EXEC InsertDegree
    @degree_id = 'DE4',
    @degree_name = 'Technology Management',
    @offered_by = 'ply';

EXEC InsertDegree
    @degree_id = 'DE5',
    @degree_name = 'MIS',
    @offered_by = 'ugc';

EXEC InsertDegree
    @degree_id = 'DE6',
    @degree_name = 'Bio Medical Science',
    @offered_by = 'vu';

EXEC InsertDegree
    @degree_id = 'DE7',
    @degree_name = 'Civil Engineering',
    @offered_by = 'ply';

EXEC InsertDegree
    @degree_id = 'DE8',
    @degree_name = 'Interior Designing',
    @offered_by = 'ugc';

EXEC InsertDegree
    @degree_id = 'DE9',
    @degree_name = 'Cyber Security',
    @offered_by = 'vu';

EXEC InsertDegree
    @degree_id = 'DE10',
    @degree_name = 'Computer Security',
    @offered_by = 'ply';
--lecturer
EXEC InsertLecture
    @lecture_id = 'LI100',
    @name = 'Jarvis Jaskolski',
    @employee_id = 'E1000';

EXEC InsertLecture
    @lecture_id = 'LI101',
    @name = 'Minerva Christiansen',
    @employee_id = 'E1001';

EXEC InsertLecture
    @lecture_id = 'LI102',
    @name = 'Javonte Ruecker',
    @employee_id = 'E1002';

EXEC InsertLecture
    @lecture_id = 'LI103',
    @name = 'Duncan Adams',
    @employee_id = 'E1003';

EXEC InsertLecture
    @lecture_id = 'LI104',
    @name = 'Bruce Quitzon',
    @employee_id = 'E1004';

EXEC InsertLecture
    @lecture_id = 'LI105',
    @name = 'Magali Ebert',
    @employee_id = 'E1005';

EXEC InsertLecture
    @lecture_id = 'LI106',
    @name = 'Brandy Macejkovic',
    @employee_id = 'E1006';

EXEC InsertLecture
    @lecture_id = 'LI107',
    @name = 'Coleman Dicki',
    @employee_id = 'E1007';

EXEC InsertLecture
    @lecture_id = 'LI108',
    @name = 'Sebastian Hills',
    @employee_id = 'E1008';

EXEC InsertLecture
    @lecture_id = 'LI109',
    @name = 'Lyla Schiller',
    @employee_id = 'E1009';
--semsester
EXEC InsertSemester
    @semester_id = 'SE1',
    @start_date = '2023/01/01',
    @finish_date = '2023/01/06';

EXEC InsertSemester
    @semester_id = 'SE2',
    @start_date = '2023/02/06',
    @finish_date = '2023/02/12';
--employee_faculty
EXEC InsertEmployeeFaculty
    @faculty_id = 'F550',
    @employee_id = 'E6000';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F551',
    @employee_id = 'E6002';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F552',
    @employee_id = 'E6003';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F553',
    @employee_id = 'E6004';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F553',
    @employee_id = 'E6005';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F550',
    @employee_id = 'E6006';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F552',
    @employee_id = 'E6007';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F551',
    @employee_id = 'E6008';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F550',
    @employee_id = 'E6009';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F553',
    @employee_id = 'E6010';
--lecture department
EXEC InsertLectureDepartment
    @department_id = 'D1000',
    @lecture_id = 'LI100';

EXEC InsertLectureDepartment
    @department_id = 'D1001',
    @lecture_id = 'LI101';

EXEC InsertLectureDepartment
    @department_id = 'D1002',
    @lecture_id = 'LI102';

EXEC InsertLectureDepartment
    @department_id = 'D1003',
    @lecture_id = 'LI103';

EXEC InsertLectureDepartment
    @department_id = 'D1004',
    @lecture_id = 'LI104';

EXEC InsertLectureDepartment
    @department_id = 'D1005',
    @lecture_id = 'LI105';

EXEC InsertLectureDepartment
    @department_id = 'D1006',
    @lecture_id = 'LI106';

EXEC InsertLectureDepartment
    @department_id = 'D1005',
    @lecture_id = 'LI107';

EXEC InsertLectureDepartment
    @department_id = 'D1004',
    @lecture_id = 'LI108';

EXEC InsertLectureDepartment
    @department_id = 'D1003',
    @lecture_id = 'LI109';
--module lecture
EXEC Insertmodule_lecture
    @module_id = 'M110',
    @lecture_id = 'LI100';

EXEC Insertmodule_lecture
    @module_id = 'M103',
    @lecture_id = 'LI101';

EXEC Insertmodule_lecture
    @module_id = 'M102',
    @lecture_id = 'LI102';

EXEC Insertmodule_lecture
    @module_id = 'M105',
    @lecture_id = 'LI103';

EXEC Insertmodule_lecture
    @module_id = 'M101',
    @lecture_id = 'LI104';

EXEC Insertmodule_lecture
    @module_id = 'M107',
    @lecture_id = 'LI105';

EXEC Insertmodule_lecture
    @module_id = 'M106',
    @lecture_id = 'LI106';

EXEC Insertmodule_lecture
    @module_id = 'M108',
    @lecture_id = 'LI107';

EXEC Insertmodule_lecture
    @module_id = 'M109',
    @lecture_id = 'LI108';

EXEC Insertmodule_lecture
    @module_id = 'M104',
    @lecture_id = 'LI109';
--module semester
EXEC Insertmodule_semester
    @module_id = 'M110',
    @semester_id = 'SE1';

EXEC Insertmodule_semester
    @module_id = 'M109',
    @semester_id = 'SE2';

EXEC Insertmodule_semester
    @module_id = 'M108',
    @semester_id = 'SE1';

EXEC Insertmodule_semester
    @module_id = 'M107',
    @semester_id = 'SE2';

EXEC Insertmodule_semester
    @module_id = 'M106',
    @semester_id = 'SE1';

EXEC Insertmodule_semester
    @module_id = 'M105',
    @semester_id = 'SE2';

EXEC Insertmodule_semester
    @module_id = 'M104',
    @semester_id = 'SE1';

EXEC Insertmodule_semester
    @module_id = 'M103',
    @semester_id = 'SE2';

EXEC Insertmodule_semester
    @module_id = 'M102',
    @semester_id = 'SE1';

EXEC Insertmodule_semester
    @module_id = 'M101',
    @semester_id = 'SE2';

	--degree semester
EXEC Insertdegree_semester
    @degree_id = 'DE1',
    @semester_id = 'SE1';

EXEC Insertdegree_semester
    @degree_id = 'DE2',
    @semester_id = 'SE2';

EXEC Insertdegree_semester
    @degree_id = 'DE3',
    @semester_id = 'SE1';

EXEC Insertdegree_semester
    @degree_id = 'DE4',
    @semester_id = 'SE2';

EXEC Insertdegree_semester
    @degree_id = 'DE5',
    @semester_id = 'SE1';

EXEC Insertdegree_semester
    @degree_id = 'DE6',
    @semester_id = 'SE2';

EXEC Insertdegree_semester
    @degree_id = 'DE7',
    @semester_id = 'SE1';

EXEC Insertdegree_semester
    @degree_id = 'DE8',
    @semester_id = 'SE2';

EXEC Insertdegree_semester
    @degree_id = 'DE9',
    @semester_id = 'SE1';

EXEC Insertdegree_semester
    @degree_id = 'DE10',
    @semester_id = 'SE2';
EXEC InsertGuardian
    @student_id = 'S2100',
    @guardian_name = 'Rey Zemlak',
    @contact_no = '0200000000';

--guardian
EXEC InsertGuardian
    @student_id = 'S2101',
    @guardian_name = 'Levi Yost',
    @contact_no = '0211111111';

EXEC InsertGuardian
    @student_id = 'S2102',
    @guardian_name = 'Blanche Mosciski',
    @contact_no = '0222222222';

EXEC InsertGuardian
    @student_id = 'S2103',
    @guardian_name = 'Anastasia Ondricka',
    @contact_no = '0233333333';

EXEC InsertGuardian
    @student_id = 'S2104',
    @guardian_name = 'Pearline Herzog',
    @contact_no = '0244444444';

EXEC InsertGuardian
    @student_id = 'S2105',
    @guardian_name = 'Roberta Adams',
    @contact_no = '0255555555';

EXEC InsertGuardian
    @student_id = 'S2106',
    @guardian_name = 'Treva Kris',
    @contact_no = '0266666666';

EXEC InsertGuardian
    @student_id = 'S2107',
    @guardian_name = 'Delta Kohler',
    @contact_no = '0277777777';

EXEC InsertGuardian
    @student_id = 'S2108',
    @guardian_name = 'Jeff Smith',
    @contact_no = '0288888888';

EXEC InsertGuardian
    @student_id = 'S2109',
    @guardian_name = 'Gilbert Gorczany',
    @contact_no = '0299999999';
