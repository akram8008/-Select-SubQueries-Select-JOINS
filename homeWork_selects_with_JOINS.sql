-------------- 1--------------------------------------------------------------------------------------------------
-- SELECT s.id,
--        (
--            SELECT p.name
--            FROM products p
--            WHERE p.id = s.product_id
--        ),
--        (
--            SELECT m.name
--            FROM managers m
--            WHERE m.id = s.manager_id
--        ),
--        s.price * s.qty
-- FROM sales s;

SELECT s.id, (s.price * s.qty) total, (m.name) managerName, (p.name) productName
FROM sales s
         JOIN managers m on s.manager_id = m.id
         JOIN products p ON s.product_id = p.id;

-----------------2------------------------------------------------------------------------------------------------
-- SELECT m.name,
--        (
--            SELECT COUNT(*)
--            FROM sales
--            GROUP BY manager_id
--            HAVING manager_id = m.id
--        )
-- FROM managers m;

SELECT m.name nameManager, IFNULL(s.totalSales, 0) total
FROM managers m
         LEFT JOIN (SELECT manager_id, COUNT(manager_id) totalSales FROM sales GROUP BY manager_id) s
                   ON m.id = s.manager_id;

-----------------3---------------------------------------------------------------------------------------------
-- SELECT m.name, (SELECT sum(s.price * s.qty) FROM sales s WHERE s.manager_id = m.id)
-- FROM managers M;

SELECT m.name nameManager, IFNULL(s.amountSales, 0) total
from managers m
         LEFT JOIN (SELECT manager_id, sum(sales.qty * sales.price) amountSales FROM sales GROUP BY manager_id) s
                   ON m.id = s.manager_id;

---4------------------------------------------------------------------------------------------------------------
-- SELECT m.name, (SELECT sum(s.price * s.qty) FROM sales s WHERE s.product_id = m.id)
-- FROM products M;


SELECT p.name, IFNULL(s.amountSales, 0) total
FROM products p
         LEFT JOIN (SELECT product_id, sum(sales.price * sales.qty) amountSales FROM sales GROUP BY product_id) s
                   ON p.id = s.product_id;

---------------5--------------------------------------------------------------------------------------------------
-- select m.id,
--        m.name,
--        (select sum(s.price * s.qty) from sales s where s.manager_id = m.id order by s.manager_id) sold
-- from managers m
-- order by sold desc
-- limit 3;

SELECT m.name, IFNULL(s.totalSales, 0) total
FROM managers m
         LEFT JOIN (SELECT manager_id, SUM(sales.qty * sales.price) totalSales FROM sales GROUP BY manager_id) s
                   ON m.id = s.manager_id
order by total desc
limit 3;


---------------6--------------------------------------------------------------------------------------------------
-- select s.product_id,
--        (
--            select p.name
--            from products p
--            where p.id = s.product_id
--        )        name,
--        sum(qty) total
-- from sales s
-- group by name
-- order by total desc
-- limit 3;

SELECT p.name, IFNULL(s.numberSales, 0) total
FROM products p
         LEFT JOIN (SELECT product_id, SUM(sales.qty) numberSales FROM sales GROUP BY product_id) s
                   ON p.id = s.product_id
ORDER BY total DESC
LIMIT 3;


---------------7--------------------------------------------------------------------------------------------------
-- select s.product_id,
--        (
--            select p.name
--            from products p
--            where p.id = s.product_id
--        )                name,
--        sum(qty * price) total
-- from sales s
-- group by name
-- order by total desc
-- limit 3;


SELECT p.name, IFNULL(s.amountSales, 0) total
FROM products p
         LEFT JOIN (SELECT product_id, sum(sales.qty * sales.price) amountSales FROM sales GROUP BY product_id) s
                   ON s.product_id = p.id
ORDER BY total DESC
LIMIT 3;

----------------8------------------------------------------------------------------------------------------------
-- SELECT m.name, m.plan, (((SELECT sum(s.price * s.qty) FROM sales s WHERE s.manager_id = m.id)) * 100.0) / m.plan
-- FROM managers m;

SELECT m.name NAME, IFNULL((s.amount * 100.0) / m.plan, 0) WorkInPercentage
FROM managers m
         LEFT JOIN (SELECT manager_id, SUM(sales.qty * sales.price) amount FROM sales GROUP BY manager_id) s
                   ON s.manager_id = m.id;


-----------------9------------------------------------------------------------------------------------------
select ifnull(m.unit, 'boss') unit, ifnull(sum(t.sum) * 100.0 / sum(m.plan), 0) percent
from managers m
         LEFT JOIN (SELECT s.manager_id, SUM(s.qty * s.price) sum FROM sales s Group By s.manager_id) t
                   on t.manager_id = m.id
GROUP BY m.unit;
