CREATE DATABASE IF NOT EXISTS CasinoDB;
USE CasinoDB;

-- Disable foreign key checks temporarily to prevent dependency issues
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables to allow for updates
DROP TABLE IF EXISTS Bets;
DROP TABLE IF EXISTS CustomerGames;
DROP TABLE IF EXISTS Tables;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Games;

-- Recreate tables with the correct schema

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Role VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Desk INT UNIQUE NULL,
    Salary INT NOT NULL CHECK (Salary > 0),
    ManagerID INT NULL,
    HandsPerHour INT NULL CHECK (HandsPerHour >= 0),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    PurchaseAmount INT NOT NULL DEFAULT 0,
    TotalPurchaseAmount INT NOT NULL DEFAULT 0,
    IsBanned TINYINT(1) NOT NULL DEFAULT 0
);

-- Games Table
CREATE TABLE Games (
    GameID INT PRIMARY KEY, -- No AUTO_INCREMENT
    GameName VARCHAR(255) NOT NULL,
    MinBet INT NOT NULL DEFAULT 10,
    MaxBet INT NOT NULL DEFAULT 10000, -- Remove CHECK (MaxBet > MinBet)
    MaxPlayers INT NOT NULL DEFAULT 6 CHECK (MaxPlayers > 0),
    DealerRequired TINYINT(1) NOT NULL DEFAULT 1,
    HouseEdge DECIMAL(4,2) NOT NULL DEFAULT 1.50,
    PayoutRatio DECIMAL(5,2) NOT NULL DEFAULT 2.00
);

-- Tables Table
CREATE TABLE Tables (
    TableID INT PRIMARY KEY AUTO_INCREMENT,
    ActiveEmployeeID INT NULL,
    GameID INT NOT NULL,
    SeatCount INT NOT NULL CHECK (SeatCount > 0),
    FOREIGN KEY (ActiveEmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- Bets Table
CREATE TABLE Bets (
    BetID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    TableID INT NOT NULL,
    GameID INT NOT NULL,
    BetAmount INT NOT NULL CHECK (BetAmount > 0),
    Multiplier DECIMAL(5,2) NOT NULL CHECK (Multiplier > 0),
    BetTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    IsWin TINYINT(1) NOT NULL,
    WinAmount INT NOT NULL CHECK (WinAmount >= 0),
    MinBet INT NOT NULL DEFAULT 10 CHECK (MinBet >= 10),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (TableID) REFERENCES Tables(TableID) ON DELETE CASCADE,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- CustomerGames Table
CREATE TABLE CustomerGames (
    CustomerGameID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    GameID INT NOT NULL,
    TimesPlayed INT NOT NULL CHECK (TimesPlayed >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Reset AUTO_INCREMENT values
ALTER TABLE Employees AUTO_INCREMENT = 1;
ALTER TABLE Customers AUTO_INCREMENT = 1;
ALTER TABLE Tables AUTO_INCREMENT = 1;
ALTER TABLE Bets AUTO_INCREMENT = 1;
ALTER TABLE CustomerGames AUTO_INCREMENT = 1;

-- Insert sample Games (Manually assign GameID)
INSERT INTO Games (GameID, GameName, MinBet, MaxBet, MaxPlayers, DealerRequired, HouseEdge, PayoutRatio) VALUES 
(1, 'Blackjack', 10, 1000, 7, 1, 1.50, 2.00),
(2, 'Roulette', 5, 500, 6, 1, 2.70, 35.00),
(3, 'Poker', 20, 5000, 8, 1, 1.00, 1.90),
(4, 'Craps', 10, 500, 12, 1, 1.41, 1.98),
(5, 'Baccarat', 50, 5000, 10, 1, 1.06, 2.00);

-- Insert Managers first (ManagerID = NULL)
INSERT INTO Employees (Role, FirstName, LastName, Salary, ManagerID, HandsPerHour) VALUES
('Manager', 'Sarah', 'Johnson', 6000, NULL, NULL),
('Manager', 'Linda', 'Garcia', 6200, NULL, NULL);

-- Insert other Employees
INSERT INTO Employees (Role, FirstName, LastName, Salary, ManagerID, HandsPerHour) VALUES
('Dealer', 'John', 'Doe', 3500, 1, 5),
('Pit Boss', 'Jane', 'Smith', 4500, 2, 6),
('Security', 'Mike', 'Johnson', 3000, NULL, 4);

-- Insert sample Customers
INSERT INTO Customers (FirstName, LastName, PurchaseAmount, TotalPurchaseAmount, IsBanned) VALUES
('Alice', 'Brown', 500, 5000, 0),
('Bob', 'Williams', 300, 2500, 0),
('Charlie', 'Davis', 0, 0, 1),
('David', 'Miller', 200, 1500, 0),
('Emma', 'Clark', 600, 6000, 0);

-- Insert sample Tables
INSERT INTO Tables (ActiveEmployeeID, GameID, SeatCount) VALUES
(NULL, 1, 7),
(NULL, 2, 6),
(NULL, 3, 8),
(NULL, 4, 12),
(NULL, 5, 10);

-- Insert sample Bets
INSERT INTO Bets (CustomerID, TableID, GameID, BetAmount, Multiplier, IsWin, WinAmount) VALUES
(1, 1, 1, 100, 2.0, 1, 200),
(2, 2, 2, 50, 1.5, 0, 0),
(3, 3, 3, 200, 3.0, 1, 600),
(4, 4, 4, 30, 2.0, 1, 60),
(5, 5, 5, 150, 1.2, 0, 0);

-- Insert sample CustomerGames
INSERT INTO CustomerGames (CustomerID, GameID, TimesPlayed) VALUES
(1, 1, 15),
(2, 2, 10),
(3, 3, 5),
(4, 4, 20),
(5, 5, 12);

-- Verify data
SELECT * FROM Games;
SELECT * FROM Bets;
SELECT * FROM Customers;