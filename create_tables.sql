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
    advisor TEXT NOT NULL,
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

CREATE TABLE IF NOT EXISTS course_previous (
    courseID TEXT NOT NULL REFERENCES course(courseID),
    prev_name TEXT NOT NULL,
    PRIMARY KEY (courseId, prev_name)
);

CREATE TABLE IF NOT EXISTS class (
    courseID TEXT NOT NULL REFERENCES course(courseID),
    title TEXT NOT NULL,
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (courseID, quarter, year)
);

CREATE TABLE IF NOT EXISTS course_grading_option (
    courseID TEXT NOT NULL REFERENCES course(courseID) PRIMARY KEY,
    option TEXT NOT NULL,
    CHECK (option IN ('Letter', 'S/U', 'Both'))
);

CREATE TABLE IF NOT EXISTS sections (
    sectionID TEXT NOT NULL PRIMARY KEY,
    enrollment_limit INT NOT NULL
);

CREATE TABLE IF NOT EXISTS review_sessions (
    date_of DATE NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    building TEXT NOT NULL,
    room TEXT NOT NULL,
    PRIMARY KEY (date_of, time_start, time_end, building, room)
);

CREATE TABLE IF NOT EXISTS weekly_meetings (
    day TEXT NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    building TEXT NOT NULL,
    room TEXT NOT NULL,
    type_meeting TEXT NOT NULL,
    required_meeting BOOLEAN NOT NULL,
    PRIMARY KEY (day, time_start, time_end, building, room)
);

CREATE TABLE IF NOT EXISTS faculty (
    name TEXT NOT NULL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS textbooks (
    isbn INT NOT NULL PRIMARY KEY,
    author TEXT NOT NULL,
    is_required BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS degree (
    dept_name TEXT NOT NULL REFERENCES department(name),
    deg_type TEXT NOT NULL,
    total_units INT NOT NULL,
    PRIMARY KEY (dept_name, deg_type)
);

CREATE TABLE IF NOT EXISTS ms_concentration (
    concentration_type TEXT NOT NULL PRIMARY KEY,
    units INT NOT NULL,
    min_gpa DECIMAL NOT NULL
);

CREATE TABLE IF NOT EXISTS degree_categories (
    category_type TEXT NOT NULL PRIMARY KEY,
    units INT NOT NULL,
    min_gpa DECIMAL NOT NULL
);

-- relationship sets
CREATE TABLE IF NOT EXISTS ms_thesis_committee (
    studentID TEXT NOT NULL REFERENCES student(studentID) PRIMARY KEY,
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    PRIMARY KEY (studentID, faculty_name)
);

CREATE TABLE IF NOT EXISTS phd_thesis_committee_dept (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
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
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (studentID, quarter, year)
);

CREATE TABLE IF NOT EXISTS probates (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    reason TEXT NOT NULL,
    PRIMARY KEY (studentID, quarter, year)
);

CREATE TABLE IF NOT EXISTS has_taken (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    grade TEXT NOT NULL,
    PRIMARY KEY (studentID, courseID)
);

CREATE TABLE IF NOT EXISTS is_taking (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (studentID, courseID)
);

CREATE TABLE IF NOT EXISTS course_offered (
    courseID TEXT NOT NULL PRIMARY KEY REFERENCES course(courseID),
    dept_name TEXT NOT NULL REFERENCES department(name)
);

CREATE TABLE IF NOT EXISTS has_sections (
    courseID TEXT NOT NULL REFERENCES course(courseID),
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (courseId, sectionID, quarter, year)
);

CREATE TABLE IF NOT EXISTS students_enrolled (
    studentID TEXT NOT NULL REFERENCES student(studentID),
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    grading_option TEXT NOT NULL,
    units INT NOT NULL, -- TODO:
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

CREATE TABLE IF NOT EXISTS has_review_section (
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    date_of DATE NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    building TEXT NOT NULL,
    room TEXT NOT NULL,
    PRIMARY KEY (sectionID, date_of, time_start, time_end, building, room)
);

CREATE TABLE IF NOT EXISTS has_textbook (
    sectionID TEXT NOT NULL PRIMARY KEY REFERENCES sections(sectionID),
    isbn INT NOT NULL REFERENCES textbooks(isbn)
);

CREATE TABLE IF NOT EXISTS has_weekly_meetings (
    sectionID TEXT NOT NULL REFERENCES sections(sectionID),
    day TEXT NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    building TEXT NOT NULL,
    room TEXT NOT NULL,
    FOREIGN KEY (day, time_start, time_end, building, room) REFERENCES weekly_meetings(day, time_start, time_end, building, room),
    PRIMARY KEY (sectionID, day, time_start, time_end, building, room)
);

CREATE TABLE IF NOT EXISTS faculty_dept (
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    dept_name TEXT NOT NULL REFERENCES department(name),
    PRIMARY KEY (faculty_name, dept_name)
);

CREATE TABLE IF NOT EXISTS faculty_teaching (
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (faculty_name, courseId, quarter, year)
);

CREATE TABLE IF NOT EXISTS faculty_taught (
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (faculty_name, courseId, quarter, year)
);

CREATE TABLE IF NOT EXISTS faculty_will_teach (
    faculty_name TEXT NOT NULL REFERENCES faculty(name),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    quarter TEXT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (faculty_name, courseId, quarter, year)
);

CREATE TABLE IF NOT EXISTS prereqs (
    current_courseID TEXT NOT NULL REFERENCES course(courseID),
    prev_courseID TEXT NOT NULL REFERENCES course(courseID),
    PRIMARY KEY (current_courseID, prev_courseID)
);

CREATE TABLE IF NOT EXISTS degree_has_categories (
    dept_name TEXT NOT NULL,
    deg_type TEXT NOT NULL,
    category_type TEXT NOT NULL REFERENCES degree_categories(category_type),
    FOREIGN KEY (dept_name, deg_type) REFERENCES degree(dept_name, deg_type),
    PRIMARY KEY (dept_name, deg_type, category_type)
);

CREATE TABLE IF NOT EXISTS degree_has_concentration (
    dept_name TEXT NOT NULL,
    deg_type TEXT NOT NULL,
    category_type TEXT NOT NULL REFERENCES ms_concentration(concentration_type),
    FOREIGN KEY (dept_name, deg_type) REFERENCES degree(dept_name, deg_type),
    PRIMARY KEY (dept_name, deg_type, category_type)
);

CREATE TABLE IF NOT EXISTS concentration_has_courses (
    concentration_type TEXT NOT NULL REFERENCES ms_concentration(concentration_type),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    PRIMARY KEY (concentration_type, courseID)
);

CREATE TABLE IF NOT EXISTS category_has_courses (
    category_type TEXT NOT NULL REFERENCES ms_concentration(concentration_type),
    courseID TEXT NOT NULL REFERENCES course(courseID),
    PRIMARY KEY (category_type, courseID)
);