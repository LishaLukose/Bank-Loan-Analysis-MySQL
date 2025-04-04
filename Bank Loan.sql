create database BankLoan;
use BankLoan;

create table financialloan(id int, address_state varchar(50), application_type varchar(50), 
emp_length varchar(50), emp_title varchar(100), grade varchar(50), home_ownership varchar(50), issue_date date, 
last_credit_pull_date date, last_payment_date date, loan_status varchar(50), next_payment_date date, member_id int, purpose varchar(50),
sub_grade varchar(50), term varchar(50), verification_status varchar(50), annual_income float, dti float, installment float, int_rate float,
loan_amount int, total_acc tinyint, total_payment int);

select * from financialloan;

#DASHBOARD 1 - SUMMARY

# 1 Total Loan Applications
select count(id) as TotalLoanApplications from financialloan;

# 1.1 Month to Date(MTD) Total Loan Applications
select count(id) as MTD_TotalLoanApplications from financialloan where month(issue_date) = 12 and year(issue_date) = 2021;

# 1.2 PMTD Total Loan Applications
select count(id) as PMTD_TotalLoanApplications from financialloan where month(issue_date) = 11 and year(issue_date) = 2021;

# 2 Total Funded Amount
select concat(sum(loan_amount)/1000000, 'M') as TotalFundedAmount from financialloan;

# 2.1 Month to Date(MTD) Total Funded Amount
select concat(sum(loan_amount)/1000000, 'M') as MTD_TotalFundedAmount from financialloan where month(issue_date) = 12 and year(issue_date) = 2021;

# 2.2 PMTD Total Funded Amount
select concat(sum(loan_amount)/1000000, 'M') as PMTD_TotalFundedAmount from financialloan where month(issue_date) = 11 and year(issue_date) = 2021;

# 3 Total Amount Received
select concat(sum(total_payment)/1000000,'M') as TotalAmountReceived from financialloan;

# 3.1 Month to Date(MTD) Total Amount Received
select concat(sum(total_payment)/1000000,'M') as TotalAmountReceived from financialloan where month(issue_date) = 12 and year(issue_date) = 2021;

# 3.2 PMTD Total Amount Received
select concat(sum(total_payment)/1000000,'M') as TotalAmountReceived from financialloan where month(issue_date) = 11 and year(issue_date) = 2021;

# 4 Average Interest Rate
select concat(round(avg(int_rate) *100,2),' %') as AverageInterestRate from financialloan;

# 4.1 Month to Date(MTD) Average Interest Rate
select concat(round(avg(int_rate) *100,2),' %') as AverageInterestRate from financialloan where month(issue_date) = 12 and year(issue_date) = 2021;

# 4.2 PMTD Average Interest Rate
select concat(round(avg(int_rate) *100,2),' %') as AverageInterestRate from financialloan where month(issue_date) = 11 and year(issue_date) = 2021;

# 5 Average Debt to Income Ratio
select round(avg(dti) *100,2) as Avd_dti from financialloan;

# 5.1 Month to Date(MTD) Average Debt to Income Ratio
select round(avg(dti) *100,2) as Avd_dti from financialloan where month(issue_date) = 12 and year(issue_date) = 2021;

# 4.2 PMTD Average Debt to Income Ratio
select round(avg(dti) *100,2) as Avd_dti from financialloan where month(issue_date) = 11 and year(issue_date) = 2021;

# 5 Good Loan

# 5.1 Good Loan Application Percentage
select concat(round((count(case when loan_status ='Fully Paid'or loan_status ='Current' then id end)*100)/
count(id),2),' %') as GoodLoanPercentage from financialloan;

# 5.2 Good Loan Applications
select count(id) as GoodLoanApplications from financialloan where loan_status in ('Fully Paid', 'Current');

# 5.3 Good Loan Funded Amount
select concat(round(sum(loan_amount)/1000000,2),'M') as GoodLoanFundedAmount from financialloan where loan_status in ('Fully Paid', 'Current');

# 5.4 Good Loan Received Amount
select concat(round(sum(total_payment)/1000000,2),'M') as GoodLoanReceivedAmount from financialloan where loan_status in ('Fully Paid', 'Current');

# 6 Bad Loan

# 6.1 Bad Loan Application Percentage
select concat(round((count(case when loan_status ='charged Off' then id end)*100)/
count(id),2),' %') as BadLoanPercentage from financialloan;

# 6.2 Bad Loan Applications
select count(id) as BadLoanApplications from financialloan where loan_status ='Charged Off';

# 6.3 Bad Loan Funded Amount
select concat(round(sum(loan_amount)/1000000,2),'M') as BadLoanFundedAmount from financialloan where loan_status ='Charged Off';

# 6.4 Bad Loan Received Amount
select concat(round(sum(total_payment)/1000000,2),'M') as BadLoanReceivedAmount from financialloan where loan_status ='Charged Off';

# 7 Loan Status Grid View
select loan_status as LoanStatus, count(id) as TotalLoanApplications, concat(round(sum(total_payment)/1000000,2),'M') as TotalAmountReceived,
concat(round(sum(loan_amount)/1000000,2),'M') as TotalFundedAmount, concat(round(avg(int_rate*100),2),' %') as InterestRate, 
concat(round(avg(dti*100),2),' %') as DTI
from financialloan group by loan_status order by TotalLoanApplications desc;

# 7.1 Loan Status MTD
select loan_status as LoanStatus, concat(round(sum(total_payment)/1000000,2),'M') as MTD_TotalAmountReceived,
concat(round(sum(loan_amount)/1000000,2),'M') as MTD_TotalFundedAmount
from financialloan where month(issue_date) =12 group by loan_status order by sum(total_payment) desc;

#DASHBOARD 2 - OVERVIEW

#1 Monthly Trends by Issue Date
select month(issue_date) as SiNo, monthname(issue_date) as Month, count(id) as TotalLoanApplications, concat(round(sum(total_payment)/1000000,2),'M') as TotalAmountReceived,
concat(round(sum(loan_amount)/1000000,2),'M') as TotalFundedAmount from financialloan group by SiNo,Month order by SiNo;

#2 Regional Analysis by State
select address_state as Address, count(id) as TotalLoanApplications, concat(round(sum(total_payment)/1000000,2),'M') as TotalAmountReceived,
concat(round(sum(loan_amount)/1000000,2),'M') as TotalFundedAmount from financialloan group by Address order by TotalLoanApplications desc;

#3 Loan Term Analysis
select term as Term, count(id) as TotalLoanApplications, concat(round(sum(total_payment)/1000000,2),'M') as TotalAmountReceived,
concat(round(sum(loan_amount)/1000000,2),'M') as TotalFundedAmount from financialloan group by Term order by TotalLoanApplications desc;

#4 Employee Length Analysis
select emp_length as EmployeeLength, count(id) as TotalLoanApplications, concat(round(sum(total_payment)/1000000,2),'M') as TotalAmountReceived,
concat(round(sum(loan_amount)/1000000,2),'M') as TotalFundedAmount from financialloan group by EmployeeLength order by TotalLoanApplications desc;

#5 Loan Purpose Breakdown
select purpose as Purpose, count(id) as TotalLoanApplications, concat(round(sum(total_payment)/1000000,2),'M') as TotalAmountReceived,
concat(round(sum(loan_amount)/1000000,2),'M') as TotalFundedAmount from financialloan group by Purpose order by TotalLoanApplications desc;

#6 Home Ownership Analysis
select home_ownership as HomeOwnership, count(id) as TotalLoanApplications, concat(round(sum(total_payment)/1000000,2),'M') as TotalAmountReceived,
concat(round(sum(loan_amount)/1000000,2),'M') as TotalFundedAmount from financialloan group by HomeOwnership order by TotalLoanApplications desc;

#DASHBOARD 3 - DETAILS
select * from financialloan;