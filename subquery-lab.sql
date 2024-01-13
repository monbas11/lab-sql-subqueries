 -- How many copies of the film Hunchback Impossible exist in the inventory system?

select film_id from film 
where title = "HUCHBACK IMPOSSIBLE";

select count(*) from inventory
where film_id = (select film_id from film 
				where title = "HUCHBACK IMPOSSIBLE");
                
-- List all films whose length is longer than the average of all the films
-- step 1: calculate the avg of lenght
 select avg(length) from film;
 
-- step 2: select the films where length > avg(length)
select title
from film
where length > (select avg(length) from film);
-- show all the db filtered by films having length > avg(length)

select *, avg(length) over () as average_length
where length = (select avg(length) from film);

-- Use subqueries to display all actors who appear in the film Alone Trip.
-- step 1 check the film id
select film_id from film
where title = 'Alone Trip';

-- step 2 filter the db by actors where film_id = "alone trip"
select actor.actor_id, actor.first_name, actor.last_name
from actor
where actor.actor_id in (
    select film_actor.actor_id
    from film_actor
    where film_actor.film_id = (
        select film_id
        from film
        where title = 'Alone Trip'));


-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films
-- step 1 check the category id
select category_id from category
where name = "family";

-- step 2 filter the db
select * 
from film
where film.film_id in (
    select film_category.film_id
    from film_category
    where film_category.category_id = (
        select category_id
        from category
        where name = 'Family'
    )
);


-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- subquery:
select customer.first_name, customer.last_name, customer.email
from customer
where customer.address_id in (
    select address.address_id
    from address
    where address.city_id in (
        select city.city_id
        from city
        where city.country_id = (
            select country.country_id
            from country
            where country.country = 'Canada')));
            
-- join:
select customer.first_name, customer.last_name, customer.email
from customer
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
where country.country = 'Canada';


-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred

-- Step1 Find the most prolific actor
select actor_id, first_name, last_name
FROM actor
where actor_id = (
    select actor_id
    from film_actor
    group by actor_id
    order by count(*) desc
    limit 1);

-- step 2 list the films starred by the most prolific actor
select title
from film
where film_id in (
    select film_id
    from film_actor
    where actor_id = (
        select actor_id
        from film_actor
        group by actor_id
        order by count(*) desc
        limit 1));


-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments


select  customer_id, first_name, last_name
from customer
where customer_id = (
    select customer_id
    from payment
    group by customer_id
    order by sum(amount) desc
    limit 1);


-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having total_amount_spent > (
    select avg(total_amount_spent)
    from (
        select customer_id, sum(amount) as total_amount_spent
        from payment
        group by customer_id
    ) as customer_totals);
