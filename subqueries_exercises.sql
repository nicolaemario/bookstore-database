-- 1.
-- Without subquery

SELECT Catalogue.product_name, Catalogue.unit_price,
       SUM(Ordered_Item.quantity) AS sold_units
FROM book_store.Catalogue
LEFT JOIN book_store.Ordered_Item
ON Catalogue.product_id = Ordered_Item.product_id
GROUP BY Catalogue.product_id;

-- With subuqery

SELECT Catalogue.product_name, Catalogue.unit_price,
	   (
		 SELECT SUM(quantity)
         FROM book_store.Ordered_Item
         WHERE Catalogue.product_id = Ordered_Item.product_id
         ) AS units_sold
FROM book_store.Catalogue;

-- 1.
-- Without subquery

SELECT Catalogue.product_name, Catalogue.unit_price,
       SUM(Ordered_Item.quantity) AS sold_units
FROM book_store.Catalogue
LEFT JOIN book_store.Ordered_Item
ON Catalogue.product_id = Ordered_Item.product_id
GROUP BY Catalogue.product_id;

-- With subuqery

SELECT Catalogue.product_name, Catalogue.unit_price,
	   (
		 SELECT SUM(quantity)
         FROM book_store.Ordered_Item
         WHERE Catalogue.product_id = Ordered_Item.product_id
         ) AS units_sold
FROM book_store.Catalogue;

-- 2. 
-- Without subquery

SELECT Store_User.first_name, Store_User.last_name, 
	   COUNT(Store_Order.user_id) AS total_orders
FROM book_store.Store_User
LEFT JOIN book_store.Store_Order
ON Store_User.user_id = Store_Order.user_id
GROUP BY Store_User.user_id;

-- With subquery

SELECT Store_User.first_name, Store_User.last_name,
	   (
	     SELECT COUNT(*)
         FROM Store_Order
         WHERE Store_User.user_id = Store_Order.user_id
         ) AS total
FROM Store_User;

-- 3.

SELECT Derived_Table.product_name, Derived_Table.unit_price
FROM (
		SELECT Catalogue.product_name, Catalogue.unit_price
        FROM book_store.Catalogue
        WHERE Catalogue.unit_price > (
										SELECT AVG(Catalogue.unit_price)
                                        FROM book_store.Catalogue
                                        )
	) AS Derived_Table;

-- 4.

SELECT Store_User.first_name, Store_User.last_name
FROM Store_User
WHERE Store_User.user_id IN (
								SELECT Store_Order.user_id
                                FROM book_store.Store_Order
                                GROUP BY Store_Order.user_id
                                HAVING COUNT(*) >= 1
                                );

-- 5.

SELECT Catalogue.product_name
FROM book_store.Catalogue
WHERE Catalogue.product_id NOT IN (
									SELECT Ordered_Item.product_id
                                    FROM book_store.Ordered_Item
                                    );
								
-- 6.

SELECT Store_User.first_name, Store_user.last_name,
	   (
			SELECT SUM(Ordered_Item.quantity)
            FROM book_store.Ordered_Item
            INNER JOIN book_store.Store_Order
            ON Ordered_Item.order_id = Store_Order.order_id 
            WHERE Store_Order.user_id = Store_User.user_id
		) AS total_quantity
FROM Store_User;

-- 7.

SELECT Catalogue.product_name, (
						SELECT AVG(Ordered_Item.quantity)
                        FROM book_store.Ordered_Item
                        JOIN book_store.Store_Order
                        ON Store_Order.order_id = Ordered_Item.order_id
						WHERE Ordered_Item.product_id = Catalogue.product_id) AS avg_quantity
FROM Catalogue;

-- 8. 

SELECT Product_Category.category_name, (
											SELECT AVG(Catalogue.unit_price)
                                            FROM book_store.Catalogue
                                            WHERE Product_Category.category_id = Catalogue.category_id		
									   ) AS avg_price
FROM book_store.Product_Category;

-- 9.

SELECT CONCAT(Store_User.first_name, " ", Store_User.last_name) AS full_name,
	   (
		SELECT MAX(Store_Order.order_date)
        FROM book_store.Store_Order
        WHERE Store_User.user_id = Store_Order.user_id
        ) AS last_order
FROM book_store.Store_User;

-- 10.

SELECT Catalogue.product_name, (
									SELECT MAX(quantity)
                                    FROM book_store.Ordered_Item
                                    WHERE Catalogue.product_id = Ordered_Item.product_id
								) AS max_order_quantity
FROM book_store.Catalogue;

-- 11.

SELECT CONCAT(Store_User.first_name, ' ', Store_User.last_name) AS full_name,
	   (
		SELECT SUM(Ordered_Item.quantity * Catalogue.unit_price)
        FROM book_store.Ordered_Item
        INNER JOIN book_store.Catalogue
        ON Ordered_Item.product_id = Catalogue.product_id
        INNER JOIN book_store.Store_Order
        ON Store_Order.order_id = Ordered_Item.order_id
        WHERE Store_User.user_id = Store_Order.user_id
       ) AS LTV
FROM book_store.Store_User;