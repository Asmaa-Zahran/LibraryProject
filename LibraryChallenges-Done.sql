use library;

/*******************************************************/
/* find the number of availalbe copies of Dracula      */
/*******************************************************/
-- ..code..

/* check total copies of the book */
-- ..code..

select * from books where title = 'Dracula';

select count(*) from books where title = 'Dracula';

/* current total loans of the book */
-- ..code..
-- update loans set returneddate = null where returneddate = '2020-07-13';

select * from books b inner join loans l on b.bookid = l.bookid 
where l.returneddate is null and b.title = 'Dracula'; 

select count(*) from loans where returneddate is null and bookid in
(select bookid from books where title ='Dracula');

select count(*) from books b inner join loans l on b.bookid = l.bookid 
where l.returneddate is null and b.title = 'Dracula'; 


/* total available book */
-- ..code..
create view current_loan as
				select l.bookid from books b inner join loans l on b.bookid = l.bookid 
				where l.returneddate is null and b.title = 'Dracula'; 

select count(distinct b.bookid)  from books b inner join loans l on b.bookid = l.bookid 
where not(l.returneddate is null) and b.title = 'Dracula'
and b.bookid != (select bookid from current_loan); 

/*******************************************************/
/* Add new books to the library                        */
/*******************************************************/
-- ..code..

insert into books values(201,'Head First Data Analysis','Michael Milton',2009,123459876);

/*******************************************************/
/* Check out Books                                     */
/*******************************************************/
-- ..code..
select * from books;
select * from books where bookid = 201;
/********************************************************/
/* Check books for Due back                             */
/* generate a report of books due back on July 13, 2020 */
/* with patron contact information                      */
/********************************************************/
-- ..code..

select b.bookid,b.title,l.duedate ,l.returneddate ,concat(p.firstname,' ',p.lastname) full_name,p.email from books b inner join loans l on b.bookid = l.bookid 
inner join patrons p on l.patronid = p.patronid
where l.duedate = '2020-07-13';


/*******************************************************/
/* Return books to the library                         */
/*******************************************************/
-- ..code..
update loans set returneddate = duedate where duedate = '2020-07-13';

/*******************************************************/
/* Encourage Patrons to check out books                */
/* generate a report of showing 10 patrons who have
checked out the fewest books.                          */
/*******************************************************/
-- ..code..

select l.patronid , concat(p.firstname,' ' ,p.lastname) full_name , count(l.bookid) book_count
from loans l inner join patrons p on l.patronid = p.patronid 
group by l.patronid order by book_count asc 
limit 10;

/*******************************************************/
/* Find books to feature for an event                  
 create a list of books from 1890s that are
 currently available                                    */
/*******************************************************/
-- ..code..
select * from books where published >= 1890;

create view not_available_books as 
select b.bookid from books b inner join loans l on b.bookid = l.bookid 
where published >= 1890 and l.returneddate is null;


select * from not_available_books;

select * from books where published >= 1890 and
bookid not in (select bookid from not_available_books);


/*******************************************************/
/* Book Statistics 
/* create a report to show how many books were 
published each year.                                    */
/*******************************************************/
select published , count(*) book_count from books group by published
order by book_count desc;

/*************************************************************/
/* Book Statistics                                           */
/* create a report to show 5 most popular Books to check out */
/*************************************************************/
select l.bookid ,b.title ,count(l.loandate) loan_count from loans l inner join books b 
on l.bookid = b.bookid 
group by bookid order by loan_count desc
limit 5;
