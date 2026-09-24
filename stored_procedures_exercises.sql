-- 1.
DELIMITER //

CREATE PROCEDURE GetUserOrders(IN input_user_id INT)
BEGIN
SELECT Store_Order.order_id, Store_Order.order_date, Order_Status.status_name
FROM book_store.Store_Order
INNER JOIN book_store.Order_Status
ON Store_Order.status_id = Order_Status.status_id
WHERE Store_Order.user_id = input_user_id;
END //

DELIMITER ;
CALL GetUserOrders(1);

-- 2.
DELIMITER //

CREATE PROCEDURE CountUserOrders(IN input_user_id INT, OUT orders_amount INT)
BEGIN
SET orders_amount = ( SELECT COUNT(*)
FROM book_store.Store_Order
WHERE Store_Order.user_id = input_user_id );
END //

DELIMITER ;
CALL CountUserOrders(1, @ordersIdOne);
SELECT @ordersIdOne;

-- 3.
DELIMITER //

CREATE PROCEDURE GetProductUnitsSold(IN input_product_id INT, OUT times_ordered INT)
BEGIN
SET times_ordered = (SELECT COALESCE(SUM(Ordered_Item.quantity), 0)
					 FROM book_store.Ordered_Item
                     WHERE Ordered_Item.product_id = input_product_id);
END //

DELIMITER ;

CALL GetProductUnitsSold(1, @timesOrderedIdOne);
SELECT @timesOrderedIdOne;

-- 4.

DELIMITER //

CREATE PROCEDURE CalculateOrderTotal(IN input_order_id INT, OUT total DECIMAL(7,2))
BEGIN
SET total = (SELECT COALESCE(SUM(Catalogue.unit_price * Ordered_Item.quantity), 0)
			 FROM book_store.Catalogue
             INNER JOIN book_store.Ordered_Item
             ON Catalogue.product_id = Ordered_Item.product_id
		     WHERE Ordered_Item.order_id = input_order_id);
END //

DELIMITER ;

CALL CalculateOrderTotal(1, @totalForIdOne);
SELECT @totalForIdOne;

-- 5.
DELIMITER //

CREATE PROCEDURE GetHighSpendingCustomers(IN min_amount DECIMAL(7,2))
BEGIN
SELECT Store_User.user_id,
	   CONCAT(Store_User.first_name, ' ', Store_User.last_name) AS full_name,
       SUM(Catalogue.unit_price * Ordered_Item.quantity) AS total_spent
FROM book_store.Store_User
INNER JOIN book_store.Store_Order
ON Store_Order.user_id = Store_User.user_id
INNER JOIN book_store.Ordered_Item
ON Store_Order.order_id = Ordered_Item.order_id
INNER JOIN book_store.Catalogue
ON Ordered_Item.product_id = Catalogue.product_id
GROUP BY Store_User.user_id
HAVING total_spent > min_amount
ORDER BY total_spent DESC;
END //

DELIMITER ;

CALL GetHighSpendingCustomers(50);

-- 6.

DELIMITER //

CREATE PROCEDURE GetPopularProducts(IN min_sold_amount INT)
BEGIN
SELECT Catalogue.product_name, Product_Category.category_name,
       SUM(Ordered_Item.quantity) AS total_sold_quantity
FROM book_store.Catalogue
INNER JOIN book_store.Product_Category
ON Catalogue.category_id = Product_Category.category_id
INNER JOIN book_store.Ordered_Item
ON Catalogue.product_id = Ordered_Item.product_id 
GROUP BY Catalogue.product_id, Catalogue.product_name
HAVING total_sold_quantity >= min_sold_amount
ORDER BY total_sold_quantity DESC;
END //

DELIMITER ;

CALL GetPopularProducts(2);

-- 7.

DELIMITER //

CREATE PROCEDURE IncreaseProductStock(IN input_product_id INT UNSIGNED, IN input_quantity INT UNSIGNED)
BEGIN
UPDATE book_store.Catalogue
SET available_stock = available_stock + input_quantity
WHERE Catalogue.product_id = input_product_id;
END //

DELIMITER ;

CALL IncreaseProductStock(6, 5);

-- 7.
DELIMITER //
CREATE PROCEDURE ApplyDiscount(INOUT price DECIMAL(7,2), IN discount SMALLINT UNSIGNED)
BEGIN
IF discount BETWEEN 0 AND 100
THEN SET price = price - (discount / 100 * price);
END IF;
END //

DELIMITER ;

SET @price = 100;
CALL ApplyDiscount(@price, 10);
SELECT @price;
