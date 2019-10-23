/*1. */
--create table dbo.Archive (
--	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
--	[date] DATE NOT NULL,
--	[student_id] INT NOT NULL,
--	[lesson_id] INT NOT NULL,
--	[teacher_id] INT NOT NULL,
--	[mark] SMALLINT NOT NULL,
--	FOREIGN KEY (student_id) REFERENCES Students(Id),
--	FOREIGN KEY (lesson_id) REFERENCES Lessons(Id),
--	FOREIGN KEY (teacher_id) REFERENCES Teachers(Id)
--);
--insert into dbo.Archive (date, student_id, lesson_id, teacher_id, mark) select date, student_id, lesson_id, teacher_id, mark from dbo.Journal where date between dateadd(year, -1, getdate()) and getdate();;
select * from dbo.Archive;
/*2. */
--alter table dbo.Teachers add category int;
--update dbo.Teachers
--	set category = case
--		when Id % 2 = 1 then 2
--		when Id % 2 = 0 then 1
--	end;
select * from dbo.Teachers;
/*3. */--create index i1 on dbo.Students (second_name, address);
/*4. */--delete from dbo.Journal where date  < dateadd(year, -1, getdate());
/*5. */--delete from dbo.Students where Id in (select Id from dbo.Students except select student_id from dbo.Journal);

/*
1.	Создать таблицу «Архив» и с помощью запроса внести в нее данные из Журнала  за все годы, предшествующие текущему.  Вывести созданную таблицу.  
2.	В таблицу «Преподаватели»  добавить поле «Категория»  и с помощью запроса внести в это поле число 1 для преподавателей с четным кодом преподавателя и число 2 для преподавателей с нечетным кодом преподавателя. Вывести таблицу «Преподаватели».
3.	Проиндексировать таблицу «Ученики» по полям «Фамилия» и «Адрес».
4.	Удалить из таблицы «Журнал» данные  за все годы, предшествующие текущему. 
5.	Удалить из таблицы «Ученики» данные об учениках, не имеющих оценок в этом году.
*/