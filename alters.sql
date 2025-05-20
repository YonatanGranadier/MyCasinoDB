-- check table




ALTER TABLE Customers
ADD CONSTRAINT chk_PurchaseAmounts_NonNegative CHECK (
    PurchaseAmount >= 0 AND
    TotalPurchaseAmount >= 0 AND
    TotalExitAmount >= 0
);

ALTER TABLE Tables
ADD CONSTRAINT chk_NumSeats_Range CHECK (NumSeats BETWEEN 1 AND 10);


ALTER TABLE Bets
ADD CONSTRAINT chk_BetAmount_Positive CHECK (Amount > 0);


ALTER TABLE Games
ADD CONSTRAINT chk_MinMaxBet CHECK (MinBet <= MaxBet);


-- check table

ALTER TABLE Employees
ADD CONSTRAINT chk_Salary_Positive CHECK (Salary > 0);




