-- First declare the sakila database as the database for subsequent actions to be taken
use sakila;
SET SQL_SAFE_UPDATES = 0;
-- Using select, select only the first and last names from the actor table (1a)
select actor.first_name,actor.last_name from actor;
-- Now the first and last names will be merged and put into a new column in the table Actor Name (1b)
alter table actor
	Add column `Actor Name` varchar(100);
-- Now select the same columns as in 1a and insert them into the new column(1b)
update actor
	SET `Actor Name` = UCASE(CONCAT(first_name,' ',last_name));


-- To find the Joe, and return only relevant information, use the following (2a)
select actor_id,first_name,last_name from actor where first_name = 'Joe';
-- To find all actors whose last name contain GEN we use the following (2b)
select `Actor Name` from actor where last_name LIKE '%GEN%';
-- Similarly, we will use wildcard to find all actors with LI int heir last name but order the rows by last name then first name (2c)
select * from actor where last_name LIKE '%LI%' order by last_name, first_name;
-- I'm glad the homework does not specify to switch to the country table for this one,
-- that would be simply too coherent (2d )
select country_id, country from country where country = 'Afghanistan' 
																	or country='Bangladesh'
                                                                    or country='China';
                                                                    
                                                                    
-- Oh cool, we are back to the actor table again for #3
-- As above, we will add a middle_name column with varchar datatype (3a)
alter table actor
	Add column middle_name varchar(100) after first_name;
-- Not sure why the homework references last names? Anyways, we will change the datatype to blobs form varchar (3b)
alter table actor
	modify middle_name blob;
-- Because Trilogy is a fickle master, it now makes me destroy my creations for its amusements (3d)
alter table actor
	drop middle_name;

-- For this problem, we will not just select but also count how many times that last name appears (4a)
select last_name, COUNT(*) from actor GROUP BY last_name;

-- Now we will apply where logic to the count and groupby above (4b)
select last_name, COUNT(*) from actor GROUP BY last_name HAVING count(*) >= 2;

-- We will now update the GROUCHO WILLIAMS entry by changing the first_name to HARPO (4c)
update actor
	set actor.first_name = 'HARPO'
	where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
-- We will now create a command that will change HARPO if found to GROUCHO
-- and if we find GROUCHO we will change it to MUCHO GROUCHO
-- Using the where actor_id clause will constrain the update to only the relevant actor (4d)
update actor
	set actor.first_name = 
	CASE 
		WHEN first_name = 'HARPO' and last_name = 'WILLIAMS' THEN 'GROUCHO' 
		Else 'MUCHO GROUCHO' END
	where actor_id = 172;
-- We will now investigate the schema of the address table using show create table (5a)
show create table address;

-- We will now use JOIN to display the first and last names and address of staff members
-- by using an inner join on the tables staff and address (6a)
select address.address, address.address_id, staff.first_name, staff.last_name from staff 
	Inner Join address on staff.address_id = address.address_id;
-- We will now use another join and aggregate function sum() to tally up how much each staff member checked out (6b)
select payment.staff_id, sum(payment.amount) as 'Total Rental Sales ($)',staff.staff_id, staff.first_name, staff.last_name from staff 
	Inner Join payment on staff.staff_id = payment.staff_id group by staff.staff_id;
-- We will now use joins to print out a count of actors in each film in film and film_actor(6c)
select film.film_id, count(film_actor.actor_id) as 'Count of Actors in Movie',film.title as 'Movie Title' from film 
	Inner Join film_actor on film.film_id = film_actor.film_id group by film_id;
-- We will again use the inner join and count functions to determine the number of copies of Hunchback Impossible (6d)
select  title, count(title) as 'Number of Copies of Film'  from (
	select film.film_id as fid, film.title, inventory.inventory_id, inventory.film_id as iid from inventory
	Inner Join film on inventory.film_id = film.film_id) 
    as table1 where title = 'Hunchback Impossible' group by title;
-- We will now use the payment and customer tables and join to determine the amount paid per customer
-- the results will also be sorted alphabetically by customer's last name (6e)
select customer.first_name, customer.last_name, sum(payment.amount) as 'Total Amount Paid ($)' from customer
	Inner Join payment on customer.customer_id = payment.customer_id group by customer.customer_id order by customer.last_name;
    
-- We will now use subqueries to query both films that start with the letter K and Q and the language is english (7a)
select * from 
	(select title,language_id from film where title LIKE "K%" or title LIKE "Q%") 
as t1 where language_id = 1;
-- We will now use subqueries to list all actors in the film "Alone Trip" (7b)
select first_name,last_name from actor where actor_id in (
	select actor_id from film_actor where film_id = (
		select film_id from film where title = 'Alone Trip'));
-- We will now use joins to determine all canadian (country_id = 20) customers of Sakila DVD (7c)
#select customer.first_name as 'First Name', customer.last_name as 'Last Name', customer.email from (
select * from rental inner join customer where rental.customer_id = customer.customer_id;