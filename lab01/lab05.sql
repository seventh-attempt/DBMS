/*I.  1.*/select distinct second_name, lesson from [dbo].[Teachers] left join [dbo].[Journal] on dbo.Teachers.Id = dbo.Journal.teacher_id left join [dbo].[Lessons] on dbo.Lessons.Id = dbo.Journal.lesson_id;
/*I.  2.*/select student_id, mark from [dbo].[Lessons] join [dbo].[Journal] on dbo.Lessons.Id = lesson_id where dbo.Lessons.lesson = 'PE' and date between dateadd(month, -1, getdate()) and getdate();
/*I.  3.*/select date, lesson_id, mark from [dbo].[Students] left join [dbo].[Journal] on dbo.Students.Id = student_id where dbo.Students.second_name = 'sn_student_5';
/*I.  4.*/select date, mark from [dbo].[Teachers] left join [dbo].[Journal] on dbo.Teachers.Id = teacher_id where dbo.Teachers.second_name = 'sn_teacher_9';

/*II. 1.*/select student_id from [dbo].[Journal] group by student_id having count(mark) > 1 intersect select student_id from [dbo].[Journal] where date between dateadd(month, -2, getdate()) and getdate();
/*II. 2.*/select student_id from [dbo].[Journal] where mark > 8 and date between dateadd(month, -2, getdate()) and getdate() union select student_id from [dbo].[Journal] where date between dateadd(month, -1, getdate()) and getdate();
/*II. 3.*/select second_name from [dbo].[Students] group by second_name having COUNT(second_name) > 1

/*
Используя операции соединения построить следующие запросы:
1.	Составить список преподавателей с указанием преподаваемых предметов.
2.	Составить список учеников и их оценок по математике за прошлую неделю.
3.	Составить список оценок с указанием дат и предметов, полученных учеником Ивановым.
4.	Составить список выставленных преподавателем Петровым оценок с указанием дат.

Используя операции UNION, EXCEPT, INTERSECT построить следующие запросы:
1.	Составить список учеников, которые получили более 3 оценок за прошедшую неделю.
2.	Составить список учеников, получивших более 8 баллов на прошлой неделе и вчера.
3.	Составить список учеников-однофамильцев.
*/