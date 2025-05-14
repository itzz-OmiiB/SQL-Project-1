----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Creating database:

CREATE DATABASE Online_Book_store;

USE Online_Book_store;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Creating Tables

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- creating Books table:

DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- creating Customers table:

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- creating Orders table:

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- displaying tables:

SELECT * FROM Books;

SELECT * FROM Customers;

SELECT * FROM Orders;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Import Data into Books Table:

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'F:\pgadmin\Books.csv' 
CSV HEADER;


-- Import Data into Customers Table:

COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'F:\pgadmin\Customers.csv' 
CSV HEADER;


-- Import Data into Orders Table:

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'F:\pgadmin\Orders.csv' 
CSV HEADER;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- BASIC QUERIES -->>

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--1) retrive all the books in 'fiction' genre:

SELECT * FROM Books WHERE genre = 'Fiction';


--2) find books published after the year 1950:

SELECT * FROM Books WHERE published_year > 1950;


--3) loist all the customers from 'canada':

SELECT *FROM Customers WHERE country = 'Canada'


--4) show all orders placed in november 2023:

SELECT* FROM Orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


--5) retrive the total stock of books available:

SELECT SUM(stock) AS TOTAL_STOCK FROM Books;


--6) find the details of the most expensive book:

SELECT * FROM Books ORDER BY Price DESC LIMIT 1;


--7)show all the customers who ordered more than 1 quantity of book:

SELECT * FROM Orders WHERE Quantity > 1;


--8) retrive all the orders where the total amount exceeds $20:

SELECT * FROM Orders WHERE total_amount > 20;


--9) list all the genre that are available in table Books:

SELECT DISTINCT Genre FROM Books;


--10) find the book with the lowest stock:

SELECT * FROM Books ORDER BY stock LIMIT 5;


--11) calculate the total revenus generated from all orders:

SELECT SUM(total_amount) AS total_revenue_generated FROM Orders;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ADVENCED QUERIES -->>

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--1) retrive the total no. of books sold for each genre:

SELECT b.genre, SUM(o.quantity) AS total_books_sold
FROM Orders o 
JOIN Books b 
ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;


--2) find the average price of books in the 'fantasy' genre:

SELECT o.Book_ID, b.title, COUNT(o.Order_ID) AS Order_count
FROM Orders o
JOIN Books b ON o.book_id = b.Book_ID
GROUP BY o.Book_ID, b.title
ORDER BY Order_count DESC;


--3) list the customers who have placed atleast 2 orders: 

SELECT o.Book_ID, b.title, COUNT(o.Order_ID) AS Order_count
FROM Orders o
JOIN Books b ON o.book_id = b.Book_ID
GROUP BY o.Book_ID, b.title
ORDER BY Order_count DESC
LIMIT 7;

--4) find the most frequently ordered book:

SELECT o.Book_id, b.title, COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC LIMIT 1;


--5) show the top 3 most expensive books of 'Fantasy' genre:

SELECT * FROM Books 
WHERE GENRE = 'Fantasy'
ORDER BY Price DESC 
LIMIT 3;


--6) retrive the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS total_books_sold
FROM Orders o
JOIN Books b ON o.book_ID = b.book_ID
GROUP BY b.author;


--7) list the cities where the customers who spent over $30 are located:

SELECT DISTINCT c.city, o.total_amount
FROM Customers c
JOIN Orders o ON c.customer_ID = o.customer_ID
WHERE o.total_amount > 30;


--8) find the customers who spent the most on orders:

SELECT c.customer_ID, c.name, SUM(o.total_amount) AS total_spend
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.name
ORDER BY total_spend DESC
LIMIT 1;


--9) calculate the stock remaining after fulfilling all the orders:
 
SELECT b.Book_ID, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity, b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID 
ORDER BY b.Book_ID;



								***************************************
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
