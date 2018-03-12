CREATE TABLE FURNITURE_STORE(
  StoreID    integer,
  Address    varchar(50),
  PhoneNumber   char(10),
  CONSTRAINT FURNITURE_STORE_PK PRIMARY KEY (StoreID)
);

CREATE TABLE STOCK(
  StockID    integer,
  Address    varchar(50),
  StockQuantity   integer,
  StockCapacity   integer not null,
  CONSTRAINT STOCK_PK PRIMARY KEY (StockID)
);

CREATE TABLE FURNITURE(
  FurnitureID    integer,
  FurnitureType    varchar(20) not null,
  FurnitureName    varchar(30),
  StockID   integer,
  Ava_Flag char(1) not null,
  CONSTRAINT FURNITURE_PK PRIMARY KEY (FurnitureID)
);


CREATE TABLE DEAL(
  DealID    integer,
  Price    integer,
  Deal_Date   date DEFAULT TRUNC(SYSDATE),
  FurnitureID   integer,
  Cashier_Ssn   char(9),
  CustomerName  varchar(30),
  C_PhoneNumber char(10),
  CONSTRAINT DEAL_PK PRIMARY KEY (DealID)
);

CREATE TABLE SUPPLIER(
  SupplierID    integer,
  SupplierType    varchar(20),
  SupplierName    varchar(30) DEFAULT 'UNKNOWN',
  PhoneNumber   char(10),
  CONSTRAINT SUPPLIER_PK PRIMARY KEY (SupplierID)
);

CREATE TABLE CUSTOMER(
  CustomerName    varchar(30),
  PhoneNumber   char(10),
  CONSTRAINT CUSTOMER_PK PRIMARY KEY (CustomerName,PhoneNumber)
);

CREATE TABLE SUPPLY_DEAL(
  Supply_DealID    integer,
  Supply_Deal_Date  date DEFAULT TRUNC(SYSDATE),
  SupplierID    integer,
  StockID   integer,
  FurnitureID integer,
  S_Price integer not null,
  CONSTRAINT SUPPLY_DEAL_PK PRIMARY KEY (Supply_DealID)
);

CREATE TABLE EMPLOYEE(
Ssn CHAR(9),
JobType VARCHAR(20) DEFAULT 'CASHIER',
Employee_Name VARCHAR(30),
BirthDate DATE,
Salary INTEGER DEFAULT 10000,
PhoneNumber CHAR(10) not null,
CONSTRAINT EMPLOYEE_PK PRIMARY KEY (Ssn));


CREATE TABLE CASHIER(
C_Ssn CHAR(9),
StoreID INTEGER,
CONSTRAINT CASHIER_PK PRIMARY KEY (C_Ssn));

CREATE TABLE DELIVERER(
D_Ssn CHAR(9),
Car_plate VARCHAR(10) not null,
CONSTRAINT DELIVERER_PK PRIMARY KEY (D_Ssn));

CREATE TABLE STOCK_MANAGER
(
S_Ssn CHAR(9),
StockID INTEGER,
CONSTRAINT STOCK_MANAGER_PK PRIMARY KEY (S_Ssn));

CREATE TABLE DELIVERS
(
D_Ssn CHAR(9),
StoreID INTEGER,
CONSTRAINT DELIVERS_PK PRIMARY KEY (D_Ssn,StoreID));

CREATE TABLE STORES
(
StoreID INTEGER,
StockID INTEGER,
CONSTRAINT STORES_PK PRIMARY KEY (StoreID,StockID));

ALTER TABLE STOCK ADD CONSTRAINT STOCK_fk FOREIGN KEY(ManagerSsn) REFERENCES STOCK_MANAGER(S_Ssn) ON DELETE SET NULL;
ALTER TABLE FURNITURE ADD CONSTRAINT FURNITURE_fk FOREIGN KEY(StockID) REFERENCES STOCK(StockID) ON DELETE SET NULL;
ALTER TABLE DEAL ADD CONSTRAINT DEAL_fka FOREIGN KEY(FurnitureID) REFERENCES FURNITURE(FurnitureID)ON DELETE SET NULL;
ALTER TABLE DEAL ADD CONSTRAINT DEAL_fkb FOREIGN KEY(CustomerName,C_PhoneNumber) REFERENCES CUSTOMER(CustomerName, PhoneNumber)ON DELETE SET NULL;
ALTER TABLE DEAL ADD CONSTRAINT DEAL_fkd FOREIGN KEY(Cashier_Ssn) REFERENCES CASHIER(C_Ssn)ON DELETE SET NULL;
ALTER TABLE SUPPLY_DEAL ADD CONSTRAINT SUPPLY_DEAL_fka FOREIGN KEY(SupplierID) REFERENCES SUPPLIER(SupplierID)ON DELETE SET NULL;
ALTER TABLE SUPPLY_DEAL ADD CONSTRAINT SUPPLY_DEAL_fkb FOREIGN KEY(StockID) REFERENCES STOCK(StockID)ON DELETE SET NULL;
ALTER TABLE SUPPLY_DEAL ADD CONSTRAINT SUPPLY_DEAL_fkc FOREIGN KEY(FurnitureID) REFERENCES FURNITURE(FurnitureID)ON DELETE SET NULL;
ALTER TABLE CASHIER ADD CONSTRAINT CASHIER_fkb FOREIGN KEY(StoreID) REFERENCES FURNITURE_STORE(StoreID)ON DELETE SET NULL;
ALTER TABLE STOCK_MANAGER ADD CONSTRAINT STOCK_MANAGER_fk FOREIGN KEY(StockID) REFERENCES STOCK(StockID)ON DELETE SET NULL;

ALTER TABLE CASHIER ADD CONSTRAINT CASHIER_fk FOREIGN KEY(C_Ssn) REFERENCES EMPLOYEE(Ssn)ON DELETE SET NULL;
ALTER TABLE DELIVERER ADD CONSTRAINT DELIVERER_fk FOREIGN KEY(D_Ssn) REFERENCES EMPLOYEE(Ssn)ON DELETE SET NULL;
ALTER TABLE STOCK_MANAGER ADD CONSTRAINT STOCK_MANAGER_EM_fka FOREIGN KEY(S_Ssn) REFERENCES EMPLOYEE(Ssn)ON DELETE SET NULL;

ALTER TABLE DELIVERS ADD CONSTRAINT DELIVERS_fka FOREIGN KEY(D_Ssn) REFERENCES DELIVERER(D_Ssn)ON DELETE SET NULL;
ALTER TABLE DELIVERS ADD CONSTRAINT DELIVERS_fkb FOREIGN KEY(StoreID) REFERENCES FURNITURE_STORE(StoreID)ON DELETE SET NULL;
ALTER TABLE STORES ADD CONSTRAINT STORES_fka FOREIGN KEY(StoreID) REFERENCES FURNITURE_STORE(StoreID)ON DELETE SET NULL;
ALTER TABLE STORES ADD CONSTRAINT STORES_fkb FOREIGN KEY(StockID) REFERENCES STOCK(StockID)ON DELETE SET NULL;

Create or replace trigger Stock_Trigger
    Before insert or update of Supply_DealID on Supply_Deal
    For each row
Declare 
Begin
        select StockQuantity, Stockcapacity into 
            from Stock S
            where :New.StockID =  S.StockID;
    DBMS_output.putline('Input&&&'||StockQuantity||Stockcapacity);
End;
    

CREATE OR REPLACE TRIGGER STOCK
    BEFORE
    INSERT OR UPDATE OF Supply_DealID ON SUPPLY_DEAL
    FOR EACH ROW
Declare 
Quantity STOCK.STOCKQUANTITY%TYPE;
Capacity STOCK.STOCKCAPACITY%TYPE;
BEGIN
     SELECT StockQuantity, StockCapacity into Quantity, Capacity FROM STOCK WHERE STOCK.STOCKID = :NEW.STOCKID;
     DBMS_OUTPUT.put_line('1111'||Quantity||Capacity);   
END;

set serveroutput on;
CREATE OR REPLACE TRIGGER TEST3
    Before
    INSERT OR UPDATE OF Supply_DealID ON SUPPLY_DEAL
    FOR EACH ROW
BEGIN
     DBMS_OUTPUT.put_line('1111');   
END;

INSERT INTO  Furniture(FURNITUREID, FurnitureType, FurnitureName, StockID,AVA_Flag) values(23,'chair','good chair',2,1);
INSERT INTO  SUPPLY_DEAL(Supply_DealID, SUPPLY_DEAL_DATE,SUPPLIERID,STOCKID,FURNITUREID,S_Price) VALUES (23,to_date ( '11/15/2007' , 'MM/DD/YYYY' ),2,2,23,60);

delete from Supply_Deal where supply_dealid = 23;
delete from Furniture where FURNITUREID = 23;
raise_application_error(-20001,'xixixi');

CREATE OR REPLACE TRIGGER Stock_Capacity
    After
    INSERT OR UPDATE OF Supply_DealID ON SUPPLY_DEAL
    FOR EACH ROW
Declare 
Quantity STOCK.STOCKQUANTITY%TYPE;
Capacity STOCK.STOCKCAPACITY%TYPE;
begin
SELECT StockQuantity, StockCapacity into Quantity, Capacity FROM STOCK WHERE STOCK.STOCKID = :NEW.Stockid;
if(Quantity  >= Capacity) then
raise_application_error(-20001,'Error occurs because the capacity of stock is full. ');
end if;  
end;

set serveroutput on;
INSERT INTO  SUPPLY_DEAL(Supply_DealID, SUPPLY_DEAL_DATE,SUPPLIERID,STOCKID,FURNITUREID,S_Price) VALUES (23,to_date ( '11/15/2007' , 'MM/DD/YYYY' ),2,1,23,60);

INSERT INTO DEAL(DEALID, PRICE, DEAL_DATE, FURNITUREID, CASHIER_SSN, CUSTOMERNAME, C_PHONENUMBER)
VALUES(8,90,to_date ( '10/15/2017' , 'MM/DD/YYYY' ),23,444444444,'Edison',4698565698);

CREATE OR REPLACE TRIGGER DEAL_AMOUNT
    After
    INSERT OR UPDATE OF DEALID ON DEAL
    FOR EACH ROW
Declare 
Quantity STOCK.STOCKQUANTITY%TYPE;
begin

SELECT STOCKQUANTITY INTO QUANTITY 
FROM STOCK S, FURNITURE F
WHERE :NEW.FURNITUREID = F.FURNITUREID
AND F.STOCKID = S.STOCKID;

update STOCK S
SET S.STOCKQUANTITY = S.STOCKQUANTITY - 1
WHERE :NEW.FURNITUREID = F.FURNITUREID
AND F.STOCKID = S.STOCKID;
end;



CREATE OR REPLACE PROCEDURE BONUS
(
  this_ssn in employee.ssn%type,
  BONUS out employee.ssn%type
)
AS
COUNT_DEAL INTEGER;
OUT_SSN VARCHAR(9);
OLD_SALARY INTEGER;
BEGIN
SELECT COUNT (DEALID),C.C_SSN,E.SALARY INTO COUNT_DEAL, OUT_SSN, OLD_SALARY
FROM DEAL D,CASHIER C,EMPLOYEE E
WHERE E.SSN = C.C_SSN
AND C.C_SSN = D.CASHIER_SSN
GROUP BY C.C_SSN;
IF (COUNT_DEAL > 2) THEN
BONUS:= OLD_SALARY*0.2;
END IF;
DBMS_OUTPUT.PUT_LINE(this_ssn||' Bonus is '||bonus);
END;


set serveroutput on;
DECLARE
  THIS_SSN CHAR(9);
BEGIN
  THIS_SSN := '222222222';
  BONUS(
    THIS_SSN => THIS_SSN
  );
END;

SELECT COUNT (D.DEALID),C.C_SSN
FROM DEAL D,CASHIER C,EMPLOYEE E
WHERE E.SSN = C.C_SSN
AND C.C_SSN = D.CASHIER_SSN 
GROUP BY C.C_SSN;












create or replace PROCEDURE BENIFITS
(
  this_FID in FURNITURE.FURNITUREID%type
)
AS
FLAG CHAR(1);
INPRICE SUPPLY_DEAL.S_PRICE%TYPE;
OUTPRICE DEAL.PRICE%TYPE;
BENIFIT DEAL.PRICE%TYPE;
BEGIN
SELECT F.AVA_FLAG INTO FLAG
FROM FURNITURE F
WHERE F.FURNITUREID = THIS_FID;
IF(FLAG = 0 ) THEN
SELECT S.S_PRICE, D.PRICE INTO INPRICE,OUTPRICE
FROM SUPPLY_DEAL S, DEAL D
WHERE S.FURNITUREID = THIS_FID
AND D.FURNITUREID = THIS_FID;
BENIFIT := OUTPRICE - INPRICE;
DBMS_OUTPUT.PUT_LINE(this_FID||' BENIFIT is '||BENIFIT);
ELSE
DBMS_OUTPUT.PUT_LINE('STILL AVAILABLE');
END IF;
END;

set serveroutput on;
DECLARE
  THIS_FID INTEGER;
BEGIN
  THIS_FID := 2;
  BENIFITS(
    THIS_FID => THIS_FID
  );
END;