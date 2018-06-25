-- First declare the sakila database as the database for subsequent actions to be taken
use sakila;
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



