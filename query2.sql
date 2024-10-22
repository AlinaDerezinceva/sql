--1. Первые 3 клиента, купившие товаров на максимальную сумму в диапазоне дат
SELECT c.customer_name, SUM(pi.product_count * pi.product_price) AS res FROM customers AS c
JOIN purchases AS p ON p.customer_id = c.customer_id
JOIN purchase_items AS pi ON pi.purchase_id = p.purchase_id
WHERE p.purchase_date BETWEEN 1619764121 AND 1621217801
GROUP BY c.customer_name ORDER BY res DESC
LIMIT 3

--2. Список первых 3 клиентов, купивших максимальное количество товара в заданном диапазоне дат
SELECT c.customer_name, SUM(pi.product_count) AS res FROM customers AS c
JOIN purchases AS p ON p.customer_id = c.customer_id
JOIN purchase_items AS pi ON pi.purchase_id = p.purchase_id
WHERE p.purchase_date BETWEEN 1614088008 AND 1621217801
GROUP BY c.customer_name ORDER BY res DESC
LIMIT 3

--3. Товар, который покупали чаще всего в заданном диапазоне дат
SELECT pi.product_id, SUM(pi.product_count) AS total_count FROM purchases AS p
JOIN purchase_items AS pi ON pi.purchase_id = p.purchase_id
WHERE p.purchase_date BETWEEN 1619764121 AND 1621217801
GROUP BY pi.product_id
ORDER BY total_count DESC LIMIT 1

--4. Товар, который покупали чаще всего в заданном диапазоне дат по филиалам
SELECT s.store_name, pi.product_id, SUM(pi.product_count) AS total_count 
FROM purchases AS p
JOIN purchase_items AS pi ON pi.purchase_id = p.purchase_id
JOIN stores AS s ON s.store_id = p.store_id
WHERE p.purchase_date BETWEEN 1619764121 AND 1621217801
GROUP BY s.store_name, pi.product_id
ORDER BY total_count DESC

--5. Средний чек в диапазоне дат
SELECT AVG(pi.product_count * pi.product_price) AS average_check
FROM purchases AS p
JOIN purchase_items AS pi ON pi.purchase_id = p.purchase_id
WHERE p.purchase_date BETWEEN 1619764121 AND 1621217801

--6. Средний чек в диапазоне дат по филиалам
SELECT s.store_name, AVG(pi.product_count * pi.product_price) AS average_check
FROM purchases AS p
JOIN purchase_items AS pi ON pi.purchase_id = p.purchase_id
JOIN stores AS s ON s.store_id = p.store_id
WHERE p.purchase_date BETWEEN 1619764121 AND 1621217801
GROUP BY s.store_name

--7. Суммарная стоимость проданных товаров каждого филиала в диапазоне дат
SELECT s.store_name, SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases AS p
JOIN purchase_items AS pi ON p.purchase_id = pi.purchase_id
JOIN stores AS s ON p.store_id = s.store_id
WHERE p.purchase_date BETWEEN 1619764121  AND 1621217801
GROUP BY s.store_name

--8. Суммарная стоимость проданных товаров в диапазоне дат
SELECT SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases AS p
JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
WHERE p.purchase_date BETWEEN 1619764121 AND 1621217801

--9. Список филиалов по убыванию объема продаж (суммарная стоимость) до заданной даты
SELECT s.store_name, SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases AS p
JOIN purchase_items AS pi ON p.purchase_id = pi.purchase_id
JOIN stores AS s ON p.store_id = s.store_id
WHERE p.purchase_date < 1621217801  
GROUP BY s.store_name
ORDER BY total_sales DESC

--10. Список филиалов по убыванию количества проданного товара до заданной даты
SELECT s.store_name, SUM(pi.product_count) AS total_products
FROM purchases AS p
JOIN purchase_items AS pi ON p.purchase_id = pi.purchase_id
JOIN stores AS s ON p.store_id = s.store_id
WHERE p.purchase_date < 1621217801 
GROUP BY s.store_name
ORDER BY total_products DESC

--11. Список товаров с указанием проданного количества товара в каждом магазине до заданной даты
SELECT s.store_name, p.product_name, SUM(pi.product_count) AS total_sold
FROM purchases AS pur
JOIN purchase_items pi ON pur.purchase_id = pi.purchase_id
JOIN products AS p ON pi.product_id = p.product_id
JOIN stores AS s ON pur.store_id = s.store_id
WHERE pur.purchase_date < 1621217801 
GROUP BY s.store_name, p.product_name
ORDER BY s.store_name, p.product_name

--12. Список товаров, проданных в заданном филиале до заданной даты
SELECT p.product_name, SUM(pi.product_count) AS total_sold
FROM purchases AS pur
JOIN purchase_items AS pi ON pur.purchase_id = pi.purchase_id
JOIN products AS p ON pi.product_id = p.product_id
WHERE pur.store_id = 3 AND pur.purchase_date < 1621217801 
GROUP BY p.product_name
ORDER BY total_sold DESC

--13. Список клиентов, покупавших любой товар в заданном магазине до заданной даты
SELECT DISTINCT c.customer_name
FROM purchases AS p
JOIN customers AS c ON p.customer_id = c.customer_id
WHERE p.store_id = 3 AND p.purchase_date <  1621217801 

--14. Список клиентов, покупавших любой товар в двух магазинах сети
SELECT c.customer_name FROM purchases AS p
JOIN customers AS c ON p.customer_id = c.customer_id
GROUP BY c.customer_name HAVING COUNT(DISTINCT p.store_id) >= 2

--15. Список клиентов, покупавших любой товар во всех магазинах сети
SELECT c.customer_name FROM purchases AS p
JOIN customers AS c ON p.customer_id = c.customer_id
JOIN stores AS s ON p.store_id = s.store_id
GROUP BY c.customer_name HAVING COUNT(DISTINCT p.store_id) = (SELECT COUNT(*) FROM stores)

--16. Количество товара каждой категории, проданных в филиале до заданной даты
SELECT cat.category_name, SUM(pi.product_count) AS total_sold
FROM purchases AS pur
JOIN purchase_items AS pi ON pur.purchase_id = pi.purchase_id
JOIN products AS p ON pi.product_id = p.product_id
JOIN categories AS cat ON p.category_id = cat.category_id
WHERE pur.store_id = 3 AND pur.purchase_date < 1621217801 
GROUP BY cat.category_name

--17. Количество товара каждой категории, проданных во всех филиалах до заданной даты
SELECT cat.category_name, SUM(pi.product_count) AS total_sold
FROM purchases AS pur
JOIN purchase_items AS pi ON pur.purchase_id = pi.purchase_id
JOIN products AS p ON pi.product_id = p.product_id
JOIN categories AS cat ON p.category_id = cat.category_id
WHERE pur.purchase_date < 1621217801 
GROUP BY cat.category_name

--18. Суммарная стоимость товаров по филиалам на заданную дату
SELECT s.store_name, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries AS d
JOIN stores AS s ON d.store_id = s.store_id
JOIN price_change AS pc ON d.product_id = pc.product_id
WHERE d.delivery_date <= 1621217801 
GROUP BY s.store_name

--19. Суммарная стоимость товаров во всех филиалах на заданную дату
SELECT SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries AS d
JOIN price_change AS pc ON d.product_id = pc.product_id
WHERE d.delivery_date <= 1621217801

--20. Количество товаров в каждом филиале на заданную дату
SELECT s.store_name, SUM(d.product_count) AS total_quantity
FROM deliveries AS d
JOIN stores AS s ON d.store_id = s.store_id
WHERE d.delivery_date <= 1621217801  
GROUP BY s.store_name

--21. Какого товара меньше всего осталось в каждом из филиалов на заданную дату?
SELECT s.store_name, SUM(d.product_count) AS total_products
FROM deliveries AS d
JOIN stores AS s ON d.store_id = s.store_id
WHERE d.delivery_date <= 1621217801
GROUP BY s.store_name

--22. Какого товара больше всего осталось в каждом из филиалов на заданную дату?
SELECT s.store_name, p.product_name, d.product_count
FROM deliveries AS d
JOIN products AS p ON d.product_id = p.product_id
JOIN stores AS s ON d.store_id = s.store_id
WHERE d.delivery_date <= 1621217801
ORDER BY s.store_name, d.product_count DESC LIMIT 1

--23. Количество товаров каждого наименования во всех филиалах на заданную дату
SELECT p.product_name, SUM(d.product_count) AS total_count
FROM deliveries AS d
JOIN products AS p ON d.product_id = p.product_id
WHERE d.delivery_date <= 1621217801
GROUP BY p.product_name

--24. Остатки товаров каждого наименования в филиале на заданную дату
SELECT p.product_name, SUM(d.product_count) AS total_count
FROM deliveries AS d
JOIN products AS p ON d.product_id = p.product_id
WHERE d.store_id = 3 AND d.delivery_date <= 1621217801
GROUP BY p.product_name

--25. Список пяти самых дешевых товаров в филиале на заданную дату
SELECT p.product_name, pc.new_price FROM price_change AS pc
JOIN products AS p ON pc.product_id = p.product_id
JOIN deliveries AS d ON d.product_id = p.product_id
WHERE d.store_id = 3  AND pc.date_price_change <= '2024.10.13'
ORDER BY pc.new_price ASC LIMIT 5

--26. Список пяти самых дорогих товаров в филиале на заданную дату
SELECT p.product_name, pc.new_price 
FROM price_change AS pc
JOIN products AS p ON pc.product_id = p.product_id
JOIN deliveries AS d ON d.product_id = p.product_id
WHERE d.store_id = 3 AND pc.date_price_change <= '2024.10.13'
ORDER BY pc.new_price DESC 
LIMIT 5

--27. Дата, в которую поступило товара на максимальную сумму в заданный филиал
SELECT d.delivery_date, SUM(d.product_count) AS total_count
FROM deliveries AS d
WHERE d.store_id = 3
GROUP BY d.delivery_date
ORDER BY total_count DESC LIMIT 1

--28. Суммарная стоимость поступивших товаров на каждую дату поступления в заданный филиал
SELECT d.delivery_date, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries AS d
JOIN price_change AS pc ON d.product_id = pc.product_id
WHERE d.store_id = 3
GROUP BY d.delivery_date
ORDER BY d.delivery_date

--29. Суммарная стоимость товаров каждого производителя в филиале на дату
SELECT m.manufacturer_name, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries AS d
JOIN products AS p ON d.product_id = p.product_id
JOIN manufacturers AS m ON p.manufacturer_id = m.manufacturer_id
JOIN price_change AS pc ON p.product_id = pc.product_id
WHERE d.store_id = 3
AND d.delivery_date <= 1621217801 
GROUP BY m.manufacturer_name

--30. Суммарное количество товаров каждого производителя в филиале на дату
SELECT m.manufacturer_name, SUM(d.product_count) AS total_quantity
FROM deliveries AS d
JOIN products AS p ON d.product_id = p.product_id
JOIN manufacturers AS m ON p.manufacturer_id = m.manufacturer_id
JOIN price_change AS pc ON p.product_id = pc.product_id
WHERE d.store_id = 3
AND d.delivery_date <= 1621217801
GROUP BY m.manufacturer_name

--31. Суммарное количество проданных товаров каждого производителя в филиале до заданной даты
SELECT m.manufacturer_name, SUM(pi.product_count) AS total_sold
FROM purchases AS pr
JOIN purchase_items AS pi ON pr.purchase_id = pi.purchase_id
JOIN products AS p ON pi.product_id = p.product_id
JOIN manufacturers AS m ON p.manufacturer_id = m.manufacturer_id
WHERE pr.store_id = 3
AND pr.purchase_date <= 1621217801
GROUP BY m.manufacturer_name

--32. Суммарная стоимость проданных товаров каждого производителя в филиале до заданной даты
SELECT m.manufacturer_name, SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases AS pr
JOIN purchase_items AS pi ON pr.purchase_id = pi.purchase_id
JOIN products AS p ON pi.product_id = p.product_id
JOIN manufacturers AS m ON p.manufacturer_id = m.manufacturer_id
WHERE pr.store_id = 3
AND pr.purchase_date <= 1621217801
GROUP BY m.manufacturer_name

--33. Суммарная стоимость проданных товаров каждого производителя во всех филиалах до заданной даты
SELECT m.manufacturer_name, SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases AS pr
JOIN purchase_items AS pi ON pr.purchase_id = pi.purchase_id
JOIN products AS p ON pi.product_id = p.product_id
JOIN manufacturers AS m ON p.manufacturer_id = m.manufacturer_id
WHERE pr.purchase_date <= 1621217801
GROUP BY m.manufacturer_name

--34. Суммарное количество проданных товаров каждого производителя во всех филиалах до заданной даты
SELECT m.manufacturer_name, SUM(pi.product_count) AS total_sold
FROM purchases AS pr
JOIN purchase_items AS pi ON pr.purchase_id = pi.purchase_id
JOIN products AS p ON pi.product_id = p.product_id
JOIN manufacturers AS m ON p.manufacturer_id = m.manufacturer_id
WHERE pr.purchase_date <= 1621217801
GROUP BY m.manufacturer_name

--35. Суммарное количество поступивших товаров каждого производителя во всех филиалах до заданной даты
SELECT m.manufacturer_name, SUM(d.product_count) AS total_delivered
FROM deliveries AS d
JOIN products AS p ON d.product_id = p.product_id
JOIN manufacturers AS m ON p.manufacturer_id = m.manufacturer_id
WHERE d.delivery_date <= 1621217801
GROUP BY m.manufacturer_name

--36. Суммарное количество поступивших товаров каждого производителя в филиал до заданной даты
SELECT m.manufacturer_name, SUM(d.product_count) AS total_delivered
FROM deliveries AS d
JOIN products AS p ON d.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
WHERE d.store_id = 3
AND d.delivery_date <= 1621217801
GROUP BY m.manufacturer_name

--37. Суммарная стоимость поступивших товаров каждого производителя в филиал до заданной даты
SELECT m.manufacturer_name, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
JOIN price_change pc ON p.product_id = pc.product_id
WHERE d.store_id = 3
AND d.delivery_date <= 1621217801
GROUP BY m.manufacturer_name

--38. Изменение суммарной стоимости товаров заданного производителя в филиале в диапазоне дат
SELECT to_timestamp(d.delivery_date) AS delivery_date, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries AS d
JOIN products AS p ON d.product_id = p.product_id
JOIN price_change AS pc ON d.product_id = pc.product_id
WHERE d.store_id = 2
AND p.manufacturer_id = 1
AND to_timestamp(d.delivery_date) BETWEEN '2023-10-13' AND '2024-10-13'  
AND pc.date_price_change <= to_timestamp(d.delivery_date)  
GROUP BY d.delivery_date
ORDER BY d.delivery_date








