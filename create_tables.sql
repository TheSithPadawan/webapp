DO $$ BEGIN
    CREATE TYPE quarter_enum AS ENUM ('SP', 'SU1', 'SU2', 'FA', 'WI');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE meeting_enum AS ENUM ('LE', 'DI', 'LA');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE day_enum AS ENUM ('M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS student (
    ssn INT NOT NULL PRIMARY KEY,
    residency TEXT NOT NULL,
    studentID TEXT UNIQUE NOT NULL,
    firstName TEXT NOT NULL,
    middleName TEXT,
    lastName TEXT NOT NULL,
    enrollment BOOLEAN NOT NULL,
    CHECK (residency IN ('CA US', 'Non-CA US', 'Foreign'))
);

CREATE TABLE IF NOT EXISTS faculty (
    name TEXT NOT NULL PRIMARY KEY,
    title TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS department (
    name TEXT NOT NULL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS undergrad (
    studentID TEXT REFERENCES student(studentID) PRIMARY KEY,
    major TEXT NOT NULL,
    minor TEXT NOT NULL,
    college TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ms (
    studentID TEXT REFERENCES student(studentID) NOT NULL PRIMARY KEY,
    department TEXT REFERENCES department(name) NOT NULL
);

CREATE TABLE IF NOT EXISTS phd (
    studentID TEXT REFERENCES student(studentID) NOT NULL PRIMARY KEY,
    department TEXT REFERENCES department(name) NOT NULL,
    advisor TEXT NOT NULL REFERENCES faculty(name),
    type TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS bsms (
    studentID TEXT REFERENCES student(studentID) NOT NULL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS course (
    courseID TEXT NOT NULL PRIMARY KEY,
    lab BOOLEAN NOT NULL,
    units_min INT NOT NULL,
    units_max INT NOT NULL,
    consent BOOLEAN NOT NULL,
    CHECK (units_min <= units_max)
);

CREATE TABLE IF NOT EXISTS previous_courseID (
    courseID TEXT NOT NULL REFERENCES course(courseID),
    prev_id TEXT NOT NULL,
    PRIMARY KEY (courseId, prev_id)
);

CREATE TABLE IF NOT EXISTS class (
    courseID TEXT NOT NULL REFERENCES course(courseID),
    title TEXT NOT NULL,
    quarter quarter_enum NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (courseID, quarter, year)
);

CREATE TABLE IF NOT EXISTS course_grading_option (
    courseID TEXT NOT NULL REFERENCES course(courseID),
    option TEXT NOT NULL,
    CHECK (option IN ('Letter', 'S/U', 'Both')),
    PRIMARY KEY (courseID, option)
);

CREATE TABLE IF NOT EXISTS sections (
    sectionID TEXT NOT NULL PRIMARY KEY,
    enrollment_limit INT NOT NULL
);


CREATE TABLE IF NOT EXISTS textbook (
    isbn BIGINT NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS degree (
    dept_name TEXT NOT NULL REFERENCES department(name),
    deg_type TEXT NOT NULL,
    total_units INT NOT NULL,
    PRIMARY KEY (dept_name, deg_type)
);

-- relationship sets
CREATE TABLE IF NOT EXISTS ms_thesis_committee (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    PRIMARY KEY (studentID, faculty_name)
);

CREATE TABLE IF NOT EXISTS phd_thesis_committee_dept (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    department TEXT NOT NULL REFERENCES department(name),
    PRIMARY KEY (studentID, faculty_name)
);

CREATE TABLE IF NOT EXISTS student_previous_degree (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    prev_dept TEXT NOT NULL,
    prev_type TEXT NOT NULL,
    FOREIGN KEY (prev_dept, prev_type) REFERENCES degree(dept_name, deg_type),
    PRIMARY KEY (studentID, prev_dept, prev_type)
);

CREATE TABLE IF NOT EXISTS attends (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    quarter quarter_enum NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (studentID, quarter, year)
);

CREATE TABLE IF NOT EXISTS probation (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    quarter quarter_enum NOT NULL,
    year INT NOT NULL,
    reason TEXT NOT NULL,
    PRIMARY KEY (studentID, quarter, year)
);

CREATE TABLE IF NOT EXISTS has_taken (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    quarter quarter_enum NOT NULL,
    year INT NOT NULL,
    grade TEXT NOT NULL,
    units INT NOT NULL,
    PRIMARY KEY (studentID, courseID, sectionID)
);

CREATE TABLE IF NOT EXISTS is_taking (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    quarter quarter_enum NOT NULL,
    year INT NOT NULL,
    units INT NOT NULL,
    PRIMARY KEY (studentID, courseID)
);

CREATE TABLE IF NOT EXISTS course_offered (
    courseID TEXT NOT NULL PRIMARY KEY REFERENCES course(courseID),
    dept_name TEXT NOT NULL REFERENCES department(name)
);

CREATE TABLE IF NOT EXISTS has_sections (
    courseID TEXT NOT NULL REFERENCES course(courseID),
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    quarter quarter_enum NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (courseId, sectionID, quarter, year)
);

CREATE TABLE IF NOT EXISTS students_enrolled (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    grading_option TEXT NOT NULL,
    units INT NOT NULL,
    quarter quarter_enum NOT NULL,
    year int,
    PRIMARY KEY (sectionID, studentID),
    CHECK (grading_option IN ('Letter', 'S/U'))
);

CREATE TABLE IF NOT EXISTS students_waitlisted (
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    studentID TEXT NOT NULL REFERENCES student(studentID),
    PRIMARY KEY (sectionID, studentID)
);

CREATE TABLE IF NOT EXISTS taught_by (
    sectionID TEXT NOT NULL PRIMARY KEY REFERENCES sections(sectionID),
    faculty_name TEXT NOT NULL REFERENCES faculty(name)
);

CREATE TABLE IF NOT EXISTS review_session (
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    date_of DATE NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    building TEXT NOT NULL,
    room TEXT NOT NULL,
    PRIMARY KEY (sectionID, date_of, time_start, time_end, building, room)
);

CREATE TABLE IF NOT EXISTS has_textbook (
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    isbn BIGINT NOT NULL REFERENCES textbook(isbn),
    is_required BOOLEAN NOT NULL,
    PRIMARY KEY (sectionID, isbn)
);

CREATE TABLE IF NOT EXISTS has_weekly_meetings (
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    day day_enum NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    building TEXT NOT NULL,
    room TEXT NOT NULL,
    type_meeting meeting_enum NOT NULL,
    required BOOLEAN NOT NULL,
    PRIMARY KEY (sectionID, day, time_start, time_end)
);

CREATE TABLE IF NOT EXISTS faculty_dept (
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    dept_name TEXT NOT NULL REFERENCES department(name),
    PRIMARY KEY (faculty_name, dept_name)
);

CREATE TABLE IF NOT EXISTS faculty_taught (
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    quarter quarter_enum NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (faculty_name, courseId, quarter, year)
);

CREATE TABLE IF NOT EXISTS faculty_will_teach (
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    quarter quarter_enum NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (faculty_name, courseId, quarter, year)
);

CREATE TABLE IF NOT EXISTS prereqs (
    current_courseID TEXT NOT NULL REFERENCES course(courseID),
    prev_courseID TEXT NOT NULL REFERENCES course(courseID),
    PRIMARY KEY (current_courseID, prev_courseID)
);

CREATE TABLE IF NOT EXISTS degree_has_categories (
    dept_name TEXT NOT NULL REFERENCES department(name),
    deg_type TEXT NOT NULL,
    category_type TEXT NOT NULL,
    units int NOT NULL,
    min_gpa float,
    FOREIGN KEY (dept_name, deg_type) REFERENCES degree(dept_name, deg_type),
    PRIMARY KEY (dept_name, category_type)
);

CREATE TABLE IF NOT EXISTS category_has_courses (
    department TEXT NOT NULL REFERENCES department(name),
    category_type TEXT NOT NULL,
    courseID TEXT NOT NULL REFERENCES course(courseID),
    PRIMARY KEY (category_type, courseID),
    FOREIGN KEY (department, category_type) REFERENCES degree_has_categories(dept_name, category_type)
);

CREATE TABLE grade_conversion (
    letter_grade CHAR(2) NOT NULL,
    number_grade DECIMAL(2,1)
);

INSERT INTO grade_conversion values('A+', 4.3);
INSERT INTO grade_conversion values('A', 4);
INSERT INTO grade_conversion values('A-', 3.7);
INSERT INTO grade_conversion values('B+', 3.4);
INSERT INTO grade_conversion values('B', 3.1);
INSERT INTO grade_conversion values('B-', 2.8);
INSERT INTO grade_conversion values('C+', 2.5);
INSERT INTO grade_conversion values('C', 2.2);
INSERT INTO grade_conversion values('C-', 1.9);
INSERT INTO grade_conversion values('D', 1.6);

-- part 5 materialized view
CREATE TABLE grade_aggregate AS
    SELECT has_taken.courseid, taught_by.faculty_name, has_taken.quarter, has_taken.year,
        COUNT(*) FILTER (WHERE grade = ANY ('{A+,A,A-}')) AS A,
        COUNT(*) FILTER (WHERE grade = ANY ('{B+,B,B-}')) AS B,
        COUNT(*) FILTER (WHERE grade = ANY ('{C+,C,C-}')) AS C,
        COUNT(*) FILTER (WHERE grade = 'D') AS D,
        COUNT(*) FILTER (WHERE NOT grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D}')) AS other
    FROM has_taken INNER JOIN taught_by on has_taken.sectionid = taught_by.sectionid
    GROUP BY has_taken.courseid, taught_by.faculty_name, has_taken.quarter, has_taken.year;

CREATE MATERIALIZED VIEW CPG AS
    SELECT has_taken.courseID, taught_by.faculty_name,
        COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{A+,A,A-}')) AS A,
        COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{B+,B,B-}')) AS B,
        COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{C+,C,C-}')) AS C,
        COUNT(*) FILTER (WHERE has_taken.grade = 'D') AS D,
        COUNT(*) FILTER (WHERE NOT has_taken.grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D}')) AS other
    FROM faculty_taught
    JOIN has_taken
        ON faculty_taught.courseID = has_taken.courseID AND faculty_taught.quarter = has_taken.quarter AND faculty_taught.year = has_taken.year
    JOIN taught_by
        ON has_taken.sectionID = taught_by.sectionID AND taught_by.faculty_name = faculty_taught.faculty_name
    GROUP BY has_taken.courseID, taught_by.faculty_name;
