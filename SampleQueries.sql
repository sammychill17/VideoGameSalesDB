USE VideoGamesSalesDB;
-- Query 1
-- Select games released after 2010 with a derived attribute showing total sales in millions
SELECT `Rank`, Title, ReleaseDate, NA_Sales, EU_Sales, JP_Sales, Other_Sales, (NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS TotalSalesMillions
FROM Games
WHERE ReleaseDate > 2010;

-- Query 2
-- Inner join between Games and Publisher tables
-- Query 2
-- Inner join between Games and Publisher tables using PublisherID
SELECT G.`Rank`, G.Title, G.ReleaseDate, P.PublisherName
FROM Games G
INNER JOIN Publisher P USING (PublisherID);

-- Query 3
-- Grouping games by GenreID and calculating average global sales
SELECT GenreID, AVG(Global_Sales) AS AvgGlobalSales
FROM Games G
GROUP BY GenreID;

-- Query 4
-- Selecting games with above-average global sales
SELECT G.`Rank`, G.Title, G.Global_Sales
FROM Games G
INNER JOIN (SELECT AVG(Global_Sales) AS AvgGlobalSales FROM Games) AS A
ON G.Global_Sales > A.AvgGlobalSales;

-- Query 5 (includes 5.1, 5.2, 5.3 and the rest below)
-- 5.1 Creating a VIEW using PublisherName
CREATE VIEW GamePublisherInfo AS
SELECT G.`Rank`, G.PublisherID, G.Title, G.Global_Sales, (G.NA_Sales + G.EU_Sales) AS WesternSales
FROM Games G
JOIN Publisher P ON G.PublisherID = P.PublisherID;

-- 5.2 Select from the VIEW
SELECT * FROM GamePublisherInfo;

-- Drop to reset VIEW (just in case)
DROP VIEW IF EXISTS GamePublisherInfo;

-- 5.3 Updating PublisherID from N/A to actual publisherID in Games table 
-- For Rank = 3161
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'Nintendo') 
WHERE `Rank` = 3161;

-- For Rank = 4637
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'THQ') 
WHERE `Rank` = 4637;

-- For Rank = 4528
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'THQ') 
WHERE `Rank` = 4528;

-- For Rank = 4147
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'Sega') 
WHERE `Rank` = 4147;

-- For Rank = 2224
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'Sony Computer Entertainment') 
WHERE `Rank` = 2224;

-- For Rank = 1664
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'TDK Mediactive') 
WHERE `Rank` = 1664;

-- For Rank = 1305
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'EA Sports') 
WHERE `Rank` = 1305;

-- For Rank = 471
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'THQ') 
WHERE `Rank` = 471;

-- For Rank = 3168
UPDATE Games 
SET PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherName = 'THQ') 
WHERE `Rank` = 3168;


-- Re-running the SELECT query on the GamePublisherInfo view to check (ordering via Rank)
SELECT *
FROM GamePublisherInfo
ORDER BY `Rank`;










