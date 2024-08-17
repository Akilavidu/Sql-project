--Creating database
CREATE DATABASE nsbm_university;
--Creating tables
--Creating student table(main table)
CREATE TABLE Student(
  student_id VARCHAR(10) PRIMARY KEY,
  nic varchar(15) NOT NULL,
  name VARCHAR(150) NOT NULL,
  contact_no VARCHAR(10) CHECK (contact_no LIKE '[0-9]%' AND LEN(contact_no) = 10),
  address VARCHAR(50),
  birthday DATE,
  registration_id VARCHAR(10),
  semester_fee_id VARCHAR(10),
  degree_id VARCHAR(10),
  library_id VARCHAR(10),
  faculty_id VARCHAR(10),
  result_id VARCHAR(10),
);
--Creating Coursework table
CREATE TABLE Coursework(
  coursework_id VARCHAR(10),
  module_id VARCHAR(10),
  coursework_name varchar(20),
  submission_date date,
  result INT,
  PRIMARY KEY (coursework_id)
  );

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
   employee_type VARCHAR(20),
   PRIMARY KEY(employee_id)
  );

CREATE TABLE Lecture(
  lecture_id VARCHAR(10),
  lname VARCHAR(50),
  employee_id VARCHAR(10),
  PRIMARY KEY(lecture_id)
  );

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
    module_leader varchar(50),
    PRIMARY KEY ( module_id)
  );


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
  );
CREATE TABLE guardian (
  student_id VARCHAR(10),
  guardian_name VARCHAR(100),
  contact_no VARCHAR(10) CHECK (contact_no LIKE '[0-9]%' AND LEN(contact_no) = 10),
  PRIMARY KEY (student_id, guardian_name)
);

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
--executing foreign key procedure
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

CREATE TRIGGER trg_course
ON Coursework
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE result
    SET total = COALESCE(total, 0) + (
        SELECT COALESCE(i.result, 0)
        FROM inserted i
        WHERE i.coursework_id = result.coursework_id
    )
    WHERE EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.coursework_id = result.coursework_id
    );
END;
CREATE TRIGGER trg_Semester_fee
ON Semester_fee
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Semester_fee
    SET payment_method = 'Online'
    WHERE payment_method IS NULL 
    AND EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.semester_fee_id = Semester_fee.semester_fee_id
    );
END;
CREATE TRIGGER trg_UpdateSemesterDates
ON Semester
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Semester
    SET finish_date = DATEADD(MONTH, 4, st_date)
    WHERE EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.semester_id = Semester.semester_id
    );
END;
--making functions
CREATE FUNCTION dbo.total_students()
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT COUNT(student_id)
        FROM Student
    );
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
CREATE FUNCTION dbo.employeecount(@employee_type VARCHAR(5))
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT COUNT(e.employee_id)
        FROM Employee e
        WHERE e.employee_type = @employee_type
    );
END;
CREATE FUNCTION dbo.students_in_faculty(@faculty_id VARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @TotalStudents INT;

    -- Use a direct assignment for the total count
    SELECT @TotalStudents = COUNT(*)
    FROM Student s
    WHERE s.faculty_id = @faculty_id;

    RETURN @TotalStudents;
END;
--making database views
CREATE VIEW student_result
AS
SELECT
    s.student_id,
    s.name,
    ISNULL(r.total, 0) AS result
FROM
    Student s
LEFT JOIN
    result r ON s.result_id = r.result_id;

CREATE VIEW unpaid
AS
SELECT student_id
FROM Student
WHERE semester_fee_id IS NULL;
--Unpaid procedure
CREATE PROCEDURE Unpaiddet
    @studentid VARCHAR(10)
AS
BEGIN
    DECLARE @lastpaid DATE;

    -- Directly assign the maximum payment date using a subquery
    SET @lastpaid = (
        SELECT MAX(Pdate)
        FROM Semester_fee
        WHERE semester_fee_id = (
            SELECT TOP 1 semester_fee_id
            FROM unpaid
            WHERE student_id = @studentid
            ORDER BY semester_fee_id DESC
        )
    );

    -- Check if the last payment was more than 6 months ago
    IF ISNULL(@lastpaid, GETDATE()) <= DATEADD(MONTH, -6, GETDATE())
    BEGIN
        PRINT 'Unpaid';
    END
    ELSE
    BEGIN
        PRINT 'Paid or No Payment Records';
    END
END;
--database views
CREATE VIEW vw_StudentResults
AS
SELECT
    s.student_id,
    s.name AS student_name,
    s.contact_no,
    s.birthday,
    d.degree_name,
    ISNULL(r.total, 0) AS result_total
FROM
    Student s
LEFT JOIN
    Degree d ON s.degree_id = d.degree_id
LEFT JOIN
    result r ON s.result_id = r.result_id;
CREATE VIEW vw_Unpaid_Semester_Fees
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
    sf.semester_fee_id IS NULL
    OR sf.Pdate <= DATEADD(MONTH, -6, GETDATE());

CREATE VIEW vw_Module_Semester_Info
AS
SELECT
    m.module_id,
    m.semester_name,
    m.module_leader,
    ISNULL(ms.semester_id, 0) AS semester_id
FROM
    Module m
LEFT JOIN
    module_semester ms ON m.module_id = ms.module_id;


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
    @name varchar(100),
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
            department_name = @department_name,
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
            degree_id=@degree_id,
            semester_id=@semester_id
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
USE nsbm_university;


CREATE VIEW datadictionary
AS
WITH vars AS (
    SELECT 
        DB_NAME() AS v_SchemaName,
        'NO' AS v_TablesOnly
),

baseTbl AS (
    SELECT 
        TABLE_CATALOG AS SchemaName,
        table_type,
        table_name,
        table_schema
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_CATALOG = (SELECT v_SchemaName FROM vars)
      AND (TABLE_TYPE = 'BASE TABLE' OR (SELECT v_TablesOnly FROM vars) = 'NO')
),

metadata AS (
    SELECT
        bt.SchemaName AS schema_nm,
        bt.table_name AS table_nm,
        CASE 
            WHEN bt.table_type = 'BASE TABLE' THEN 'TBL'
            WHEN bt.table_type = 'VIEW' THEN 'VW'
            ELSE 'UK'
        END AS obj_typ,
        RIGHT('000' + CAST(tut.ORDINAL_POSITION AS VARCHAR(3)), 3) AS ord_pos,
        tut.column_name AS column_nm,
        COALESCE(tut.data_type, 'unknown') + 
            CASE 
                WHEN tut.data_type IN ('varchar', 'nvarchar') THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
                WHEN tut.data_type IN ('char', 'nchar') THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
                WHEN tut.data_type = 'date' THEN '(' + CAST(tut.DATETIME_PRECISION AS VARCHAR(10)) + ')'
                WHEN tut.data_type = 'datetime' THEN '(' + CAST(tut.DATETIME_PRECISION AS VARCHAR(10)) + ')'
                WHEN tut.data_type IN ('bigint', 'int', 'smallint', 'tinyint') THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ')'
                WHEN tut.data_type = 'uniqueidentifier' THEN '(16)'
                WHEN tut.data_type = 'money' THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ')'
                WHEN tut.data_type = 'decimal' THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(tut.NUMERIC_SCALE AS VARCHAR(10)) + ')'
                WHEN tut.data_type = 'numeric' THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(tut.NUMERIC_SCALE AS VARCHAR(10)) + ')'
                WHEN tut.data_type = 'varbinary' THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
                WHEN tut.data_type = 'xml' THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
                WHEN tut.CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(tut.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
                WHEN tut.DATETIME_PRECISION IS NOT NULL THEN '(' + CAST(tut.DATETIME_PRECISION AS VARCHAR(10)) + ')'
                WHEN tut.NUMERIC_PRECISION IS NOT NULL AND tut.NUMERIC_SCALE IS NULL THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ')'
                WHEN tut.NUMERIC_PRECISION IS NOT NULL AND tut.NUMERIC_SCALE IS NOT NULL THEN '(' + CAST(tut.NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(tut.NUMERIC_SCALE AS VARCHAR(10)) + ')'
                ELSE ''
            END AS data_typ,
        CASE 
            WHEN tut.IS_NULLABLE = 'YES' THEN 'NULL'
            ELSE 'NOT NULL'
        END AS nullable
    FROM INFORMATION_SCHEMA.COLUMNS tut
    INNER JOIN baseTbl bt ON bt.SchemaName = tut.TABLE_CATALOG AND bt.table_name = tut.table_name
),

descr AS (
    SELECT 
        bt.SchemaName AS schema_nm,
        bt.table_name AS table_nm,
        tut.column_name AS column_nm,
        STRING_AGG(CAST(de.value AS VARCHAR(1024)), '.  ') WITHIN GROUP (ORDER BY de.value) AS description
    FROM INFORMATION_SCHEMA.COLUMNS tut
    INNER JOIN baseTbl bt ON bt.SchemaName = tut.TABLE_CATALOG AND bt.table_name = tut.table_name
    LEFT JOIN sys.extended_properties de 
        ON de.major_id = OBJECT_ID(bt.table_schema + '.' + bt.table_name) 
        AND de.minor_id = tut.ORDINAL_POSITION
        AND de.name = 'MS_Description'
    GROUP BY bt.SchemaName, bt.table_name, tut.column_name
),

metadata_keys AS (
    SELECT 
        schema_nm, 
        table_nm, 
        column_nm,
        STRING_AGG(key_typ, ',') WITHIN GROUP (ORDER BY key_typ) AS is_key 
    FROM (  
        SELECT 
            cons.TABLE_CATALOG AS schema_nm,
            cons.TABLE_NAME AS table_nm,
            kcu.COLUMN_NAME AS column_nm,
            CASE 
                WHEN cons.CONSTRAINT_TYPE = 'PRIMARY KEY' THEN 'PK'
                WHEN cons.CONSTRAINT_TYPE = 'UNIQUE' THEN 'UK'
                WHEN cons.CONSTRAINT_TYPE = 'FOREIGN KEY' THEN 'FK'
                ELSE 'X'
            END AS key_typ
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS cons 
        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu 
            ON cons.TABLE_CATALOG = kcu.TABLE_CATALOG  
            AND cons.TABLE_NAME = kcu.TABLE_NAME
            AND cons.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
        WHERE cons.TABLE_CATALOG = (SELECT v_SchemaName FROM vars)
          AND cons.table_name IN (SELECT DISTINCT table_name FROM baseTbl)
          AND cons.constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY', 'UNIQUE') 
        GROUP BY cons.TABLE_CATALOG, cons.TABLE_NAME, kcu.COLUMN_NAME, cons.CONSTRAINT_TYPE
    ) AS t
    GROUP BY schema_nm, table_nm, column_nm
)

SELECT 
    md.schema_nm,
    md.table_nm,
    md.obj_typ,
    md.ord_pos,
    COALESCE(mk.is_key, ' ') AS keys,
    md.column_nm,
    md.data_typ,
    md.nullable,
    de.[description]
FROM metadata md
LEFT JOIN descr de 
    ON de.schema_nm = md.schema_nm  
    AND de.table_nm = md.table_nm  
    AND de.column_nm = md.column_nm
LEFT JOIN metadata_keys mk 
    ON mk.schema_nm = md.schema_nm  
    AND mk.table_nm = md.table_nm  
    AND mk.column_nm = md.column_nm;


--data insertion

--student table
EXEC InsertStudent
    @student_id = 'S2110',
    @name = 'Samantha Perera',
    @contact_no = '0788888888',
    @birthdate = '2001/05/15',
    @nic = '19876543210987',
    @address = 'no 101 colombo rd';
EXEC InsertStudent
    @student_id = 'S2111',
    @name = 'John Doe',
    @contact_no = '0799999999',
    @birthdate = '2002/07/22',
    @nic = '19876543210988',
    @address = 'no 102 colombo rd';

EXEC InsertStudent
    @student_id = 'S2112',
    @name = 'Jane Smith',
    @contact_no = '0712345678',
    @birthdate = '2003/09/10',
    @nic = '19876543210989',
    @address = 'no 103 colombo rd';

EXEC InsertStudent
    @student_id = 'S2113',
    @name = 'Michael Brown',
    @contact_no = '0723456789',
    @birthdate = '2004/10/25',
    @nic = '19876543210990',
    @address = 'no 104 colombo rd';

EXEC InsertStudent
    @student_id = 'S2114',
    @name = 'Emily Davis',
    @contact_no = '0734567890',
    @birthdate = '2005/11/30',
    @nic = '19876543210991',
    @address = 'no 105 colombo rd';

EXEC InsertStudent
    @student_id = 'S2115',
    @name = 'Daniel Wilson',
    @contact_no = '0745678901',
    @birthdate = '2006/12/05',
    @nic = '19876543210992',
    @address = 'no 106 colombo rd';

EXEC InsertStudent
    @student_id = 'S2116',
    @name = 'Sophia Johnson',
    @contact_no = '0756789012',
    @birthdate = '2007/01/15',
    @nic = '19876543210993',
    @address = 'no 107 colombo rd';

EXEC InsertStudent
    @student_id = 'S2117',
    @name = 'Ethan Martinez',
    @contact_no = '0767890123',
    @birthdate = '2008/02/20',
    @nic = '19876543210994',
    @address = 'no 108 colombo rd';

EXEC InsertStudent
    @student_id = 'S2118',
    @name = 'Olivia Garcia',
    @contact_no = '0778901234',
    @birthdate = '2009/03/25',
    @nic = '19876543210995',
    @address = 'no 109 colombo rd';

EXEC InsertStudent
    @student_id = 'S2119',
    @name = 'James Anderson',
    @contact_no = '0789012345',
    @birthdate = '2010/04/30',
    @nic = '19876543210996',
    @address = 'no 110 colombo rd';

EXEC InsertStudent
    @student_id = 'S2120',
    @name = 'Ava Thomas',
    @contact_no = '0790123456',
    @birthdate = '2011/05/15',
    @nic = '19876543210997',
    @address = 'no 111 colombo rd';

EXEC InsertStudent
    @student_id = 'S2121',
    @name = 'William Lee',
    @contact_no = '0801234567',
    @birthdate = '2012/06/20',
    @nic = '19876543210998',
    @address = 'no 112 colombo rd';

--batch table

EXEC InsertBatch
    @batch_id = '20.2',
    @batch_year = '2020/03/04';

EXEC InsertBatch
    @batch_id = '20.3',
    @batch_year = '2020/04/05';

EXEC InsertBatch
    @batch_id = '20.4',
    @batch_year = '2020/05/06';

EXEC InsertBatch
    @batch_id = '20.5',
    @batch_year = '2020/06/07';

EXEC InsertBatch
    @batch_id = '20.6',
    @batch_year = '2020/07/08';

EXEC InsertBatch
    @batch_id = '20.7',
    @batch_year = '2020/08/09';

EXEC InsertBatch
    @batch_id = '20.8',
    @batch_year = '2020/09/10';

EXEC InsertBatch
    @batch_id = '20.9',
    @batch_year = '2020/10/11';

EXEC InsertBatch
    @batch_id = '20.10',
    @batch_year = '2020/11/12';

EXEC InsertBatch
    @batch_id = '20.11',
    @batch_year = '2020/12/13';

--department table
EXEC InsertDepartment
    @department_id = 'D1001',
    @department_name = 'Department of Mathematics and Statistics',
    @department_head = 'Lisa Fernando';

EXEC InsertDepartment
    @department_id = 'D1002',
    @department_name = 'Department of Physics',
    @department_head = 'Ravi Perera';

EXEC InsertDepartment
    @department_id = 'D1003',
    @department_name = 'Department of Chemistry',
    @department_head = 'Sonia Rajapaksha';

EXEC InsertDepartment
    @department_id = 'D1004',
    @department_name = 'Department of Biology',
    @department_head = 'Nimal Weerasinghe';

EXEC InsertDepartment
    @department_id = 'D1005',
    @department_name = 'Department of Engineering',
    @department_head = 'Amara Gunasekera';

EXEC InsertDepartment
    @department_id = 'D1006',
    @department_name = 'Department of Economics',
    @department_head = 'Kiran Kumar';

EXEC InsertDepartment
    @department_id = 'D1007',
    @department_name = 'Department of Business Administration',
    @department_head = 'Priya Nadarajah';

EXEC InsertDepartment
    @department_id = 'D1008',
    @department_name = 'Department of History',
    @department_head = 'Sanjay Kumar';

EXEC InsertDepartment
    @department_id = 'D1009',
    @department_name = 'Department of Political Science',
    @department_head = 'Ayesha Ameen';

EXEC InsertDepartment
    @department_id = 'D1010',
    @department_name = 'Department of Psychology',
    @department_head = 'Jayanthi Silva';

--department table
EXEC InsertEmployee
    @employee_id = 'E6001',
    @name = 'Liam Johnson',
    @contact_no = '0791234567',
    @birthday = '2022-07-15',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6002',
    @name = 'Emma Davis',
    @contact_no = '0702345678',
    @birthday = '2022-08-22',
    @employee_type = 'Non_academic';

EXEC InsertEmployee
    @employee_id = 'E6003',
    @name = 'Noah Smith',
    @contact_no = '0713456789',
    @birthday = '2022-09-30',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6004',
    @name = 'Olivia Brown',
    @contact_no = '0724567890',
    @birthday = '2022-10-12',
    @employee_type = 'Non_academic';

EXEC InsertEmployee
    @employee_id = 'E6005',
    @name = 'James Wilson',
    @contact_no = '0735678901',
    @birthday = '2022-11-20',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6006',
    @name = 'Sophia Martinez',
    @contact_no = '0746789012',
    @birthday = '2022-12-05',
    @employee_type = 'Non_academic';

EXEC InsertEmployee
    @employee_id = 'E6007',
    @name = 'Jackson Lee',
    @contact_no = '0757890123',
    @birthday = '2023-01-15',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6008',
    @name = 'Isabella Garcia',
    @contact_no = '0768901234',
    @birthday = '2023-02-20',
    @employee_type = 'Non_academic';

EXEC InsertEmployee
    @employee_id = 'E6009',
    @name = 'Aiden Thompson',
    @contact_no = '0779012345',
    @birthday = '2023-03-25',
    @employee_type = 'Academic';

EXEC InsertEmployee
    @employee_id = 'E6010',
    @name = 'Mia Robinson',
    @contact_no = '0780123456',
    @birthday = '2023-04-30',
    @employee_type = 'Non_academic';

--faculty table
EXEC InsertFaculty
    @faculty_id = 'F551',
    @faculty_name = 'Faculty of Engineering',
    @contact_no = '0602345678',
    @dean = 'Emily Carter';

EXEC InsertFaculty
    @faculty_id = 'F552',
    @faculty_name = 'Faculty of Business Administration',
    @contact_no = '0603456789',
    @dean = 'Michael Evans';

EXEC InsertFaculty
    @faculty_id = 'F553',
    @faculty_name = 'Faculty of Arts and Humanities',
    @contact_no = '0604567890',
    @dean = 'Sara Mitchell';

EXEC InsertFaculty
    @faculty_id = 'F554',
    @faculty_name = 'Faculty of Social Sciences',
    @contact_no = '0605678901',
    @dean = 'David Thompson';

EXEC InsertFaculty
    @faculty_id = 'F555',
    @faculty_name = 'Faculty of Health Sciences',
    @contact_no = '0606789012',
    @dean = 'Laura Smith';

EXEC InsertFaculty
    @faculty_id = 'F556',
    @faculty_name = 'Faculty of Education',
    @contact_no = '0607890123',
    @dean = 'John Anderson';

EXEC InsertFaculty
    @faculty_id = 'F557',
    @faculty_name = 'Faculty of Law',
    @contact_no = '0608901234',
    @dean = 'Rebecca Lewis';

EXEC InsertFaculty
    @faculty_id = 'F558',
    @faculty_name = 'Faculty of Science',
    @contact_no = '0609012345',
    @dean = 'Daniel White';

EXEC InsertFaculty
    @faculty_id = 'F559',
    @faculty_name = 'Faculty of Architecture',
    @contact_no = '0610123456',
    @dean = 'Sophia Clark';

EXEC InsertFaculty
    @faculty_id = 'F560',
    @faculty_name = 'Faculty of Agriculture',
    @contact_no = '0611234567',
    @dean = 'Oliver Brown';

--library table
EXEC InsertLibrary
    @library_id = '1AAB',
    @book_id = '1.AB',
    @issued_date = '2023/01/15',
    @return_date = '2023/02/15';

EXEC InsertLibrary
    @library_id = '1AAC',
    @book_id = '1.AC',
    @issued_date = '2023/02/01',
    @return_date = '2023/03/01';

EXEC InsertLibrary
    @library_id = '1AAD',
    @book_id = '1.AD',
    @issued_date = '2023/02/20',
    @return_date = '2023/03/20';

EXEC InsertLibrary
    @library_id = '1AAE',
    @book_id = '1.AE',
    @issued_date = '2023/03/01',
    @return_date = '2023/04/01';

EXEC InsertLibrary
    @library_id = '1AAF',
    @book_id = '1.AF',
    @issued_date = '2023/03/15',
    @return_date = '2023/04/15';

EXEC InsertLibrary
    @library_id = '1AAG',
    @book_id = '1.AG',
    @issued_date = '2023/04/01',
    @return_date = '2023/05/01';

EXEC InsertLibrary
    @library_id = '1AAH',
    @book_id = '1.AH',
    @issued_date = '2023/04/20',
    @return_date = '2023/05/20';

EXEC InsertLibrary
    @library_id = '1AAI',
    @book_id = '1.AI',
    @issued_date = '2023/05/01',
    @return_date = '2023/06/01';

EXEC InsertLibrary
    @library_id = '1AAJ',
    @book_id = '1.AJ',
    @issued_date = '2023/05/15',
    @return_date = '2023/06/15';

EXEC InsertLibrary
    @library_id = '1AAK',
    @book_id = '1.AK',
    @issued_date = '2023/06/01',
    @return_date = '2023/07/01';

--module table
EXEC InsertModule
    @module_id = 'M102',
    @module_leader = 'Emma Robinson';

EXEC InsertModule
    @module_id = 'M103',
    @module_leader = 'Aiden Lewis';

EXEC InsertModule
    @module_id = 'M104',
    @module_leader = 'Olivia Clark';

EXEC InsertModule
    @module_id = 'M105',
    @module_leader = 'Noah White';

EXEC InsertModule
    @module_id = 'M106',
    @module_leader = 'Sophia Wright';

EXEC InsertModule
    @module_id = 'M107',
    @module_leader = 'Liam Thompson';

EXEC InsertModule
    @module_id = 'M108',
    @module_leader = 'Isabella Martinez';

EXEC InsertModule
    @module_id = 'M109',
    @module_leader = 'James Anderson';

EXEC InsertModule
    @module_id = 'M110',
    @module_leader = 'Charlotte Garcia';

EXEC InsertModule
    @module_id = 'M111',
    @module_leader = 'Benjamin Lee';

--result table
EXEC InsertResult
    @result_id = 'R102',
    @total = 85;

EXEC InsertResult
    @result_id = 'R103',
    @total = 90;

EXEC InsertResult
    @result_id = 'R104',
    @total = 75;

EXEC InsertResult
    @result_id = 'R105',
    @total = 88;

EXEC InsertResult
    @result_id = 'R106',
    @total = 92;

EXEC InsertResult
    @result_id = 'R107',
    @total = 78;

EXEC InsertResult
    @result_id = 'R108',
    @total = 81;

EXEC InsertResult
    @result_id = 'R109',
    @total = 83;

EXEC InsertResult
    @result_id = 'R110',
    @total = 89;

EXEC InsertResult
    @result_id = 'R111',
    @total = 95;

--registration table
EXEC InsertRegistration
    @registration_id = 'RID2',
    @date = '2023/09/15',
    @registration_fee = 12000;

EXEC InsertRegistration
    @registration_id = 'RID3',
    @date = '2023/10/01',
    @registration_fee = 11000;

EXEC InsertRegistration
    @registration_id = 'RID4',
    @date = '2023/10/15',
    @registration_fee = 10500;

EXEC InsertRegistration
    @registration_id = 'RID5',
    @date = '2023/11/01',
    @registration_fee = 13000;

EXEC InsertRegistration
    @registration_id = 'RID6',
    @date = '2023/11/15',
    @registration_fee = 11500;

EXEC InsertRegistration
    @registration_id = 'RID7',
    @date = '2023/12/01',
    @registration_fee = 12500;

EXEC InsertRegistration
    @registration_id = 'RID8',
    @date = '2023/12/15',
    @registration_fee = 14000;

EXEC InsertRegistration
    @registration_id = 'RID9',
    @date = '2024/01/01',
    @registration_fee = 10000;

EXEC InsertRegistration
    @registration_id = 'RID10',
    @date = '2024/01/15',
    @registration_fee = 11000;

EXEC InsertRegistration
    @registration_id = 'RID11',
    @date = '2024/02/01',
    @registration_fee = 12000;

--degree table
EXEC InsertDegree
    @degree_id = 'DE2',
    @degree_name = 'Electrical Engineering',
    @offered_by = 'UGC';

EXEC InsertDegree
    @degree_id = 'DE3',
    @degree_name = 'Mechanical Engineering',
    @offered_by = 'VU';

EXEC InsertDegree
    @degree_id = 'DE4',
    @degree_name = 'Civil Engineering',
    @offered_by = 'plymouth';

EXEC InsertDegree
    @degree_id = 'DE5',
    @degree_name = 'Data Science',
    @offered_by = 'UGC';

EXEC InsertDegree
    @degree_id = 'DE6',
    @degree_name = 'Biotechnology',
    @offered_by = 'VU';

EXEC InsertDegree
    @degree_id = 'DE7',
    @degree_name = 'Environmental Science',
    @offered_by = 'plymouth';

EXEC InsertDegree
    @degree_id = 'DE8',
    @degree_name = 'Economics',
    @offered_by = 'UGC';

EXEC InsertDegree
    @degree_id = 'DE9',
    @degree_name = 'Psychology',
    @offered_by = 'VU';

EXEC InsertDegree
    @degree_id = 'DE10',
    @degree_name = 'Business Administration',
    @offered_by = 'plymouth';

EXEC InsertDegree
    @degree_id = 'DE11',
    @degree_name = 'Mathematics',
    @offered_by = 'UGC';

--lecture table
EXEC InsertLecture
    @lecture_id = 'LI101',
    @name = 'Sophia Anderson',
    @employee_id = 'E1001';

EXEC InsertLecture
    @lecture_id = 'LI102',
    @name = 'Liam Johnson',
    @employee_id = 'E1002';

EXEC InsertLecture
    @lecture_id = 'LI103',
    @name = 'Olivia Martinez',
    @employee_id = 'E1003';

EXEC InsertLecture
    @lecture_id = 'LI104',
    @name = 'Noah Brown',
    @employee_id = 'E1004';

EXEC InsertLecture
    @lecture_id = 'LI105',
    @name = 'Emma Davis',
    @employee_id = 'E1005';

EXEC InsertLecture
    @lecture_id = 'LI106',
    @name = 'Ethan Wilson',
    @employee_id = 'E1006';

EXEC InsertLecture
    @lecture_id = 'LI107',
    @name = 'Isabella Clark',
    @employee_id = 'E1007';

EXEC InsertLecture
    @lecture_id = 'LI108',
    @name = 'Jacob Lewis',
    @employee_id = 'E1008';

EXEC InsertLecture
    @lecture_id = 'LI109',
    @name = 'Ava Taylor',
    @employee_id = 'E1009';

EXEC InsertLecture
    @lecture_id = 'LI110',
    @name = 'Mia Harris',
    @employee_id = 'E1010';

--semester table
EXEC InsertSemester
    @semester_id = 'SE1',
    @start_date = '2023/01/02',
    @finish_date = '2023/01/08';

EXEC InsertSemester
    @semester_id = 'SE2',
    @start_date = '2024/02/10',
    @finish_date = '2024/02/14';

--employee faculty table
EXEC InsertEmployeeFaculty
    @faculty_id = 'F550',
    @employee_id = 'E6000';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F551',
    @employee_id = 'E6001';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F552',
    @employee_id = 'E6002';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F553',
    @employee_id = 'E6003';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F554',
    @employee_id = 'E6004';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F555',
    @employee_id = 'E6005';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F556',
    @employee_id = 'E6006';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F557',
    @employee_id = 'E6007';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F558',
    @employee_id = 'E6008';

EXEC InsertEmployeeFaculty
    @faculty_id = 'F559',
    @employee_id = 'E6009';
--lecture department table
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
    @department_id = 'D1007',
    @lecture_id = 'LI107';

EXEC InsertLectureDepartment
    @department_id = 'D1008',
    @lecture_id = 'LI108';

EXEC InsertLectureDepartment
    @department_id = 'D1009',
    @lecture_id = 'LI109';

EXEC InsertLectureDepartment
    @department_id = 'D1010',
    @lecture_id = 'LI110';
--module lecture table
EXEC InsertModule_Lecture
    @module_id = 'M101',
    @lecture_id = 'LI101';

EXEC InsertModule_Lecture
    @module_id = 'M102',
    @lecture_id = 'LI102';

EXEC InsertModule_Lecture
    @module_id = 'M103',
    @lecture_id = 'LI103';

EXEC InsertModule_Lecture
    @module_id = 'M104',
    @lecture_id = 'LI104';

EXEC InsertModule_Lecture
    @module_id = 'M105',
    @lecture_id = 'LI105';

EXEC InsertModule_Lecture
    @module_id = 'M106',
    @lecture_id = 'LI106';

EXEC InsertModule_Lecture
    @module_id = 'M107',
    @lecture_id = 'LI107';

EXEC InsertModule_Lecture
    @module_id = 'M108',
    @lecture_id = 'LI108';

EXEC InsertModule_Lecture
    @module_id = 'M109',
    @lecture_id = 'LI109';

EXEC InsertModule_Lecture
    @module_id = 'M110',
    @lecture_id = 'LI110';

--module semester table
EXEC InsertModule_Semester
    @module_id = 'M101',
    @semester_id = 'SE1';

EXEC InsertModule_Semester
    @module_id = 'M102',
    @semester_id = 'SE2';

EXEC InsertModule_Semester
    @module_id = 'M103',
    @semester_id = 'SE1';

EXEC InsertModule_Semester
    @module_id = 'M104',
    @semester_id = 'SE2';

EXEC InsertModule_Semester
    @module_id = 'M105',
    @semester_id = 'SE1';

EXEC InsertModule_Semester
    @module_id = 'M106',
    @semester_id = 'SE2';

EXEC InsertModule_Semester
    @module_id = 'M107',
    @semester_id = 'SE1';

EXEC InsertModule_Semester
    @module_id = 'M108',
    @semester_id = 'SE2';

EXEC InsertModule_Semester
    @module_id = 'M109',
    @semester_id = 'SE1';

EXEC InsertModule_Semester
    @module_id = 'M110',
    @semester_id = 'SE2';

--degree semester table
EXEC InsertDegree_Semester
    @degree_id = 'DE1',
    @semester_id = 'SE1';

EXEC InsertDegree_Semester
    @degree_id = 'DE2',
    @semester_id = 'SE2';

EXEC InsertDegree_Semester
    @degree_id = 'DE3',
    @semester_id = 'SE1';

EXEC InsertDegree_Semester
    @degree_id = 'DE4',
    @semester_id = 'SE2';

EXEC InsertDegree_Semester
    @degree_id = 'DE5',
    @semester_id = 'SE1';

EXEC InsertDegree_Semester
    @degree_id = 'DE6',
    @semester_id = 'SE2';

EXEC InsertDegree_Semester
    @degree_id = 'DE7',
    @semester_id = 'SE1';

EXEC InsertDegree_Semester
    @degree_id = 'DE8',
    @semester_id = 'SE2';

EXEC InsertDegree_Semester
    @degree_id = 'DE9',
    @semester_id = 'SE1';

EXEC InsertDegree_Semester
    @degree_id = 'DE10',
    @semester_id = 'SE2';

--guardian table
EXEC InsertGuardian
    @student_id = 'S2102',
    @guardian_name = 'Emma Walker',
    @contact_no = '0211111112';

EXEC InsertGuardian
    @student_id = 'S2103',
    @guardian_name = 'Noah Harris',
    @contact_no = '0211111113';

EXEC InsertGuardian
    @student_id = 'S2104',
    @guardian_name = 'Sophia Robinson',
    @contact_no = '0211111114';

EXEC InsertGuardian
    @student_id = 'S2105',
    @guardian_name = 'Liam Scott',
    @contact_no = '0211111115';

EXEC InsertGuardian
    @student_id = 'S2106',
    @guardian_name = 'Olivia Lewis',
    @contact_no = '0211111116';

EXEC InsertGuardian
    @student_id = 'S2107',
    @guardian_name = 'Aiden Clark',
    @contact_no = '0211111117';

EXEC InsertGuardian
    @student_id = 'S2108',
    @guardian_name = 'Isabella Martinez',
    @contact_no = '0211111118';

EXEC InsertGuardian
    @student_id = 'S2109',
    @guardian_name = 'Jacob Thompson',
    @contact_no = '0211111119';

EXEC InsertGuardian
    @student_id = 'S2110',
    @guardian_name = 'Mia Anderson',
    @contact_no = '0211111120';

EXEC InsertGuardian
    @student_id = 'S2111',
    @guardian_name = 'Benjamin Lee',
    @contact_no = '0211111121';

--code executions
SELECT * FROM datadictionary ORDER BY schema_nm, table_nm, ord_pos;

