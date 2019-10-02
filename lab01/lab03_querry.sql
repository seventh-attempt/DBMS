/*1. */select count(student_id) students_amount from [dbo].[Journal];
/*2. */select lesson_id, count(mark) marks from [dbo].[Journal] where date between dateadd(month, -1, getdate()) and getdate() group by lesson_id;
/*3. */with temp as (select student_id, count(mark) marks from [dbo].[Journal] group by student_id) select student_id, marks from temp group by student_id, marks having marks = (select max(marks) from temp);
/*4. */with temp as (select lesson_id, avg(mark) marks from [dbo].[Journal] group by lesson_id) select lesson_id, marks from temp group by lesson_id, marks having marks = (select min(marks) from temp);
/*5. */select student_id, count(mark) as marks_amount from [dbo].[Journal] group by student_id;
/*6. */select teacher_id, count(mark) marks_set from [dbo].[Journal] where date between dateadd(month, -1, getdate()) and getdate() group by teacher_id having (select count(mark)) > 1;
/*7. */select student_id, avg(mark) average_mark from [dbo].[Journal] group by student_id order by avg(mark) desc;

/*
1.	Подсчитать количество учеников.
2.	Подсчитать количество оценок, полученных по каждому предмету в прошлом месяце.
3.	Определить код ученика, имеющего  максимальное количество оценок.
4.	Определить код предмета, по которому средняя оценка минимальна.
5.	Определить среднее количество оценок у каждого ученика.
6.	Определить коды преподавателей, выставивших более 5 оценок на прошлой неделе.
7.	Вывести список кодов учеников, отсортированный по убыванию среднего балла.
*/