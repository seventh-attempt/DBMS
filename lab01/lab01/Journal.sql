CREATE TABLE [dbo].[Journal]
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[date] DATE NOT NULL,
	[student_id] INT NOT NULL,
	[lesson_id] INT NOT NULL,
	[teacher_id] INT NOT NULL,
	[mark] SMALLINT NOT NULL,
	FOREIGN KEY (student_id) REFERENCES Students(Id),
	FOREIGN KEY (lesson_id) REFERENCES Lessons(Id),
	FOREIGN KEY (teacher_id) REFERENCES Teachers(Id)
)
