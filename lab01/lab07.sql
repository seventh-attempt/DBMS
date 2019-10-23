/*1. */
	--CREATE VIEW task1 AS SELECT student_id, lesson_id, COUNT(mark) marks FROM dbo.Journal GROUP BY student_id, lesson_id;
	SELECT lesson_id FROM task1 WHERE marks=(SELECT MAX(marks) FROM task1);
/*2. */
	--create view task2 AS SELECT lesson_id, COUNT(teacher_id) teachers FROM dbo.Journal GROUP BY lesson_id;
	SELECT lesson_id FROM task2 WHERE teachers=(SELECT MAX(teachers) FROM task2);
/*3. */
	--CREATE VIEW task3 AS SELECT teacher_id, AVG(mark) marks FROM dbo.Journal GROUP BY teacher_id;
	SELECT teacher_id FROM task3 WHERE marks=(SELECT MIN(marks) FROM task3);
/*4. */
	--CREATE VIEW task4 AS SELECT student_id, lesson_id, AVG(mark) marks FROM dbo.Journal GROUP BY student_id, lesson_id, date HAVING date BETWEEN DATEADD(MONTH, -2, GETDATE()) AND GETDATE();
	SELECT lesson_id, student_id, MAX(marks) max_mark FROM task4 GROUP BY lesson_id, student_id;

/*
1. Создать представление, содержащее полную информацию об успеваемости учеников.
	С помощью созданного представления определить предмет, по которому выставлено
	максимальное количество оценок.
2. Создать представление, содержащее полную информацию о предметах и ведущих эти
	предметы преподавателях. С помощью созданного представления определить предмет,
	который ведут максимальное число преподавателей.
3. Создать представление, содержащее информацию о среднем балле успеваемости у
	каждого преподавателя. С помощью созданного представления определить фамилию
	преподавателя, у которого самая низкая успеваемость.
4. Создать представление, содержащее информацию об учениках, получавших оценки в
	прошлом месяце. С помощью созданного представления определить лучшего ученика
	за прошлый месяц по каждому предмету.
*/
