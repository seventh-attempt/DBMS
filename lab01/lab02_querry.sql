select * from [dbo].[Journal]
select * from [dbo].[Journal] where teacher_id=1
select student_id, mark from [dbo].[Journal] where date='9/17/2019' and mark>=8
select student_id, mark, lesson_id from [dbo].[Journal] where mark<6 and lesson_id in (2, 3, 7)
select student_id, mark, date from [dbo].[Journal] where mark<5 and date between '9/11/2019' and '9/18/2019'
select * from [dbo].[Students] where address is NULL
select * from [dbo].[Students] where second_name like 'T%'


/*
1.	Вывести всю таблицу «Журнал».
2.	Вывести список предметов, которые преподает преподаватель с кодом, равным 1.
3.	Вывести список кодов учеников, которые вчера получили оценки не ниже 8.
4.	Вывести список кодов учеников, получивших оценки ниже 6 по предметам с кодами 2,3,7.
5.	Вывести список кодов учеников, получивших оценки ниже 5 на прошлой неделе.
6.	Вывести список учеников, адреса которых неизвестны.
7.	Вывести список учеников, фамилии которых начинаются на "Т".
*/