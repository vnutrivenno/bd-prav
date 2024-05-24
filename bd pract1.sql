USE master;
GO

IF DB_ID('rieltor_agency') IS NOT NULL
BEGIN
    ALTER DATABASE rieltor_agency SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE rieltor_agency;
END
GO

CREATE DATABASE rieltor_agency;
GO

USE rieltor_agency;
GO

IF OBJECT_ID('employee', 'U') IS NOT NULL
    DROP TABLE employee;
GO

CREATE TABLE employee (
    ID_employee INT PRIMARY KEY IDENTITY(1,1),
    Surname_P VARCHAR(100) NOT NULL,
    Name_P VARCHAR(100) NOT NULL,
    Secondname_P VARCHAR(100) NULL,
    number VARCHAR(100) UNIQUE NOT NULL
);
GO

INSERT INTO employee (Surname_P, Name_P, Secondname_P, number)
VALUES 
    ('Маслов', 'Евгений', 'Александрович', '7 989 283 12 23'),
    ('Фролова', 'Арина', 'Ильинична', '7 903 464 28 99'),
    ('Латышев', 'Константин', 'Максимович', '7 903 462 78 90'),
    ('Виноградов', 'Николай', 'Тимурович', '7 928 480 12 98'),
    ('Алексеев', 'Марк', 'Тимофеевич', '7 989 462 78 02');
GO

IF OBJECT_ID('Technical_support', 'U') IS NOT NULL
    DROP TABLE Technical_support;
GO

CREATE TABLE Technical_support (
    ID_Technical_support INT PRIMARY KEY IDENTITY(1,1),
    Surname_D VARCHAR(100) NOT NULL,
    Name_D VARCHAR(100) NOT NULL,
    Secondname_D VARCHAR(100) NULL
);
GO

INSERT INTO Technical_support (Surname_D, Name_D, Secondname_D)
VALUES
    ('Михайлов', 'Михаил', 'Артёмович'),
    ('Медведева', 'Кира', 'Владимировна'),
    ('Миронов', 'Максим', 'Александрович');
GO

IF OBJECT_ID('District', 'U') IS NOT NULL
    DROP TABLE District;
GO

CREATE TABLE District (
    ID_District INT PRIMARY KEY IDENTITY(1,1),
    District VARCHAR(100) NOT NULL
);
GO

INSERT INTO District (District)
VALUES
    ('Савино'),
    ('Бутово'),
    ('Кучино'),
    ('Купавна');
GO

IF OBJECT_ID('apartments', 'U') IS NOT NULL
    DROP TABLE apartments;
GO

CREATE TABLE apartments (
    ID_Apartment INT PRIMARY KEY IDENTITY(1,1),
    employee_ID INT,
    Technical_support_ID INT,
    Cost_services INT NULL,
    FOREIGN KEY (employee_ID) REFERENCES employee(ID_employee),
    FOREIGN KEY (Technical_support_ID) REFERENCES Technical_support(ID_Technical_support)
);
GO

INSERT INTO apartments (employee_ID, Technical_support_ID, Cost_services)
VALUES
    (1, 1, 60000),
    (2, 2, 450000),
    (3, 3, 40000),
    (4, 1, 41000),
    (5, 3, 63500);
GO

BEGIN TRANSACTION;
    DELETE FROM apartments WHERE employee_ID IN (SELECT ID_employee FROM employee WHERE Name_P = 'Арина');
    DELETE FROM employee WHERE Name_P = 'Арина';
COMMIT TRANSACTION;
GO

UPDATE Technical_support SET Name_D = 'Кира' WHERE ID_Technical_support = 2;
GO

UPDATE apartments SET Cost_services = 999999 WHERE Cost_services = 0;
GO

SELECT * FROM employee;
GO

SELECT Name_P FROM employee;
GO

SELECT * FROM employee WHERE Name_P = 'Евгений';
GO

SELECT apartments.Cost_services, employee.Name_P
FROM apartments
INNER JOIN employee ON apartments.employee_ID = employee.ID_employee;
GO

SELECT apartments.Cost_services, Technical_support.Surname_D
FROM apartments
LEFT JOIN Technical_support ON apartments.Technical_support_ID = Technical_support.ID_Technical_support;
GO

SELECT apartments.Cost_services, Technical_support.Surname_D
FROM apartments
RIGHT JOIN Technical_support ON apartments.Technical_support_ID = Technical_support.ID_Technical_support;
GO

SELECT apartments.Cost_services, Technical_support.Surname_D
FROM apartments
FULL JOIN Technical_support ON apartments.Technical_support_ID = Technical_support.ID_Technical_support;
GO

IF OBJECT_ID('View1', 'V') IS NOT NULL
    DROP VIEW View1;
GO

CREATE VIEW View1 AS
SELECT * FROM employee;
GO

IF OBJECT_ID('View2', 'V') IS NOT NULL
    DROP VIEW View2;
GO

CREATE VIEW View2 AS
SELECT * FROM Technical_support;
GO

IF OBJECT_ID('View3', 'V') IS NOT NULL
    DROP VIEW View3;
GO

CREATE VIEW View3 AS
SELECT * FROM apartments;
GO

IF OBJECT_ID('Procedure1', 'P') IS NOT NULL
    DROP PROCEDURE Procedure1;
GO

CREATE PROCEDURE Procedure1
AS
BEGIN
    SELECT * FROM employee;
END;
GO

IF OBJECT_ID('Procedure2', 'P') IS NOT NULL
    DROP PROCEDURE Procedure2;
GO

CREATE PROCEDURE Procedure2
AS
BEGIN
    SELECT * FROM Technical_support;
END;
GO

IF OBJECT_ID('Procedure3', 'P') IS NOT NULL
    DROP PROCEDURE Procedure3;
GO

CREATE PROCEDURE Procedure3
AS
BEGIN
    SELECT * FROM apartments;
END;
GO

IF OBJECT_ID('Function1', 'FN') IS NOT NULL
    DROP FUNCTION Function1;
GO

CREATE FUNCTION Function1()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM employee
);
GO

IF OBJECT_ID('Function2', 'FN') IS NOT NULL
    DROP FUNCTION Function2;
GO

CREATE FUNCTION Function2()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Technical_support
);
GO

IF OBJECT_ID('Function3', 'FN') IS NOT NULL
    DROP FUNCTION Function3;
GO

CREATE FUNCTION Function3()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM apartments
);
GO

IF OBJECT_ID('Trigger1', 'TR') IS NOT NULL
    DROP TRIGGER Trigger1;
GO

CREATE TRIGGER Trigger1
ON employee
FOR INSERT
AS
BEGIN
    PRINT 'Insert into employee table';
END;
GO

IF OBJECT_ID('Trigger2', 'TR') IS NOT NULL
    DROP TRIGGER Trigger2;
GO

CREATE TRIGGER Trigger2
ON Technical_support
FOR INSERT
AS
BEGIN
    PRINT 'Insert into Technical_support table';
END;
GO

IF OBJECT_ID('Trigger3', 'TR') IS NOT NULL
    DROP TRIGGER Trigger3;
GO

CREATE TRIGGER Trigger3
ON apartments
FOR INSERT
AS
BEGIN
    PRINT 'Insert into apartments table';
END;
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'User1')
    DROP LOGIN User1;
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'User2')
    DROP LOGIN User2;
GO

CREATE LOGIN User1 WITH PASSWORD = 'password';
CREATE LOGIN User2 WITH PASSWORD = 'password';			
GO

USE rieltor_agency;
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'User1')
    DROP USER User1;
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'User2')
    DROP USER User2;
GO

CREATE USER User1 FOR LOGIN User1;
CREATE USER User2 FOR LOGIN User2;
GO

ALTER ROLE db_datareader ADD MEMBER User1;
ALTER ROLE db_datareader ADD MEMBER User2;
ALTER ROLE db_datawriter ADD MEMBER User1;
GO

SELECT * FROM employee WHERE Name_P LIKE 'Ев%';
GO

SELECT * FROM Technical_support WHERE Surname_D LIKE '%ов';
GO

SELECT * FROM apartments WHERE Cost_services LIKE '4%';
GO
