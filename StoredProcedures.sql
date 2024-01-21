USE VideoGamesSalesDB;

-- Creating DeleteLast10Rows procedure which deletes last 10 rows from the games table
DELIMITER //
CREATE PROCEDURE DeleteLast10Rows(OUT rowsDeleted INT)
BEGIN
    -- Starting the transaction
    START TRANSACTION;

    -- Deleting the last 10 rows (as descending order) from the Games table
    DELETE FROM Games ORDER BY `Rank` DESC LIMIT 10;

    -- Checking the number of affected rows and set the OUT parameter appropriately
    SET rowsDeleted = ROW_COUNT();

    -- Only if the row count is greater than 0, transaction will be committed
    IF rowsDeleted > 0 THEN
        COMMIT;
    -- However, if no rows were deleted, rollback will be issued
    ELSE
        ROLLBACK;
        -- setting rowsDeleted to 0 to indicate no deletion has occured (just in case)
        SET rowsDeleted = 0;
    END IF;
END //
DELIMITER ;

-- Dropping the procedure if it already exists to avoid errors on creation just in case
DROP PROCEDURE IF EXISTS DeleteLast10Rows;

-- Procedure for updating NA_Sales, EU_Sales, and then recalculates Global_Sales for the last row in the games table
DELIMITER //
CREATE PROCEDURE UpdateLastRowSales(
    IN newNA_Sales DECIMAL(10, 2), 
    IN newEU_Sales DECIMAL(10, 2),
    OUT affectedRank INT
)
BEGIN
    -- Declares a variable to hold the rank of the last row
    DECLARE lastRank INT;

    -- Starting transaction
    START TRANSACTION;

    -- Selects the rank of the last row to be updated
    SELECT `Rank` INTO lastRank FROM Games
    ORDER BY `Rank` DESC LIMIT 1;

    -- Updating the last row with new sales values
    UPDATE Games
    SET NA_Sales = newNA_Sales, EU_Sales = newEU_Sales
    WHERE `Rank` = lastRank;

    -- Recalculating and updating Global_Sales for the last row (after updating last row)
    UPDATE Games
    SET Global_Sales = NA_Sales + EU_Sales + JP_Sales
    WHERE `Rank` = lastRank;

    -- transaction to be committed
    COMMIT;

    -- Set the OUT parameter to the rank of the row that was updated in the procedure
    SET affectedRank = lastRank;
END //
DELIMITER ;

-- Calling procedure statement for DeleteLast10Rows
SET @rowsDeleted = 0;
CALL DeleteLast10Rows(@rowsDeleted);
-- To check whether last 10 rows were deleted
SELECT @rowsDeleted AS 'Rows Deleted';

-- New Sales Value examples for UpdateLastRowSales Procedure
SET @newNA_Sales = 1.2;   
SET @newEU_Sales = 0.8;   
-- Variable to hold the rank of the affected row
SET @affectedRank = 0;    

-- Calling UpdateLastRowSales Procedure
CALL UpdateLastRowSales(@newNA_Sales, @newEU_Sales, @affectedRank);

-- After calling the stored procedure, checking which rank was affected 
SELECT @affectedRank AS 'Affected Rank';

