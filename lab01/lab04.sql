/*1. */select student_id, count(mark) as marks from [dbo].[Journal] group by student_id, lesson_id having (lesson_id!=(select id from [dbo].[Lessons] where lesson='Math')) order by student_id
/*2. */select lesson_id from [dbo].[Journal] group by lesson_id, teacher_id having (select id from [dbo].[Teachers] where second_name='sn_teacher_5')=teacher_id;
/*3. */select student_id from [dbo].[Journal] group by student_id, mark having (mark<6);
/*4. */with temp as (select student_id, count(mark) marks from [dbo].[Journal] group by student_id) select second_name from [dbo].[Students] group by second_name, id having id = (select student_id from temp group by student_id, marks having marks = (select max(marks) from temp));
/*5. */with temp as (select id from [dbo].[Lessons] where lesson in ('Math', 'Physics', 'Programming')) select second_name from [dbo].[Students] group by second_name, id having id in (select student_id from [dbo].[Journal] where lesson_id in (select id from temp));

/*
1.	Список учеников, не имеющих оценок по математике.
2.	Список предметов, которые преподает преподаватель Иванов.
3.	Список учеников, получивших оценки ниже 6 на прошлой неделе.
4.	Фамилию ученика, имеющего максимальное количество оценок.
5.	Фамилии и оценки учеников по предметам Математика, Физика, Информатика.
*/
