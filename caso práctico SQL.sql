--Pasos a seguir

--a) Crear la base de datos con el archivo create_restaurant_db.sql

-- Archivo: "create_restaurant_db"

--b) Explorar la tabla “menu_items” para conocer los productos del menú.

select * from menu_items;

	--1.- Realizar consultas para contestar las siguientes preguntas:
	
	-- Encontrar el número de artículos en el menú.

select count (item_name)
from menu_items;
			
	--¿Cuál es el artículo menos caro y el más caro en el menú?

--Menos caro:

SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items);

-- Más caro: 

SELECT item_name, price
FROM menu_items
WHERE price = (SELECT Max(price) FROM menu_items);

		
	--¿Cuántos platos americanos hay en el menú?

SELECT COUNT (category)
FROM menu_items
WHERE category LIKE '%American%';
			
	--¿Cuál es el precio promedio de los platos?

select round(avg(price),2) as Precio_Promedio
from menu_items;
			
--c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados. 

select * from order_details;

	--1.- Realizar consultas para contestar las siguientes preguntas:
	
	--¿Cuántos pedidos únicos se realizaron en total?
	
select distinct (order_id)
from order_details;

select count(distinct order_id) as pedidos_unicos
from order_details;

	--¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?

select order_id, count (item_id) as total_item
from order_details
group by order_id
order by total_item desc
limit 5

	--¿Cuándo se realizó el primer pedido y el último pedido?

-- primer pedido:
select  min(order_date) as primer_pedido
from order_details;

-- último pedido:
select  max(order_date) as último_pedido
from order_details;

	--¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?

select count(distinct(order_id)) 
from order_details
where order_date between '2023-01-01'and '2023-01-05'
		
--d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.

	/*1.- Realizar un left join entre order_details y menu_items con el
	identificador item_id(tabla order_details) y menu_item_id(tabla menu_items).*/

select * from order_details;

select * from menu_items;

select o.order_details_id, o.order_id, o.order_date, o.order_time, o.item_id, m.menu_item_id, m.item_name, m.category, m.price
from order_details as o
left join menu_items as m
on o.item_id = m.menu_item_id
	
	/*e) Una vez que hayas explorado los datos en las tablas correspondientes y 
		respondido las preguntas planteadas, realiza un análisis adicional utilizando 
		este join entre las tablas.
		
	El objetivo es identificar 5 puntos clave que puedan ser de utilidad para los 	
	dueños del restaurante en el lanzamiento de su nuevo menú.
		
	Para ello, crea tus propias consultas y utiliza los resultados obtenidos para 
	llegar a estas conclusiones.*/

select * from order_details;

select * from menu_items;

/* Los 5 platillos más pedidos por los clientes son: 
1. Hamburger
2. Edamame 
3. Korean Beef Bowl
4. Cheeseburger
5. French Fries */

select m.item_name, count(o.item_id) as total_ordenes
from menu_items as m
left join order_details as o
on m.menu_item_id = o.item_id
group by m.item_name
order by total_ordenes desc
limit 5;

/* Los 5 platillos que representa la mayor venta $$ son
1. Korean Beef Bowl
2. Spaghetti & Meatballs
3. Tofu Pad Thai
4. Cheeseburger
5. Hamburger
*/

select m.item_name, m.price, 
count(o.item_id) as total_ordenes, 
m.price * count(o.item_id) as total_ventas
from menu_items as m
left join order_details as o 
on m.menu_item_id = o.item_id
group by m.item_name, m.price
order by total_ventas desc
limit 5;

-- lA Categoría con mayor venta $$ es American

select m.category, sum(m.price) as ventas_categoria
from menu_items as m
left join order_details as o
on m.menu_item_id = o.item_id
group by m.category
order by ventas_categoria asc
limit 5;

-- La categoría con menor venta $$ es Italian

select m.category, sum(m.price) as ventas_categoria
from menu_items as m
left join order_details as o
on m.menu_item_id = o.item_id
group by m.category
order by ventas_categoria desc
limit 5;

-- El ingreso total de ventas durante el primer trimestre 2023 fue de $159,217.90

select o.order_date,
count(o.item_id) as total_ordenes, 
m.price * count(o.item_id) as total_ventas
from menu_items as m
left join order_details as o 
on m.menu_item_id = o.item_id
group by o.order_date, m.price
order by total_ventas desc


SELECT 
SUM(total_ventas) AS total_ventas
FROM (
select o.order_date,
count(o.item_id) as total_ordenes, 
m.price * count(o.item_id) as total_ventas
from menu_items as m
left join order_details as o 
on m.menu_item_id = o.item_id
group by o.order_date, m.price
order by total_ventas desc	
) AS subconsulta;




