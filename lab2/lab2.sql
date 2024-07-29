/*
Lab 2 report: Jheng-Kai Chen (jhech107) and Sih-Rong Huang (sihhu499) and Yunkai Lin Pan (yunli498)
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS jbitem_view CASCADE;
DROP TABLE IF EXISTS jbitems2 CASCADE;
DROP VIEW IF EXISTS jbsale_supply CASCADE;
DROP VIEW IF EXISTS jbitem_view CASCADE;
DROP TABLE IF EXISTS new_jbitem CASCADE;
-- DROP VIEW IF EXISTS total_cost_debit_RIGHT_join CASCADE;
-- DROP VIEW IF EXISTS total_cost_debit_join CASCADE;
DROP VIEW IF EXISTS total_cost_debit CASCADE;
DROP VIEW IF EXISTS totalCostOfEachdebit_2 CASCADE;



/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;

/*
Question 1: Print a message that says "hello world"
*/

SELECT 'hello world!' AS 'message';

/* Show the output for every question.
+--------------+
| message      |
+--------------+
| hello world! |
+--------------+
1 row in set (0.00 sec)
*/ 


/*Question 1: List all employees, i.e., all tuples in the jbemployee relation.*/
SELECT * FROM jbemployee;

/*
Query result:
+------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+
25 rows in set (0.01 sec)
*/


/*Question 2: List the name of all departments in alphabetical order. Note: by “name”
we mean the name attribute in the jbdept relation.*/
SELECT name FROM jbdept order by name;

/*
Query result:
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
19 rows in set (0.00 sec)
*/

/*Question 3: What parts are not in store? Note that such parts have the value 0 (zero)
for the qoh attribute (qoh = quantity on hand). **/
SELECT * FROM jbparts WHERE qoh = 0;

/*
Query result:
+----+-------------------+-------+--------+------+
| id | name              | color | weight | qoh  |
+----+-------------------+-------+--------+------+
| 11 | card reader       | gray  |    327 |    0 |
| 12 | card punch        | gray  |    427 |    0 |
| 13 | paper tape reader | black |    107 |    0 |
| 14 | paper tape punch  | black |    147 |    0 |
+----+-------------------+-------+--------+------+
4 rows in set (0.00 sec)
*/

/*Question 4: List all employees who have a salary between 9000 (included) and
10000 (included)? */
SELECT * FROM jbemployee where salary between 9000 and 10000;

/*
Query result:
+-----+----------------+--------+---------+-----------+-----------+
| id  | name           | salary | manager | birthyear | startyear |
+-----+----------------+--------+---------+-----------+-----------+
|  13 | Edwards, Peter |   9000 |     199 |      1928 |      1958 |
|  32 | Smythe, Carol  |   9050 |     199 |      1929 |      1967 |
|  98 | Williams, Judy |   9000 |     199 |      1935 |      1969 |
| 129 | Thomas, Tom    |  10000 |     199 |      1941 |      1962 |
+-----+----------------+--------+---------+-----------+-----------+
4 rows in set (0.00 sec)
*/

/*Question 5: List all employees together with the age they had when they started
working? Hint: use the startyear attribute and calculate the age in the
SELECT clause.*/
SELECT *, (startyear - birthyear) as age FROM jbemployee;

/*
Query result:
+------+--------------------+--------+---------+-----------+-----------+------+
| id   | name               | salary | manager | birthyear | startyear | age  |
+------+--------------------+--------+---------+-----------+-----------+------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |   18 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |    1 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |   30 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |   40 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |   38 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |   32 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |   22 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |   24 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |   49 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |   34 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |   21 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |   20 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |    0 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |   21 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |   21 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |   20 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |   26 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |   21 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |   19 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |   21 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |   23 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |   19 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |   19 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |   24 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |   15 |
+------+--------------------+--------+---------+-----------+-----------+------+
25 rows in set (0.00 sec)
*/

/*Question 6: List all employees who have a last name ending with “son”.*/
SELECT * FROM jbemployee WHERE name like "%son,%";

/*
Query result:
+----+---------------+--------+---------+-----------+-----------+
| id | name          | salary | manager | birthyear | startyear |
+----+---------------+--------+---------+-----------+-----------+
| 26 | Thompson, Bob |  13000 |     199 |      1930 |      1970 |
+----+---------------+--------+---------+-----------+-----------+
1 row in set (0.00 sec)
*/

/*Question 7: . Which items (note items, not parts) have been delivered by a supplier
called Fisher-Price? Formulate this query by using a subquery in the
WHERE clause.*/
SELECT * FROM jbitem 
WHERE supplier in (SELECT id from jbsupplier where name = "Fisher-Price");

/*
Query result:
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
+-----+-----------------+------+-------+------+----------+
3 rows in set (0.00 sec)
*/

/*Question 8: Formulate the same query as above, but without a subquery*/
SELECT *, S.id 
FROM jbitem I 
JOIN jbsupplier S on I.supplier = S.id and  S.name = 'Fisher-Price';

/*
Query result:
+-----+-----------------+------+-------+------+----------+----+--------------+------+----+
| id  | name            | dept | price | qoh  | supplier | id | name         | city | id |
+-----+-----------------+------+-------+------+----------+----+--------------+------+----+
|  43 | Maze            |   49 |   325 |  200 |       89 | 89 | Fisher-Price |   21 | 89 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 | 89 | Fisher-Price |   21 | 89 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 | 89 | Fisher-Price |   21 | 89 |
+-----+-----------------+------+-------+------+----------+----+--------------+------+----+
3 rows in set (0.01 sec)
*/

/*Question 9: List all cities that have suppliers located in them. Formulate this query
using a subquery in the WHERE clause.*/
/* Can be done also with this query, but it only shows the city id */
-- SELECT DISTINCT city FROM jbsupplier;
SELECT C.name, C.id, S.name ,S.city 
FROM jbcity C JOIN jbsupplier S 
WHERE C.id in (SELECT city from jbsupplier where C.id = S.city);

/*
Query result:
+----------------+-----+--------------+------+
| name           | id  | name         | city |
+----------------+-----+--------------+------+
| San Diego      | 921 | Amdahl       |  921 |
| White Plains   | 106 | White Stag   |  106 |
| Hickville      | 118 | Wormley      |  118 |
| San Francisco  | 941 | Levi-Strauss |  941 |
| Denver         | 802 | Whitman's    |  802 |
| Atlanta        | 303 | Data General |  303 |
| Salt Lake City | 841 | Edger        |  841 |
| Boston         |  21 | Fisher-Price |   21 |
| Seattle        | 981 | White Paper  |  981 |
| Dallas         | 752 | Playskool    |  752 |
| Los Angeles    | 900 | Koret        |  900 |
| Atlanta        | 303 | Cannon       |  303 |
| New York       | 100 | IBM          |  100 |
| Paxton         | 609 | Spooley      |  609 |
| Amherst        |  10 | DEC          |   10 |
| Madison        | 537 | A E Neumann  |  537 |
+----------------+-----+--------------+------+
16 rows in set (0.00 sec)
*/

/*Question 10: What is the name and the color of the parts that are heavier than a card
reader? Formulate this query using a subquery in the WHERE clause.*/
SELECT name, color, weight 
FROM jbparts 
WHERE weight > (SELECT weight FROM jbparts WHERE name = "card reader");

/*
Query result:
+--------------+--------+--------+
| name         | color  | weight |
+--------------+--------+--------+
| disk drive   | black  |    685 |
| tape drive   | black  |    450 |
| line printer | yellow |    578 |
| card punch   | gray   |    427 |
+--------------+--------+--------+
4 rows in set (0.00 sec)
*/

/*Question 11: Formulate the same query as above, but without a subquery. Again, the
query must not contain the weight of the card reader as a constant*/
SELECT M.name, M.color, M.weight 
FROM jbparts M 
join jbparts S ON M.weight > S.weight and S.name = "card reader";

/*
Query result:
+--------------+--------+--------+
| name         | color  | weight |
+--------------+--------+--------+
| disk drive   | black  |    685 |
| tape drive   | black  |    450 |
| line printer | yellow |    578 |
| card punch   | gray   |    427 |
+--------------+--------+--------+
4 rows in set (0.00 sec)
*/


/*Question 12: What is the average weight of all black parts?*/
SELECT AVG(weight) 
FROM jbparts 
WHERE color = "black";

/*
Query result:
+-------------+
| AVG(weight) |
+-------------+
|    347.2500 |
+-------------+
1 row in set (0.00 sec)
*/


/*Question 13: For every supplier in Massachusetts (“Mass”), retrieve the name and the
total weight of all parts that the supplier has delivered? Do not forget to
take the quantity of delivered parts into account. Note that one row
should be returned for each supplier.*/
SELECT S.name, SUM(P.weight * SU.quan) as total_weight
FROM jbsupplier S
JOIN jbcity C ON S.city = C.id
JOIN jbsupply SU ON S.id = SU.supplier
JOIN jbparts P ON SU.part = P.id
WHERE C.state = 'Mass'
GROUP BY S.name;

/*
Query result:
+--------------+--------------+
| name         | total_weight |
+--------------+--------------+
| DEC          |         3120 |
| Fisher-Price |      1135000 |
+--------------+--------------+
2 rows in set (0.00 sec)
*/

/*Question 14: . Create a new relation with the same attributes as the jbitems relation by
using the CREATE TABLE command where you define every attribute
explicitly (i.e., not as a copy of another table). Then, populate this new
relation with all items that cost less than the average price for all items.
Remember to define the primary key and foreign keys in your table!*/
CREATE TABLE new_jbitem (
    id INT NOT NULL,
    name VARCHAR(255),
    dept INT NOT NULL,
    price INT,
    qoh INT,
    supplier INT,
    constraint pk_jbitem_1
        primary key (id),
    constraint fk_jbitem_1
        FOREIGN KEY (dept) references jbdept(id),
    constraint fk_jbitem_2
        FOREIGN KEY (supplier) references jbsupplier(id)
);

INSERT INTO new_jbitem (id, name, dept, price, qoh, supplier)
SELECT id, name, dept, price, qoh, supplier 
FROM jbitem 
WHERE price < (SELECT AVG(price) FROM jbitem);

SELECT * FROM new_jbitem;

/*
Query result:
Query OK, 0 rows affected, 1 warning (0.03 sec)

Query OK, 14 rows affected (0.02 sec)
Records: 14  Duplicates: 0  Warnings: 0

+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)
*/

/*Question 15: Create a view that contains the items that cost less than the average
price for items.*/
CREATE VIEW jbitem_view AS 
SELECT * FROM jbitem 
WHERE price < (SELECT AVG(price) FROM jbitem);
SELECT * FROM jbitem_view;

/*
Query result:
Query OK, 0 rows affected (0.01 sec)

+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)
*/


/*Question 16: What is the difference between a table and a view? One is static and the
other is dynamic. Which is which and what do we mean by static
respectively dynamic?*/

-- static ---> table
-- dynamic ---> view
 
-- table owns data by themselves and won't influence by other table, which we consider static.
-- view do not hold data themselves. If data is changing in the underlying table, the same change is reflected in the view, which we consider dynamic.


/*Question 17: Create a view that calculates the total cost of each debit, by considering
price and quantity of each bought item.*/
CREATE VIEW total_cost_debit AS
SELECT S.debit, SUM(S.quantity*I.price) AS total_price
FROM jbitem I, jbsale S
WHERE S.item = I.id
GROUP BY S.debit;

SELECT * FROM total_cost_debit;

/*
Query result:
Query OK, 0 rows affected (0.00 sec)

+--------+-------------+
| debit  | total_price |
+--------+-------------+
| 100581 |        2050 |
| 100582 |        1000 |
| 100586 |       13446 |
| 100592 |         650 |
| 100593 |         430 |
| 100594 |        3295 |
+--------+-------------+
6 rows in set (0.00 sec)
*/


/*Question 18: Do the same as in the previous point, but now capture the join conditions
in the FROM clause by using only left, right or inner joins. Hence, the
WHERE clause must not contain any join condition in this case. Motivate
why you use type of join you do (left, right or inner), and why this is the
correct one (in contrast to the other types of joins).*/
CREATE VIEW totalCostOfEachdebit_2 AS
SELECT s.debit, SUM(s.quantity*i.price) AS total_cost
FROM jbsale s
LEFT JOIN jbitem i ON s.item = i.id
GROUP BY s.debit;

-- drop view totalCostOfEachdebit_2;

-- see result
SELECT * FROM totalCostOfEachdebit_2;


/*
Query result:
+--------+------------+
| debit  | total_cost |
+--------+------------+
| 100581 |       2050 |
| 100586 |      13446 |
| 100592 |        650 |
| 100593 |        430 |
| 100594 |       3295 |
+--------+------------+
5 rows in set (0.00 sec)
*/

/*
Reason:
Because we need all records in table jbsale,
So use left join instead of right join
And we only need the items in jbsale
Therefore, we can use leftjoin to filter out item information that is not used in jbitem.
Using right join will retain the data we don’t need in jbitem


Using inner join, when the jbitem data is wrong, such as the id is missing or wrong, the data in jbsale will be moved together. This is not what we want.
*/


/*Question 19: Oh no! An earthquake!

a) Remove all suppliers in Los Angeles from the jbsupplier table.*/
DELETE FROM jbsale 
WHERE item IN (SELECT id FROM jbitem WHERE supplier IN
(SELECT id FROM jbsupplier WHERE city IN
(SELECT id FROM jbcity WHERE name = "Los Angeles")));

DELETE FROM jbitem WHERE supplier IN
(SELECT id FROM jbsupplier WHERE city IN
(SELECT id FROM jbcity WHERE name = "Los Angeles"));

DELETE FROM new_jbitem WHERE supplier IN 
(SELECT id FROM jbsupplier WHERE city IN
(SELECT id FROM jbcity WHERE name = "Los Angeles"));

DELETE FROM jbsupply WHERE supplier IN
(SELECT id FROM jbsupplier WHERE city IN
(SELECT id FROM jbcity WHERE name = "Los Angeles"));


DELETE FROM jbsupplier
WHERE city IN (SELECT id FROM jbcity WHERE name = "Los Angeles");

select * from jbsupplier where city in (select id from jbcity where name = "Los Angeles");

/*
Query result:
mysql> DELETE FROM jbsale 
    -> WHERE item IN (SELECT id FROM jbitem WHERE supplier IN
    -> (SELECT id FROM jbsupplier WHERE city IN
    -> (SELECT id FROM jbcity WHERE name = "Los Angeles")));
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> DELETE FROM jbitem WHERE supplier IN
    -> (SELECT id FROM jbsupplier WHERE city IN
    -> (SELECT id FROM jbcity WHERE name = "Los Angeles"));
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> DELETE FROM new_jbitem WHERE supplier IN 
    -> (SELECT id FROM jbsupplier WHERE city IN
    -> (SELECT id FROM jbcity WHERE name = "Los Angeles"));
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> DELETE FROM jbsupply WHERE supplier IN
    -> (SELECT id FROM jbsupplier WHERE city IN
    -> (SELECT id FROM jbcity WHERE name = "Los Angeles"));
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> 
mysql> DELETE FROM jbsupplier
    -> WHERE city IN (SELECT id FROM jbcity WHERE name = "Los Angeles");
Query OK, 0 rows affected (0.00 sec)

mysql> select * from jbsupplier where city in (select id from jbcity where name = "Los Angeles");
Empty set (0.00 sec)
*/

/*b) Explain what you did and why.*/
/*We cannot delete suppliers directly at first,
-- Because there is foreign key (supplier) references jbsupplier (id) in table jbitem
-- Therefore, we need to delete the tuple in jbitem first.

-- When deleting the tuple in jbitem, it cannot be deleted.
-- Because in table jbsale foreign key (item) references jbitem (id)

-- Therefore, we need to delete the tuple in jbsale first.

-- Here are our steps:
-- 1.	Delete related tuples from the jbsale table.
-- 2.	Delete related tuples from the jbitem table.
-- 3.	Delete related tuples from the newly added table, new_jbitem.
-- 4.	Finally, delete the suppliers in Los Angeles from the jbsupplier table.

-- By first removing the tuples related to suppliers, we ensure that no records related to these suppliers exist, so these suppliers can be safely removed*/


/*Question 20:  Drop and redefine the jbsale_supply view to also consider suppliers
that have delivered items that have never been sold.*/
CREATE VIEW jbsale_supply AS
SELECT P.name AS suppliers, COUNT(S.item) AS item_sold
-- supply
FROM jbsupplier AS P JOIN jbitem I on P.id = I.supplier 
-- sold
LEFT JOIN jbsale AS S on I.id = S.item
GROUP BY P.name;


SELECT * FROM jbsale_supply;

/*
Query result:
+--------------+-----------+
| suppliers    | item_sold |
+--------------+-----------+
| Cannon       |         2 |
| Fisher-Price |         0 |
| Levi-Strauss |         1 |
| Playskool    |         1 |
| White Stag   |         2 |
| Whitman's    |         1 |
+--------------+-----------+
6 rows in set (0.00 sec)
*/
