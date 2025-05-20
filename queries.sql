use mycasinodb;

SELECT 
    DATE(CreatedAt) AS BetDate,
    SUM(CASE WHEN IsWon = 0 THEN Amount ELSE 0 END) AS DailyRevenue,
    COUNT(*) AS TotalBets
FROM Bets
GROUP BY BetDate
ORDER BY BetDate;


SELECT 
    G.GameSession,
    SUM(B.Amount) AS TotalBetAmount,
    E.EmployeeID AS DealerID,
    E.FirstName AS DealerFirstName,
    E.LastName AS DealerLastName
FROM Bets B
JOIN Games G ON B.GameID = G.GameSession
JOIN Employees E ON G.DealerID = E.EmployeeID
GROUP BY G.GameSession, E.EmployeeID, E.FirstName, E.LastName
ORDER BY TotalBetAmount DESC
LIMIT 1;


SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

DELIMITER $$

CREATE TRIGGER trg_UpdateTotalPurchaseAmount
AFTER INSERT ON Bets
FOR EACH ROW
BEGIN
    UPDATE Customers
    SET TotalPurchaseAmount = TotalPurchaseAmount + NEW.Amount
    WHERE CustomerID = NEW.CustomerID;
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_Employees_Salary_Positive
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.Salary <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary must be greater than 0';
    END IF;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE GetCustomerTotalBets(IN custID INT)
BEGIN
    SELECT 
        CustomerID,
        COUNT(BetID) AS TotalBets
    FROM Bets
    WHERE CustomerID = custID
    GROUP BY CustomerID;
END $$

DELIMITER ;


-- check table

ALTER TABLE Employees
ADD CONSTRAINT chk_Salary_Positive CHECK (Salary > 0);


ALTER TABLE Customers
ADD CONSTRAINT chk_PurchaseAmounts_NonNegative CHECK (
    PurchaseAmount >= 0 AND
    TotalPurchaseAmount >= 0 AND
    TotalExitAmount >= 0
);

ALTER TABLE Tables
ADD CONSTRAINT chk_NumSeats_Range CHECK (NumSeats BETWEEN 1 AND 10);
