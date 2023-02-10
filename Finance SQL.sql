create database Project;
use Project;

SHOW VARIABLES LIKE "secure_file_priv"; -- Find directory using this command 
-- and put the file in that directoty
-- Uploads folder was hidden.
-- Enabled Uploads folder by show hidden folder
-- put Finance_1 dataset in uploads folder in .csv format
-- Create table using Import table wizard and then truncate table just to keep headers 
truncate table project.finance_1;
SELECT * FROM finance_1;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance_1.csv'
INTO TABLE Finance_1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- -------------------------------------------------------------------------------------------------------
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance_1_loadtest_csv.csv'
INTO TABLE Finance_1_new
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM project.finance_1_new;

truncate table project.finance_1_temp;

SELECT * FROM finance_1_temp;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance_1.csv'
INTO TABLE Finance_1_temp
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- ---------------------------------------------------------------------------------------------------------
truncate table finance_2;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance_2.csv'
INTO TABLE finance_2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- ---------------------------------------------------------------------------------------------------------
-- Year wise loan amount Stats

SELECT  year(str_to_date(issue_d,'%b-%y')) year_of_issue, sum(loan_amnt)
FROM finance_1
group by (year_of_issue )
order by(year_of_issue);
-- ----------------------------------------------------------------------------------------------------
-- Grade and sub grade wise revol_bal

SELECT 
   finance_1.Grade,
     finance_1.sub_grade, 
     sum( finance_2.revol_bal)
     from finance_2
     inner join   finance_1 on finance_1.id =finance_2.id
group by  finance_1.sub_grade,finance_1.sub_grade
    order by   finance_1.sub_grade asc;

-- ------------------------------------------------------------------------------------------------------
-- Total Payment for Verified Status Vs Total Payment for Non Verified Status

select
finance_1.verification_status,
      
    round(sum( total_pymnt),1)
     from finance_2
     inner join   finance_1 on finance_1.id =finance_2.id
group by  finance_1.verification_status;

-- -----------------------------------------------------------------------------------------------------

-- State wise and last_credit_pull_d wise loan status


 SELECT 
   finance_1.addr_state,
   count(finance_1.loan_status),
   finance_2.last_credit_pull_d
   from finance_2
     inner join   finance_1 on finance_1.id =finance_2.id
     -- where finance_1.addr_state='AK'
group by finance_1.addr_state, finance_2.last_credit_pull_d -- with rollup
order by   finance_1.addr_state   asc;
-- ------------------------------------------------------------------------------------------------------
-- Home ownership Vs last payment date stats
select
finance_1.home_ownership,
finance_2.last_pymnt_d,
 count( finance_2.last_pymnt_d)
   from finance_2
     inner join   finance_1 on finance_1.id =finance_2.id
     group by finance_1.home_ownership,
finance_2.last_pymnt_d;
-- order by month(str_to_date(finance_2.last_pymnt_d,'%b-%y'));