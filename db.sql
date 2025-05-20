-- Recreate database
DROP DATABASE IF EXISTS MyCasinoDB;
CREATE DATABASE MyCasinoDB;
USE MyCasinoDB;

-- 1. RoleTypes
DROP TABLE IF EXISTS RoleTypes;
CREATE TABLE RoleTypes (
    RoleID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    RoleName VARCHAR(100) UNIQUE NOT NULL,
    Authority INT CHECK (Authority BETWEEN 1 AND 4)
);

-- 2. GameTypes
DROP TABLE IF EXISTS GameTypes;
CREATE TABLE GameTypes (
    GameID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    GameName VARCHAR(100) NOT NULL,
    HouseEdge FLOAT CHECK (HouseEdge BETWEEN 0 AND 100)
);

-- 3. Employees
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    RoleID INT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Salary INT,
    Manager VARCHAR(100),
    HandsPerHour VARCHAR(100), -- Only if dealer
    FOREIGN KEY (RoleID) REFERENCES RoleTypes(RoleID)
);

-- 4. Customers
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    CustomerID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    PurchaseAmount INT,
    TotalPurchaseAmount INT,
    TotalExitAmount INT,
    IsBannedFromCasino BOOLEAN
);

-- 5. Tables
DROP TABLE IF EXISTS Tables;
CREATE TABLE Tables (
    TableID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    GameType INT,
    NumSeats INT,
    FOREIGN KEY (GameType) REFERENCES GameTypes(GameID)
);

-- 6. Games
DROP TABLE IF EXISTS Games;
CREATE TABLE Games (
    GameSession INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    GameID INT,
    TableID INT,
    DealerID INT,
    MinBet INT DEFAULT 10,
    MaxBet INT,
    MaxPlayers INT,
    FOREIGN KEY (GameID) REFERENCES GameTypes(GameID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID),
    FOREIGN KEY (DealerID) REFERENCES Employees(EmployeeID)
);

-- 7. Bets
DROP TABLE IF EXISTS Bets;
CREATE TABLE Bets (
    BetID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    GameID INT,
    Multiplier INT,
    IsWon BOOLEAN,
    Amount INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (GameID) REFERENCES Games(GameSession)
);