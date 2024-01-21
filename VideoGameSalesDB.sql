-- Creating the Database - VideoGamesSalesDB
CREATE DATABASE IF NOT EXISTS VideoGamesSalesDB;
USE VideoGamesSalesDB;

-- Creating the Genre Table
CREATE TABLE IF NOT EXISTS Genre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(255) NOT NULL UNIQUE
) DEFAULT CHARSET=utf8mb4;

-- Creating the Platform Table
CREATE TABLE IF NOT EXISTS Platform (
    PlatformID INT AUTO_INCREMENT PRIMARY KEY,
    PlatformName VARCHAR(255) NOT NULL UNIQUE
) DEFAULT CHARSET=utf8mb4;

-- Creating Publisher Table
CREATE TABLE IF NOT EXISTS Publisher (
    PublisherID INT AUTO_INCREMENT PRIMARY KEY,
    PublisherName VARCHAR(255) NOT NULL UNIQUE
) DEFAULT CHARSET=utf8mb4;

-- Creating the Games Table
CREATE TABLE IF NOT EXISTS Games (
    `Rank` INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    PlatformName VARCHAR(255),
    ReleaseDate YEAR,
    GenreName VARCHAR(255),
    PublisherName VARCHAR(255),
    NA_Sales DECIMAL(10, 2),
    EU_Sales DECIMAL(10, 2),
    JP_Sales DECIMAL(10, 2),
    Other_Sales DECIMAL(10, 2),
    Global_Sales DECIMAL(10, 2)
) DEFAULT CHARSET=utf8mb4;

-- Loading CSV data into the Games table appropriately
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\vgsales1.csv'
INTO TABLE Games
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    `Rank`, 
    Title,
    PlatformName,
    ReleaseDate,
    GenreName,
    PublisherName,
    NA_Sales,
    EU_Sales,
    JP_Sales,
    Other_Sales,
    Global_Sales
);

-- Altering Games Table to make use of foreign keys
ALTER TABLE Games
    ADD COLUMN GenreID INT,
    ADD COLUMN PlatformID INT,
    ADD COLUMN PublisherID INT;

-- Populating the Genre table from Games table
INSERT INTO Genre (GenreName)
SELECT DISTINCT GenreName FROM Games
WHERE GenreName IS NOT NULL;

-- Populating the Platform table from Games table
INSERT INTO Platform (PlatformName)
SELECT DISTINCT PlatformName FROM Games
WHERE PlatformName IS NOT NULL;

-- Populating the Publisher table from Games table
INSERT INTO Publisher (PublisherName)
SELECT DISTINCT PublisherName FROM Games
WHERE PublisherName IS NOT NULL;

-- Updating Games Table to be able to set foreign keys
UPDATE Games 
SET GenreID = (SELECT GenreID FROM Genre WHERE GenreName = Games.GenreName)
WHERE GenreID IS NULL;

UPDATE Games 
SET PlatformID = (SELECT PlatformID FROM Platform WHERE PlatformName = Games.PlatformName)
WHERE PlatformID IS NULL;

UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = Games.PublisherName)
WHERE PublisherID IS NULL;



-- Adding appropriate foreign key constraints
ALTER TABLE Games
    ADD CONSTRAINT FK_GenreID FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    ADD CONSTRAINT FK_PlatformID FOREIGN KEY (PlatformID) REFERENCES Platform(PlatformID),
    ADD CONSTRAINT FK_PublisherID FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID);

-- Dropping the redundant columns from the Games table
ALTER TABLE Games
    DROP COLUMN GenreName,
    DROP COLUMN PlatformName,
    DROP COLUMN PublisherName;

-- select queries to check data being imported in a proper manner
SELECT * FROM Games;
SELECT * FROM Genre;
SELECT * FROM Platform;
SELECT * FROM Publisher;
SELECT COUNT(*) FROM Genre;
SELECT COUNT(*) FROM Platform;
SELECT COUNT(*) FROM Games;
SELECT COUNT(*) FROM Publisher;
