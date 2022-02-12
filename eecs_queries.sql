-- These are some Database Manipulation queries for a partially implemented Project Website 
-- Your submission should contain ALL the queries required to implement ALL the
-- functionalities listed in the Project Specs.


-- ${var} denotes to variable (named as 'var') that will be replaced by the NodeJS code


-- get all students
SELECT * FROM eecs_students

-- query students with filter
select * from eecs_students where ${select} like '%${pattern}%'

-- delete a student
delete FROM eecs_students where id = ${id}

-- register a student
INSERT INTO eecs_students (first_name, last_name, gender, date_of_birth) VALUES ( '${first_name}', '${last_name}', '${gender}', '${date_of_birth}')

-- update a student
update eecs_students set first_name = '${first_name}', last_name = '${last_name}', gender = '${gender}', date_of_birth = '${date_of_birth}' where id = '${id}'



-- get all instructors
SELECT * FROM eecs_instructors

-- delete an instructor
delete FROM eecs_instructors where id = ${id}

-- register an instructor
INSERT INTO eecs_instructors (first_name, last_name, gender, date_of_birth) VALUES ( '${first_name}', '${last_name}', '${gender}', '${date_of_birth}')



-- get all classrooms
SELECT * FROM eecs_classrooms

-- delete a classroom
delete FROM eecs_classrooms where id = ${id}

-- create a classroom
INSERT INTO eecs_classrooms (building, capacity, floor, type) VALUES ( '${building}', '${capacity}', '${floor}', '${type}')



-- get all courses (left join with instructors and classrooms)
SELECT c.id, name, current_term_offered, c.capacity, i.first_name, i.last_name, cl.building classroom FROM eecs_courses c left join eecs_instructors i on i.id = c.instructor_id left join eecs_classrooms cl on cl.id = c.classroom_id

-- delete a course
delete FROM eecs_courses where id = ${id}

-- create a course
INSERT INTO eecs_courses (name, current_term_offered, capacity, instructor_id, classroom_id) VALUES ( '${name}', '${current_term_offered}', '${capacity}', ${instructor_id}, ${classroom_id})



-- get all enrollments (i.e. eecs_students_courses, left join with eecs_students and eecs_courses)
select sc.student_id, s.first_name, s.last_name, sc.course_id, c.name course_name from eecs_students_courses sc left join eecs_students s on s.id = sc.student_id left join eecs_courses c on c.id = sc.course_id

-- delete an enrollment (M:M relationship deletion)
delete FROM eecs_students_courses where ${student_cond} and ${course_cond}

-- create an enrollment (M:M relationship creation)
INSERT INTO eecs_students_courses (student_id, course_id) VALUES ( '${student_id}', '${course_id}')


