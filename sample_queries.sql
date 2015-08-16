/*
Drill final for SQL course that required we create a relational database of fictional libraries with book, locations, user data.

I created this script to create the database with the assigned SCHEMA.

After the database was created there were several query scenarios we had to execute. 
*/

Create Table Book
(BookID INT Primary Key, Title Varchar(100) Not Null,
PublisherName Varchar(50) Foreign Key References Publisher(Name) Not Null)

Create Table Book_Authors
(BookID int FOREIGN KEY REFERENCES Book(BookID), AuthorName Varchar(100) Not Null)

Create Table Library_Branch
(BranchID INT Primary Key, BranchName Varchar(100) Not Null, Address Varchar(100) Not Null)

Create Table Borrower
(CardNo INT Primary Key, Name Varchar(30) Not Null, 
Address Varchar(100) Not Null, Phone Varchar(13) Not Null)

Create Table Publisher
(Name Varchar(50) Primary Key, Address Varchar(100) Not Null, Phone varchar(13) Not Null)

Create Table Book_Copies
(BookID int FOREIGN KEY REFERENCES Book(BookID), 
BranchID int FOREIGN KEY REFERENCES Library_Branch(BranchID) Not Null, 
No_Of_Copies Varchar(10) Not Null)

Create Table Book_Loans
(BookID int FOREIGN KEY REFERENCES Book(BookID), 
BranchID int FOREIGN KEY REFERENCES Library_Branch(BranchID) Not Null, 
CardNo Int Foreign Key References Borrower(CardNo) Not Null, 
DateOut Varchar(10) Not Null, DueDate Varchar(10) Not Null)

ALTER TABLE Book
Alter Column Publishername Varchar(50) Foreign Key References Publisher(Name) Not Null


/*
Query 1: How many copies of the book titled The Lost Tribe are owned by the library branch whose name
is"Sharpstown"?
*/

Select Title, BranchName, No_Of_Copies
From Book AS B Left Join Book_Copies AS BC
ON b.BookID = BC.BookID
Join Library_Branch AS LB
ON LB.BranchID = BC.BranchID
Where Title = 'The Lost Tribe' AND BranchName = 'Sharpstown'


/*
Query 2:  How many copies of the book titled The Lost Tribe are owned by each library branch?
*/

Select Title, BranchName, No_Of_Copies
From Book AS B Left Join Book_Copies AS BC
ON b.BookID = BC.BookID
Join Library_Branch AS LB
ON LB.BranchID = BC.BranchID
Where Title = 'The Lost Tribe'


/*
Query 3:  Retrieve the names of all borrowers who do not have any books checked out.
*/

SELECT Name, Address
FROM Borrower as B
LEFT OUTER JOIN Book_Loans as BL ON B.CardNo = BL.CardNo
WHERE BL.CardNo IS NULL


/*
Query 4: For each book that is loaned out from the "Sharpstown" branch and whose DueDate is today,
retrieve the book title, the borrower's name, and the borrower's address.
*/

Select LB.BranchName, BL.DueDate, B.Title, Name, BO.Address
From Book_Loans AS BL Left join Library_Branch AS LB
ON BL.BranchID = LB.BranchID
Join Book as B 
ON B.BookID = BL.BookID
Join Borrower as BO
ON BO.CardNo = BL.CardNo
Where BranchName = 'Sharpstown'
AND DueDate = 060615


/*
Query 5:  For each library branch, retrieve the branch name and the total number of books loaned out from
that branch.
*/

select LB.BranchName,COUNT(*) as TotalLoans
From Book_Loans AS BL Left Join Library_Branch AS LB
ON BL.BranchID = LB.BranchID
Where BL.BranchID = 1
OR BL.BranchID = 2
OR BL.BranchID = 3
Or BL.BranchID = 4
Group By BranchName


/*
Query 6: Retrieve the names, addresses, and number of books checked out for all borrowers who have more
than five books checked out.
*/

Select Borrower.Name,Borrower.Address,Count(Book_Loans.CardNo) as BookTotal
From Borrower inner join Book_Loans
ON Borrower.CardNo=Book_Loans.CardNo
Group By Borrower.Address, Borrower.Name
Having Count(Book_Loans.CardNo) > 4


/*
Query 7: For each book authored (or co-authored) by "Stephen King", retrieve the title and the number of
copies owned by the library branch whose name is "Central"
*/

Select Title, BranchName, No_Of_Copies
From Book AS B Left Join Book_Copies as BC
ON b.BookID = BC.BookID
Join Library_Branch AS LB
ON LB.BranchID = BC.BranchID
Join Book_Authors as BA
ON BA.BookID = B.BookID
Where AuthorName = 'Stephen King'
AND BranchName = 'Central'