SELECT Courses.CourseName,CourseRegistrations_passed.Grade FROM Degrees, StudentRegistrationsToDegrees,CourseRegistrations_passed,CourseOffers,Courses WHERE StudentRegistrationsToDegrees.StudentID = %1% AND Degrees.DegreeId = %2% AND StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId AND CourseRegistrations_passed.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId AND CourseRegistrations_passed.CourseOfferId = CourseOffers.CourseOfferId AND Courses.CourseId = CourseOffers.CourseId ORDER BY CourseOffers.year, CourseOffers.quartile,CourseRegistrations_passed.CourseOfferId;
SELECT DISTINCT studentid FROM GPA,non_fail_stu,studentregistrationstodegrees AS sr_to_deg WHERE GPA.GPA_score > %1% AND GPA.srid = non_fail_stu.studentregistrationid AND GPA.srid = sr_to_deg.studentregistrationid ORDER BY studentid;
SELECT sr_to_deg.degreeid AS degreeid, CAST(1.0*COUNT(case when active.gender='F' then 1 end)/COUNT(*) AS FLOAT) AS percentage FROM studentregistrationstodegrees as sr_to_deg, active WHERE active.studentid=sr_to_deg.studentid GROUP BY sr_to_deg.degreeid ORDER BY sr_to_deg.degreeid;
SELECT CAST((SELECT COUNT(*) FROM students, degrees, studentregistrationstodegrees WHERE students.gender = 'F' AND degrees.dept = %1% AND studentregistrationstodegrees.DegreeId = degrees.DegreeId AND studentregistrationstodegrees.StudentId = students.StudentId) AS FLOAT) / CAST((SELECT COUNT(*) FROM students, degrees, studentregistrationstodegrees WHERE degrees.dept = %1% AND studentregistrationstodegrees.DegreeId = degrees.DegreeId AND studentregistrationstodegrees.StudentId = students.StudentId) AS FLOAT);
SELECT crid_pass_total.courseid as courseid,(CAST((SELECT crid_pass_total.pass) AS REAL)/CAST((SELECT crid_pass_total.total) AS REAL)) AS percentagePassing FROM (SELECT CourseOffers.CourseId as courseid, count(cr.grade) filter (where cr.grade >= %1%) as pass,count(cr.grade) as total FROM (SELECT * FROM courseregistrations_4 UNION ALL SELECT * FROM courseregistrations_passed) AS cr,courseoffers WHERE cr.CourseOfferId = CourseOffers.CourseOfferId GROUP BY CourseOffers.CourseId) AS crid_pass_total ORDER BY crid_pass_total.courseid;
SELECT * FROM (SELECT good_student.sid, count(good_student.good_grades) as good_times FROM good_student GROUP BY good_student.sid) AS result WHERE result.good_times >=%1% ORDER BY sid;
SELECT StudentRegistrationsToDegrees.DegreeId,active.BirthyearStudent,active.gender, avg(GPA.gpa_score) AS avgGrade FROM StudentRegistrationsToDegrees, active, GPA WHERE StudentRegistrationsToDegrees.studentregistrationid = GPA.srid AND StudentRegistrationsToDegrees.studentid = active.studentid GROUP BY CUBE (StudentRegistrationsToDegrees.DegreeId,active.BirthyearStudent,active.gender) ORDER BY StudentRegistrationsToDegrees.DegreeId,active.BirthyearStudent,active.gender;
SELECT courseName, year, quartile FROM courses as c, courseoffers as co, (SELECT * FROM courses_with_no_assistants UNION ALL SELECT s.courseOfferId FROM students_per_courseoffer as s, assistants_per_courseoffer as a WHERE s.courseofferid = a.courseofferid AND s.students/a.assistants > 50) AS target WHERE target.courseofferid = co.courseofferid AND c.courseid = co.courseid ORDER BY co.courseofferid;