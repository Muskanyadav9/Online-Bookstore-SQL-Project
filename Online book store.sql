CREATE DATABASE Onlinebookstore;
use  Onlinebookstore;

-- create tables
create table Books(
			Book_ID SERIAL primary key,
            Title varchar(100),
            Author varchar(100),
            Genre varchar(50),
            Published_Year INT,
            Price numeric(10,2),
            Stock int
);

create table Customers(
			Customer_ID serial primary key,
            Name varchar(100),
            Email varchar(100),
            Phone varchar(15),
            City varchar(50),
            Country varchar(150)
);
drop table if exists Orders;
create table Orders(
			Order_ID serial primary key,
            Customer_ID int references Customers(Customer_ID),
            Book_ID int references Books(Book_ID),
            Order_Date date,
            Quantity int,
            Total_Amount numeric(10,2)
);

 select * from books;
 select * from customers;
 select * from orders;
			
            
-- all books in fiction genre
select * from books
where Genre = 'Fiction';     

-- books published after year 1950
select * from books
where Published_Year> 1950;       

-- list all customers from canada
select Name from customers 
where Country='Canada'; 

-- orders placed in november 2023
select * from orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- total stock of books available
select sum(Stock) as total_stock from  books;

-- most expensive book
select Title, Price from books
order by Price desc limit 1;

-- customers who ordered more than 1 quantity of book
select Name from customers as c  
join orders as o
on c.Customer_ID= o.customer_id
where o.Quantity>1;
 
 -- orders where total amount exceeds 20$
select * from orders 
where total_amount>20;

-- list all the genre available in books table
select distinct Genre from books;

-- book with lowest stock
select Title from books 
order by Stock asc limit 1;

-- total revenue generated from all orders
select sum(total_amount) as revenue from orders;

-- total no of books sold for each genre
select b.Genre , sum(o.Quantity ) as total_books_sold
from orders as o
join books as b
on b.Book_ID = o.Book_ID
group by b.Genre;

-- average price of books in fantasy genre
 select Genre , avg(Price) as average_price
 from books
 where Genre = 'Fantasy';
 
-- customers who have placed atleast 2 orders
select o.Customer_ID, c.Name , count(o.Order_ID) as order_count 
from customers c
join orders o
on c.Customer_ID = o.Customer_ID
group by Customer_Id , c.Name
having count(Order_ID)>=2;

-- most frequently ordered book
select b.Book_ID, b.Title , count(Order_ID) as Order_Count
from books b
join orders o
on b.Book_ID= o.Book_ID
group by Book_ID
order by Order_Count desc limit 1 ;

-- top 3 most expensive books of fantasy genre
select Title , Price
from books
where Genre = 'Fantasy'
order by Price desc limit 3;

-- total quantity of books sold by each author
select b.Author , sum(o.Quantity) as total_books_sold
from books b
join orders o
on b.Book_ID = o.Book_ID
group by b.author;

-- cities where customer who spent over 30$ are located
select distinct c.City , o.total_amount
from customers c
join orders o
on c.Customer_ID = o.Customer_ID
where o.total_amount>30;

-- customer who spent the most on orders
select c.Customer_ID, c.Name, sum(o.total_amount) as total_amount_spent
from customers c
join orders o 
on c.Customer_ID= o.Customer_ID
group by c.Customer_ID, c.Name
order by total_amount_spent desc limit 1;

-- stock remaining after fulfilling all orders
select b.Book_ID , b.Title , b.Stock , coalesce(sum(o.quantity),0) as order_quantity, b.stock - coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o 
on b.book_id= o.book_id
group by b.book_id;