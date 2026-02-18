# school

## Tables

students
- Columns: student_id (PK), full_name, email, grade_level, birth_date

courses
- Columns: course_id (PK), course_name, department, level, credits, instructor

enrollments
- Columns: enrollment_id (PK), student_id (FK -> students.student_id), course_id (FK -> courses.course_id), enrolled_on, status, grade

## Relationships
- enrollments.student_id -> students.student_id
- enrollments.course_id -> courses.course_id
