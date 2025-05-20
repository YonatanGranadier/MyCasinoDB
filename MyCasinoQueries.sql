
-- highest profitable customers

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(b.Amount) AS TotalBets,
    SUM(CASE WHEN b.IsWon = TRUE THEN b.Amount * b.Multiplier ELSE 0 END) AS TotalWinnings,
    SUM(b.Amount) - SUM(CASE WHEN b.IsWon = TRUE THEN b.Amount * b.Multiplier ELSE 0 END) AS NetLossOrProfit
FROM
    Customers c
JOIN
    Bets b ON c.CustomerID = b.CustomerID
GROUP BY
    c.CustomerID
ORDER BY
    NetLossOrProfit desc
LIMIT 5;

-- dealer efficiency report

SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS DealerName,
    COUNT(g.GameSession) AS GamesDealt,
    COALESCE(SUM(b.Amount), 0) AS TotalMoneyHandled
FROM
    Employees e
JOIN
    Games g ON e.EmployeeID = g.DealerID
LEFT JOIN
    Bets b ON g.GameSession = b.GameID
WHERE
    e.RoleID IN (SELECT RoleID FROM RoleTypes WHERE RoleName LIKE '%Dealer%')
GROUP BY
    e.EmployeeID
ORDER BY
    TotalMoneyHandled DESC;
    
    -- riskiest clients for buisness
    
    
    
    SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(b.BetID) AS TotalBets,
    SUM(b.Amount) AS TotalSpent,
    SUM(CASE
        WHEN b.IsWon = TRUE THEN b.Amount * b.Multiplier
        ELSE 0
    END) AS TotalWinnings,
    SUM(b.Amount) - SUM(CASE
        WHEN b.IsWon = TRUE THEN b.Amount * b.Multiplier
        ELSE 0
    END) AS NetLoss,
    c.IsBannedFromCasino
FROM
    Customers c
        JOIN
    Bets b ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID
HAVING NetLoss < - 2000
    AND IsBannedFromCasino = FALSE
ORDER BY NetLoss DESC
LIMIT 10;

-- most active tables

SELECT
    t.TableID,
    gt.GameName,
    COUNT(g.GameSession) AS GamesPlayed
FROM
    Tables t
JOIN
    Games g ON t.TableID = g.TableID
JOIN
    GameTypes gt ON t.GameType = gt.GameID
GROUP BY
    t.TableID, gt.GameName
ORDER BY
    GamesPlayed DESC;
    
    
    -- game profitability report
    
    
    
    
    SELECT
    GT.GameName,
    COUNT(B.BetID) AS TotalBets,
    ROUND(AVG(B.Amount), 2) AS AvgBetAmount,
    ROUND(SUM(CASE WHEN B.IsWon = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS WinRatePercent
FROM
    Bets B
JOIN
    Games G ON B.GameID = G.GameSession
JOIN
    GameTypes GT ON G.GameID = GT.GameID
GROUP BY
    GT.GameName
ORDER BY
    AvgBetAmount DESC;
    
    
    -- daily profit
    
    SELECT
    DATE(CreatedAt) AS BetDate,
    SUM(CASE WHEN IsWon = 0 THEN Amount ELSE 0 END) AS DailyRevenue,
    COUNT(*) AS TotalBets
FROM
    Bets
GROUP BY
    BetDate
ORDER BY
    BetDate;

-- highest earning session

SELECT
    G.GameSession,
    SUM(B.Amount) AS TotalBetAmount,
    E.EmployeeID AS DealerID,
    E.FirstName AS DealerFirstName,
    E.LastName AS DealerLastName
FROM
    Bets B
JOIN
    Games G ON B.GameID = G.GameSession
JOIN
    Employees E ON G.DealerID = E.EmployeeID
GROUP BY
    G.GameSession, E.EmployeeID, E.FirstName, E.LastName
ORDER BY
    TotalBetAmount DESC
LIMIT 1;



-- highest earning employess

SELECT
    G.GameSession,
    SUM(B.Amount) AS TotalBetAmount,
    E.EmployeeID AS DealerID,
    E.FirstName AS DealerFirstName,
    E.LastName AS DealerLastName
FROM
    Bets B
JOIN
    Games G ON B.GameID = G.GameSession
JOIN
    Employees E ON G.DealerID = E.EmployeeID
GROUP BY
    G.GameSession, E.EmployeeID, E.FirstName, E.LastName
ORDER BY
    TotalBetAmount DESC
LIMIT 1;




