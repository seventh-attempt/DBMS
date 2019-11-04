/*1. */
	--CREATE FUNCTION func_task1 (@stud_id INT) RETURNS INT
	--	DECLARE @temp TABLE (mark INT)
	--	INSERT INTO @temp SELECT mark FROM dbo.Journal GROUP BY student_id, date, mark HAVING student_id=@stud_id AND date BETWEEN DATEADD(MONTH, -3, GETDATE()) AND GETDATE()
	--	RETURN (SELECT COUNT(mark) marks FROM @temp)
	SELECT dbo.func_task1(7) AS marks;

/*2. */
	--CREATE FUNCTION func_task2 (@date date) RETURNS TABLE
	--	RETURN (SELECT student_id, lesson, mark FROM dbo.Journal JOIN dbo.Lessons ON lesson_id = dbo.Lessons.Id WHERE mark < 6 AND date = @date);
	SELECT * FROM dbo.func_task2('9/9/2019');

/*3. */
	--CREATE FUNCTION func_task3 () RETURNS TABLE
	--	RETURN SELECT student_id, lesson, second_name, mark AS teacher FROM dbo.Journal JOIN dbo.Lessons ON lesson_id = dbo.Lessons.Id JOIN dbo.Teachers ON teacher_id = dbo.Teachers.Id WHERE date BETWEEN DATEADD(MONTH, -2, GETDATE()) AND GETDATE();
	SELECT * FROM dbo.func_task3();

/*
1. Создать скалярную функцию для вычисления количества оценок, полученных в	прошлом
	месяце учеником, код которого вводится.
2. Создать табличную  функцию для вывода списка учеников, получивших оценки ниже 6
	в указанную дату с указанием названий предметов.
3. Создать многострочную табличную функцию для формирования всех учеников, 
	получивших оценки на прошлой неделе с указанием оценок, предметов и
	преподавателй.
*/
