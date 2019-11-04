/*1. */
	--CREATE PROCEDURE proc_task1 (@subj_id INT) AS SELECT student_id FROM dbo.Journal WHERE lesson_id=@subj_id AND mark < 6 AND date BETWEEN DATEADD(MONTH, -2, GETDATE()) AND GETDATE();
	EXEC proc_task1 @subj_id=3;

/*2. */
	--CREATE PROCEDURE proc_task2 (@stud_id INT) AS SELECT lesson_id, mark FROM dbo.Journal GROUP BY lesson_id, student_id, mark, date HAVING student_id=@stud_id AND date BETWEEN DATEADD(MONTH, -2, GETDATE()) AND GETDATE();
	EXEC proc_task2 @stud_id=7;

/*3. */
	--CREATE PROCEDURE proc_task3 (@marks INT) AS SELECT lesson_id FROM dbo.Journal GROUP BY lesson_id, date HAVING COUNT(mark)=@marks AND date BETWEEN DATEADD(MONTH, -2, GETDATE()) AND GETDATE();
	EXEC proc_task3 @marks=2;

/*
1. Сформировать список учеников, получивших на прошлой неделе оценки ниже 6 по
	заданному предмету.
2. Сформировать список предметов и полученных по ним оценок за прошлую неделю
	заданным учеником.
3. Сформировать список, содержащий список предметов и количество выставленных по
	ним оценок за прошлую неделю. Общее количество оценок, выставленных за прошедшую
	неделю задать выходным параметром.
*/
