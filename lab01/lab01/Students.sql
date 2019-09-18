CREATE TABLE [dbo].[Students]
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    [second_name] VARCHAR(50) NOT NULL, 
    [first_name] VARCHAR(50) NOT NULL, 
    [address] VARCHAR(50)
)
