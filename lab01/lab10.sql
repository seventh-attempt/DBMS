/*1. */
	--CREATE TABLE AuditJournal (
	--	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	--	[old_id] INT,
	--	[new_id] INT,
	--	[old_date] DATE,
	--	[new_date] DATE,
	--	[new_student_id] INT,
	--	[old_student_id] INT,
	--	[new_lesson_id] INT,
	--	[old_lesson_id] INT,
	--	[old_teacher_id] INT,
	--	[new_teacher_id] INT,
	--	[old_mark] SMALLINT,
	--	[new_mark] SMALLINT,
	--);

	--CREATE TRIGGER modify_journal ON dbo.Journal AFTER INSERT, UPDATE, DELETE AS
	--	BEGIN
	--		DECLARE @old_id INT, @new_id INT
	--		DECLARE @old_date DATE, @new_date DATE
	--		DECLARE @old_student_id INT, @new_student_id INT
	--		DECLARE @old_lesson_id INT, @new_lesson_id INT
	--		DECLARE @old_teacher_id INT, @new_teacher_id INT
	--		DECLARE @old_mark INT, @new_mark INT

	--		SET @old_id = (SELECT Id FROM deleted)
	--		SET @old_date = (SELECT date FROM deleted)
	--		SET @old_student_id = (SELECT student_id FROM deleted)
	--		SET @old_lesson_id = (SELECT lesson_id FROM deleted)
	--		SET @old_teacher_id = (SELECT teacher_id FROM deleted)
	--		SET @old_mark = (SELECT mark FROM deleted)
	--		SET @new_id = (SELECT Id FROM inserted)
	--		SET @new_date = (SELECT date FROM inserted)
	--		SET @new_student_id = (SELECT student_id FROM inserted)
	--		SET @new_lesson_id = (SELECT lesson_id FROM inserted)
	--		SET @new_teacher_id = (SELECT teacher_id FROM inserted)
	--		SET @new_mark = (SELECT mark FROM inserted WHERE Id=@new_id)

	--		INSERT INTO dbo.AuditJournal
	--			(old_id, new_id, old_date, new_date, old_student_id, new_student_id, old_lesson_id, new_lesson_id, old_teacher_id, new_teacher_id, old_mark, new_mark)
	--			VALUES (@old_id, @new_id, @old_date, @new_date, @old_student_id, @new_student_id, @old_lesson_id, @new_lesson_id, @old_teacher_id, @new_teacher_id, @old_mark, @new_mark)
			
	--		select old_id, new_id, old_date, new_date, old_student_id, new_student_id, old_lesson_id, new_lesson_id, old_teacher_id, new_teacher_id, old_mark, new_mark from dbo.AuditJournal

	--	END

/*2. */
	--CREATE TRIGGER easy_lesson ON dbo.Journal AFTER INSERT AS
	--	BEGIN
	--		UPDATE dbo.Journal
	--			SET mark = 10
	--			WHERE lesson_id = 5 AND Id = (SELECT Id FROM inserted)
	--	END
	
	INSERT INTO dbo.Journal (date, student_id, lesson_id, teacher_id, mark) VALUES ('9/9/2019', 3, 5, 6, 3);

/*3. */
	--CREATE TRIGGER journal_integrity ON dbo.Journal AFTER INSERT, UPDATE AS
	--	BEGIN
	--		IF (SELECT student_id FROM inserted WHERE student_id IN (SELECT Id FROM dbo.Students)) IS NULL
	--			BEGIN
	--				ROLLBACK TRANSACTION
	--				PRINT 'Incorrect student id was provided'
	--			END
	--		ELSE PRINT 'String inserted/updated'
	--	END

	UPDATE dbo.Journal
		SET student_id = 71
		WHERE Id = 4044;

/*4. */
	--CREATE TRIGGER prevent_drop_triggers ON DATABASE FOR DROP_TRIGGER AS
	--	PRINT 'Can not delete trigger, you have to disable prevent_drop_triggers'
	--	ROLLBACK
	
	DROP TRIGGER dbo.easy_lesson;

/*
1. Триггер журнала аудита
2. Триггер для реализации бизнес-правил
3. Триггер для обеспечения целостности
4. Триггер для запрещения удаления триггеров
*/
