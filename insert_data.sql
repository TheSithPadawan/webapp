-- create some students in the database
INSERT INTO student (ssn, residency, studentid, firstname, middlename, lastname, enrollment) VALUES (123, 'CA US', 'A123',
'FN123', 'MN123', 'LN123', true );
INSERT INTO student (ssn, residency, studentid, firstname, middlename, lastname, enrollment) VALUES (122, 'CA US', 'A122',
                                                                                                     'FN122', 'MN122', 'LN122', true );
INSERT INTO student (ssn, residency, studentid, firstname, middlename, lastname, enrollment) VALUES (125, 'CA US', 'A125',
                                                                                                     'FN125', 'MN125', 'LN125', true );
INSERT INTO student (ssn, residency, studentid, firstname, middlename, lastname, enrollment) VALUES (1234, 'CA US', 'A1234',
                                                                                                     'FN1234', 'MN1234', 'LN1234', true );
INSERT INTO student (ssn, residency, studentid, firstname, middlename, lastname, enrollment) VALUES (1236, 'CA US', 'A1236',
                                                                                                     'FN1236', 'MN1236', 'LN1236', true );
INSERT INTO student (ssn, residency, studentid, firstname, middlename, lastname, enrollment) VALUES (1325, 'CA US', 'A1325',
                                                                                                     'FN1325', NULL, 'LN1325', true );

-- create some department
INSERT INTO department(name) VALUES ('CSE');
INSERT INTO department(name) VALUES ('MATH');
INSERT INTO department(name) VALUES ('SE');
INSERT INTO department(name) VALUES ('ECE');
INSERT INTO department(name) VALUES ('HUMANITY');

-- create some faculty and link to department
INSERT INTO faculty (name, title) VALUES ('Alex Snoeren', 'Associate Professor');
INSERT INTO faculty_dept (faculty_name, dept_name) VALUES ('Alex Snoeren', 'CSE');
INSERT INTO faculty (name, title) VALUES ('Sanjoy Dasgupta', 'Professor');
INSERT INTO faculty_dept (faculty_name, dept_name) VALUES ('Sanjoy Dasgupta', 'CSE');
INSERT INTO faculty (name, title) VALUES ('Gary', 'Professor');
INSERT INTO faculty_dept (faculty_name, dept_name) VALUES ('Gary', 'CSE');
INSERT INTO faculty (name, title) VALUES ('John Doe', 'Associate Professor');
INSERT INTO faculty_dept (faculty_name, dept_name) VALUES ('John Doe', 'MATH');
INSERT INTO faculty (name, title) VALUES ('Jane Doe', 'Lecturer');
INSERT INTO faculty_dept (faculty_name, dept_name) VALUES ('Jane Doe', 'ECE');


-- create some undergrad
INSERT INTO undergrad(studentid, major, minor, college) VALUES ('A123', 'CSE', 'MATH', 'MUIR');
INSERT INTO undergrad(studentid, major, minor, college) VALUES ('A122', 'CSE', 'ARTS', 'WARREN');
INSERT INTO undergrad(studentid, major, minor, college) VALUES ('A125', 'CSE', 'MUSIC', 'SIXTH');
INSERT INTO undergrad(studentid, major, minor, college) VALUES ('A1234', 'CSE', 'ECE', 'MUIR');

-- create some ms
INSERT INTO ms(studentid, department) VALUES ('A1236', 'CSE');
INSERT INTO ms(studentid, department) VALUES ('A1325', 'CSE');
INSERT INTO ms_thesis_committee(studentid, faculty_name) VALUES ('A1236', 'Gary');
INSERT INTO ms_thesis_committee(studentid, faculty_name) VALUES ('A1325', 'Alex Snoeren');

-- create some phd

-- create some courses
INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE8', TRUE,
4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE8', 'Both');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE8', 'CSE');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE11', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE11', 'Both');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE11', 'CSE');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE120', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE120', 'Both');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE120', 'CSE');
INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE101', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE101', 'Both');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE101', 'CSE');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE202', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE202', 'Both');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE202', 'CSE');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE258', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE258', 'Letter');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE258', 'CSE');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE250A', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE250A', 'Letter');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE250A', 'CSE');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE132B', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE132B', 'Letter');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE132B', 'CSE');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('MATH101', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('MATH101', 'Letter');
INSERT INTO course_offered(courseid, dept_name) VALUES ('MATH101', 'MATH');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('ECE8', TRUE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('ECE8', 'Letter');
INSERT INTO course_offered(courseid, dept_name) VALUES ('ECE8', 'ECE');

INSERT INTO course(courseid, lab, units_min, units_max, consent) VALUES ('CSE291', FALSE,
                                                                         4, 4, FALSE );
INSERT INTO course_grading_option(courseid, option) VALUES ('CSE291', 'Both');
INSERT INTO course_offered(courseid, dept_name) VALUES ('CSE291', 'CSE');

-- create some class
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE8', 'Intro to Java', 'FA', 2018);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE11', 'Intro to Python', 'FA', 2018);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE120', 'Intro to OS', 'FA', 2018);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE101', 'Intro to Algo', 'FA', 2018);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE202', 'Intro to Algo2', 'FA', 2018);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE258', 'Web Mining', 'FA', 2018);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE250A', 'Learning Theory', 'FA', 2018);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE8', 'Intro to Java', 'WI', 2019);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE101', 'Intro to Algo', 'WI', 2019);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE11', 'Intro to Python', 'WI', 2019);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE250A', 'Learning Theory', 'WI', 2010);
INSERT INTO class (courseid, title, quarter, year) VALUES ('CSE291', 'AI Seminar', 'WI', 2019);

INSERT INTO faculty_taught(faculty_name, courseid, quarter, year) VALUES ('Alex Snoeren','CSE8',
'FA', 2018);
INSERT INTO faculty_taught(faculty_name, courseid, quarter, year) VALUES ('Alex Snoeren','CSE11',
                                                                          'FA', 2018);
INSERT INTO faculty_taught(faculty_name, courseid, quarter, year) VALUES ('Alex Snoeren','CSE120',
                                                                          'FA', 2018);
INSERT INTO faculty_taught(faculty_name, courseid, quarter, year) VALUES ('Gary','CSE101',
                                                                          'FA', 2018);
INSERT INTO faculty_taught(faculty_name, courseid, quarter, year) VALUES ('Sanjoy Dasgupta','CSE202',
                                                                          'FA', 2018);
INSERT INTO faculty_taught(faculty_name, courseid, quarter, year) VALUES ('Sanjoy Dasgupta','CSE258',
                                                                          'FA', 2018);
INSERT INTO faculty_taught(faculty_name, courseid, quarter, year) VALUES ('Sanjoy Dasgupta','CSE250A',
                                                                          'FA', 2018);
-- create some sections
-- section in the fall
INSERT INTO sections(sectionid, enrollment_limit) VALUES ('CSE8-FA-A00', 150);
INSERT INTO sections(sectionid, enrollment_limit) VALUES ('CSE11-FA-A00', 100);
INSERT INTO sections(sectionid, enrollment_limit) VALUES ('CSE120-FA-A00', 50);
INSERT INTO sections(sectionid, enrollment_limit) VALUES ('CSE120-FA-B00', 50);
INSERT INTO sections(sectionid, enrollment_limit) VALUES ('CSE101-FA-A00', 100);
INSERT INTO sections(sectionid, enrollment_limit) VALUES ('CSE202-FA-A00', 70);
INSERT INTO sections(sectionid, enrollment_limit) VALUES ('CSE202-FA-B00', 100);

INSERT INTO has_sections(courseid, sectionid, quarter, year) VALUES ('CSE8', 'CSE8-FA-A00', 'FA', 2018);
INSERT INTO has_sections(courseid, sectionid, quarter, year) VALUES ('CSE11', 'CSE11-FA-A00', 'FA', 2018);
INSERT INTO has_sections(courseid, sectionid, quarter, year) VALUES ('CSE120', 'CSE120-FA-A00', 'FA', 2018);
INSERT INTO has_sections(courseid, sectionid, quarter, year) VALUES ('CSE8', 'CSE120-FA-B00', 'FA', 2018);
INSERT INTO has_sections(courseid, sectionid, quarter, year) VALUES ('CSE101', 'CSE8-FA-A00', 'FA', 2018);
INSERT INTO has_sections(courseid, sectionid, quarter, year) VALUES ('CSE202', 'CSE202-FA-A00', 'FA', 2018);
INSERT INTO has_sections(courseid, sectionid, quarter, year) VALUES ('CSE202', 'CSE202-FA-B00', 'FA', 2018);

-- enroll some students

