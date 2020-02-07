-------------- 1
SELECT s.id,
       (
           SELECT p.name
           FROM products p
           WHERE p.id = s.product_id
       ),
       (
           SELECT m.name
           FROM managers m
           WHERE m.id = s.manager_id
       ),
       s.price * s.qty
FROM sales s;

-----------------2
SELECT m.name,
       (
           SELECT COUNT(*) FROM sales GROUP BY manager_id HAVING manager_id = m.id
       )
FROM managers m;

-----------------3
SELECT m.name, (SELECT sum(s.price * s.qty) FROM sales s WHERE s.manager_id = m.id)
FROM managers M;

---4
SELECT m.name,( SELECT sum(s.price * s.qty) FROM sales s WHERE s.product_id = m.id)
FROM products M;

---------------5
select m.id,
       m.name,
       (select sum(s.price * s.qty) from sales s where s.manager_id = m.id order by s.manager_id) sold
from managers m
order by sold desc
limit 3;

---------------6
select s.product_id,
       (
           select p.name
           from products p
           where p.id = s.product_id
       ) name,
       sum(qty) total
from sales s
group by name order by total desc limit 3;

---------------7
select s.product_id,
       (
           select p.name
           from products p
           where p.id = s.product_id
       ) name,
       sum(qty * price) total
from sales s
group by name order by total desc limit 3;

----------------8
SELECT m.name,  m.plan, (((SELECT sum(s.price * s.qty) FROM sales s WHERE s.manager_id = m.id))*100.0)/m.plan
                FROM managers m;

-----------------9
SELECT m.name, ifnull(st.total, 0)
from managers m
         LEFT JOIN (
    SELECT s.manager_id, count(s.manager_id) total
    FROM sales s
    GROUP BY s.manager_id
) st ON m.id = st.manager_id;