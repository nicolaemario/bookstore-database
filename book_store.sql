-- CREATE SCHEMA IF NOT EXISTS / DROP SCHEMA IF EXISTS
DROP SCHEMA IF EXISTS book_store;
CREATE SCHEMA IF NOT EXISTS book_store;

-- DROP TABLES IF EXIST
-- DROP Complaint-Related Tables
DROP TABLE IF EXISTS book_store.Complaint;
DROP TABLE IF EXISTS book_store.Complaint_Type;
DROP TABLE IF EXISTS book_store.Complaint_Status;

-- DROP Order-Related Tables
DROP TABLE IF EXISTS book_store.Ordered_Item;
DROP TABLE IF EXISTS book_store.Store_Order;
DROP TABLE IF EXISTS book_store.Order_Payment;
DROP TABLE IF EXISTS book_store.Order_Status;

-- DROP User-Related AND Permission-Related TABLES
DROP TABLE IF EXISTS book_store.Store_User;
DROP TABLE IF EXISTS book_store.Role_Permission;
DROP TABLE IF EXISTS book_store.User_Role;
DROP TABLE IF EXISTS book_store.Permission;

-- DROP Product-Related Tables
DROP TABLE IF EXISTS book_store.Book_Details;
DROP TABLE IF EXISTS book_store.Book_Genre;
DROP TABLE IF EXISTS book_store.Audio_Details;
DROP TABLE IF EXISTS book_store.Audio_Genre;
DROP TABLE IF EXISTS book_store.Catalogue;
DROP TABLE IF EXISTS book_store.Product_Category;

-- User-Related AND Role-Related Tables
CREATE TABLE IF NOT EXISTS book_store.User_Role (
	role_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- UP TO 255 roles
    role_name VARCHAR(50),
    description_text VARCHAR(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS book_store.Permission (
	permission_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- Up to +65,535 permissions
    permission_name VARCHAR(50) NOT NULL,
    description_text VARCHAR(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS book_store.Role_Permission (
	role_id TINYINT UNSIGNED, -- Up to +255 roles, foreign key
    permission_id SMALLINT UNSIGNED, -- UP TO +65,534 permissions, foreign key
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id)
    REFERENCES book_store.User_Role(role_id)
    ON DELETE CASCADE,
    FOREIGN KEY (permission_id)
    REFERENCES book_store.Permission(permission_id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS book_store.Store_User(
	user_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role_id TINYINT UNSIGNED, -- Up to +255 roles,  default role = User, foreign key
    country CHAR(2) NOT NULL,
    state VARCHAR(50) DEFAULT NULL,
    zip_code VARCHAR(10) DEFAULT NULL,
    city VARCHAR(50) DEFAULT NULL,
    street VARCHAR(50) DEFAULT NULL,
    apt VARCHAR(50) DEFAULT NULL,
    phone_number VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    FOREIGN KEY (role_id)
    REFERENCES book_store.User_Role(role_id)
    ON DELETE SET NULL -- More secure; we don't lose data, it just gives them no permission until everything is solved.
);

-- Product-Related Tables
CREATE TABLE IF NOT EXISTS book_store.Product_Category (
	category_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- Up to +255 big categories; can scale to a 'Product_Subcategory' Entity in the future.
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS book_store.Catalogue (
	product_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- Up to ~+4.2B products
    product_name VARCHAR(255) NOT NULL, -- Length accounts for lenghtier names
    category_id TINYINT UNSIGNED, -- Up to +255 big categories, foreign key
    available_stock INT UNSIGNED, -- 0 - ~4.2B stock availability
    unit_price DECIMAL(7, 2) NOT NULL, -- $0.00 - $99,999.99 price range
    weight INT NOT NULL, -- in grams
    FOREIGN KEY (category_id)
    REFERENCES book_store.Product_Category(category_id)
    ON DELETE SET NULL -- So that no data is lost even if it somehow gets deleted
);

CREATE TABLE IF NOT EXISTS book_store.Book_Genre (
	book_genre_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
	book_genre_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS book_store.Book_Details (
	product_id INT UNSIGNED PRIMARY KEY, -- foreign key
    author VARCHAR(100) NOT NULL, -- Length accounts in case for multiple authors AND different languages
    book_genre_id SMALLINT UNSIGNED, -- UP TO +65,534 genres, foreign key
    description_text VARCHAR(4000) NOT NULL, -- UP TO 4,000 characters (1,2 or 4 bytes per character)
    FOREIGN KEY (product_id)
    REFERENCES book_store.Catalogue(product_id)
    ON DELETE CASCADE,
    FOREIGN KEY (book_genre_id)
    REFERENCES book_store.Book_Genre(book_genre_id)
    ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS book_store.Audio_Genre (
	audio_genre_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    audio_genre_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS book_store.Audio_Details (
	product_id INT UNSIGNED PRIMARY KEY, -- foreign key
    artist VARCHAR(255) NOT NULL, -- Length accounts in case for multiple artists AND different languages
    audio_genre_id SMALLINT, -- Up to 65.534 distinct genres, foreign key 
    audio_year SMALLINT UNSIGNED, -- Up to 65,534 AD
    minutes SMALLINT UNSIGNED, -- Can convert to hours
    seconds TINYINT UNSIGNED,
    tempo SMALLINT UNSIGNED NOT NULL, -- in BPM; accounts for 255+ BPMs
    FOREIGN KEY (product_id)
    REFERENCES book_store.Catalogue(product_id)
    ON DELETE CASCADE,
    FOREIGN KEY (audio_genre_id)
    REFERENCES book_store.Audio_Genre(audio_genre_id)
    ON DELETE SET NULL
);

-- Order-Related Tables
CREATE TABLE IF NOT EXISTS book_store.Order_Payment (
	payment_type_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    payment_type VARCHAR(50) NOT NULL,
    description_text VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS book_store.Order_Status (
	status_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL,
    description_text VARCHAR(255) NOT NULL
);	

CREATE TABLE IF NOT EXISTS book_store.Store_Order (
	order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNSIGNED, -- foreign key
    payment_type_id TINYINT UNSIGNED, -- foreign key
    status_id TINYINT UNSIGNED, -- foreign key
    FOREIGN KEY (user_id)
    REFERENCES book_store.Store_User(user_id)
    ON DELETE CASCADE,
    FOREIGN KEY (payment_type_id)
    REFERENCES book_store.Order_Payment(payment_type_id)
    ON DELETE SET NULL, -- safer; only lost info: payment_type
    FOREIGN KEY (status_id)
    REFERENCES book_store.Order_Status(status_id)
    ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS book_store.Ordered_Item (
	order_id INT UNSIGNED, -- foreign key
    product_id INT UNSIGNED, -- foreign key
    quantity SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (order_id)
    REFERENCES book_store.Store_Order(order_id)
    ON DELETE CASCADE,
    FOREIGN KEY (product_id)
    REFERENCES book_store.Catalogue(product_id)
    ON DELETE CASCADE,
    PRIMARY KEY (order_id, product_id)
);

-- Complaint-Related Tables
CREATE TABLE IF NOT EXISTS book_store.Complaint_Type (
	complaint_type_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- Up to 65,534 complaint types
    complaint_name VARCHAR(100) NOT NULL,
    description_text VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS book_store.Complaint_Status (
	status_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- Up to 255 complaint statuses
    status_name VARCHAR(50) NOT NULL,
    description_text VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS book_store.Complaint (
	complaint_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- Up to ~4.2B complaints
    complaint_type_id SMALLINT UNSIGNED NOT NULL,
    user_id INT UNSIGNED, -- foreign key
    complaint_title VARCHAR(100) NOT NULL,
    complaint_message VARCHAR (500) NOT NULL, -- Max 500 characters;
    status_id TINYINT UNSIGNED, -- foreign key
	FOREIGN KEY (user_id)
    REFERENCES book_store.Store_User(user_id)
    ON DELETE SET NULL, -- The only lost piece of info -> user_id of the user who made the complaint
    FOREIGN KEY (complaint_type_id)
    REFERENCES book_store.Complaint_Type(complaint_type_id),
    FOREIGN KEY (status_id)
    REFERENCES Complaint_Status (status_id)
    ON DELETE SET NULL
);

-- POPULATING TABLES BY INSERTING DATA
-- INSERT 5 USER ROLES
INSERT INTO book_store.User_Role(role_name, description_text)
VALUES
('user', 'Role granted to every user account, which has access to basic site functionalities'),
('helper', 'Role for customer support employees, which has access to functionalities like Live Chat Support and Order Info'),
('admin', 'Role granted to the administration staff of the platform'), 
('author', 'Role granted to every author that has a partnership with the staff AND commercializes his works on the platform'),
('publisher', 'Role granted to special Publisher Accounts');

-- INSERT 10 PERMISSIONS
INSERT INTO book_store.Permission(permission_name, description_text)
VALUES
('add_to_cart', 'Permission to add items to cart'),
('order_cart', 'Permission to order user cart items'),
('add_review', 'Permission to add review to products'),
('write_complaint', 'Permission to write and send a complaint'),
('helper_check_live_chat_requests', 'Permission to check live_chat requests'),
('helper_answer_live_chat_requests', 'Permission to answer live chat request of users'),
('helper_check_complaints', 'Permission to check complaints'),
('helper_answer_complaints', 'Permission to answer complaints'),
('helper_check_order_by_id', 'Permission to check orders by order_id granted by complainers'),
('helper_check_order_by_awb', 'Permission to check orders by awb granted by complainers');

-- INSERT ALL POSSIBLE ROLE-PERMISSION ENTRIES FOR CURRENT ADDED ROLES AND PERMISSIONS
INSERT INTO book_store.Role_Permission(role_id, permission_id)
VALUES
(1, 1), (1,2), (1,3), (1,4), (2,1), (2,2), (2,3),
(2,4), (2,5), (2,6), (2,7), (2,8), (2,9), (2,10),
(3,1), (3,2), (3,3), (3,4), (3,5), (3,6), (3,7),
(3,8), (3,9), (3,10), (4,1), (4,2), (4,3), (4,4),
(4,5), (4,6), (4,7), (4,8), (4,9), (4,10), (5,1),
(5,2), (5,3), (5,4), (5,5), (5,6), (5,7), (5,8),
(5,9), (5,10);

-- INSERT 10 USERS
INSERT INTO book_store.Store_User(first_name, last_name, role_id, country, state,
                                   zip_code, city, street, apt, phone_number, email)
VALUES
('James', 'Peterson', 1, 'UK', 'England', 'SW1A 2AB', '11 Downing Street', 'London', NULL, '02071234567', 'jamespeterson2016@gmail.com'),
('Emma', 'Wilson', 1, 'UK', 'Scotland', 'EH1 1YZ', '24 Princes Street', 'Edinburgh', 'Apt 3', '01315551234', 'emma.wilson92@gmail.com'),
('Michael', 'Brown', 1, 'US', 'California', '90001', '567 Sunset Boulevard', 'Los Angeles', NULL, '2135556789', 'michael.brown88@yahoo.com'),
('Sophia', 'Johnson', 1, 'CA', 'Ontario', 'M5V 2T6', '89 King Street West', 'Toronto', 'Unit 12', '4165554321', 'sophia.johnson@gmail.com'),
('Daniel', 'Miller', 1, 'AU', 'Victoria', '3000', '15 Collins Street', 'Melbourne', NULL, '0398765432', 'daniel.miller77@hotmail.com'),
('Olivia', 'Taylor', 1, 'IE', 'Dublin', 'D02 X285', '7 OConnell Street', 'Dublin', NULL, '015554321', 'olivia.taylor95@gmail.com'),
('William', 'Anderson', 1, 'DE', 'Bavaria', '80331', '42 Marienplatz', 'Munich', 'Floor 2', '0891234567', 'will.anderson@gmail.com'),
('Ava', 'Thomas', 1, 'FR', 'Île-de-France', '75008', '18 Avenue des Champs-Élysées', 'Paris', NULL, '0145678912', 'ava.thomas91@yahoo.fr'),
('Benjamin', 'Moore', 2, 'NE', 'North Holland', '1012 WX', '63 Dam Square', 'Amsterdam', NULL, '0203456789', 'ben.moore84@gmail.com'),
('Charlotte', 'Martin', 1, 'ES', 'Madrid', '28013', '101 Gran Via', 'Madrid', 'Apartment 5B', '915123456', 'charlotte.martin@gmail.com');

-- INSERT 10 PRODUCT CATEGORIES
INSERT INTO book_store.Product_Category(category_name)
VALUES
('Book'), ('Manga'), ('Board Games'), ('CD, DVD & Vinyl'), ('Home & Deco'),
('Tea & Teaware'), ('Event Ticket'), ('Gourmet & Wine'), ('Collectibles'),
('Fashion');

-- INSERT 10 PRODUCTS
INSERT INTO book_store.Catalogue(product_name, category_id, available_stock, unit_price, weight)
VALUES 
('Meditations', 1, 999, 19.99, 342),
('The 48 Laws Of Power', 1, 800, 39.99, 675),
('Attack on Titan', 2, 100, 13.86, 305),
('Nocturnes (Complete Recording) (Reissue) (2 LP)', 4, 50, 41.76, 465),
('The Eminem Show', 4, 100, 15.99, 164),
('Concert Tudor Gheorghe DIASPORA', 7, 870, 31.99, 0),
('Marvel Legends Series Dogpool and Deadpool, Collectible 6-Inch Action Figure', 9, 150, 29.99, 580),
('Naruto Shippuden - Naruto Uzumaki Collectible Figurine', 9, 100, 24.96, 495),
('M401 Orange Dream', 6, 99, 4.99, 50),
('Death Note Old English L Anime T-Shirt', 10, 99, 26.57, 155);

-- INSERT 12 BOOK GENRES
INSERT INTO book_store.Book_Genre(book_genre_name)
VALUES
('Romance'), ('Fantasy'), ('Science Fiction'), ('Mystery'), ('Thriller & Suspense'),
('History'), ('Historical Fiction'), ('Action & Adventure'), ('Horror'), ('Self Help'),
('Philosophy'), ('Biography');

-- INSERT CURRENT POSSIBLE BOOK DETAILS FOR PRODUCTS WITH ID 1 (Book Category ID)
INSERT INTO book_store.Book_Details(product_id, author, book_genre_id, description_text)
VALUES
(1, 'Marcus Aurelius', 12, 'A timeless guide to Stoic philosophy, Meditations by Marcus Aurelius offers invaluable insights into life, virtue,
							and resilience. This influential work offers a window into the mind of a Stoic philosopher-king as he reflects on
							the nature of the universe, the meaning of life, and the virtues that lead to a fulfilling existence.
                            This inspirational read is a must-have for anyone seeking personal growth and enlightenment.'),
(2, 'Robert Greene', 10, 'THE MILLION COPY INTERNATIONAL BESTSELLER
						 ''Sun Tzu better watch his back'' - New York Magazine
                         ''If power is your ultimate goal, this is the book you need'' - The Times
                         ''At last, the book to help you scheme your way into the upper echelons of power'' - Daily Express Amoral.
						 Cunning, ruthless, and instructive, this piercing work distils three thousand years of the history of power into
                         forty-eight well-explicated laws. As attention-grabbing in its design as it is in its content, this bold volume outlines
                         the laws of power in their unvarnished essence, synthesizing the philosophies of Machiavelli, Sun-tzu,
                         Carl von Clausewitz, and other great thinkers. Some laws require prudence ("Law 1: Never Outshine the Master"),
                         some stealth ("Law 3: Conceal Your Intentions"), and some the total absence of mercy
                         ("Law 15: Crush Your Enemy Totally"), but like it or not, all have applications in real-life situations.');

-- INSERT 11 AUDIO GENRES
INSERT INTO book_store.Audio_Genre(audio_genre_name)
VALUES
('Classic Rock'), ('Jazz'), ('Classical'), ('Live Concert & Music Videos'),
('Tango'), ('Music Documentaries'), ('Audio-Only (DVD-A/Concert Films)'), 
('Electronic & Dance'), ('Blues & Soul'), ('Indie Rock & Alternative'),
('Hip-Hop');

-- INSERT CURRENT POSSIBLE AUDIO  DETAILS FOR PRODUCTS WITH ID 4 (CD, DVD & Vinyl Category ID)
INSERT INTO book_store.Audio_Details(product_id, artist, audio_genre_id, audio_year, minutes, seconds, tempo)
VALUES
(4, 'Frédéric Chopin, Alain Planes', 3, 2021, 105, 43, 0), -- If tempo = 0 don't show in front end, because there are multiple pieces
(5, 'Eminem', 11, 2002, 77, 30, 0);

-- INSERT 5 PAYMENT METHODS
INSERT INTO book_store.Order_Payment(payment_type, description_text)
VALUES 
('cash_on_delivery', 'Pay when the order arrives right at your front door'),
('credit_card', 'Secured online payment with your personal credit card'),
('google_pay', 'Pay with your Google Pay Wallet safely'),
('apple_pay', 'Pay with your Apple Pay Wallet safely'),
('bank_transfer', 'Direct account-to-account safe payment');

-- INSERT 7 ORDER STATUSES 
INSERT INTO book_store.Order_Status(status_name, description_text)
VALUES
('order_placed', 'Order has been placed and now awaits shipping'),
('order_shipped', 'Package has been shipped to a shipping carrier'),
('order_out_for_delivery', 'Package has reached the local carrier facility and is scheduled for final delivery'),
('order_delivered', 'The carrier has successfully dropped off the package'),
('order_canceled', 'Order has been canceled by the customer or the store and will no longer be delivered'),
('order_completed', 'Order has been completed.'),
('order_refunded', 'Order payment amount has been successfully refunded to the customer');

-- INSERT 10 ORDERS
INSERT INTO book_store.Store_Order(order_date, user_id, payment_type_id, status_id)
VALUES 
('2026-04-02 11:32:16', 1, 2, 6),
('2026-04-03 14:13:43', 2, 3, 5),
('2026-04-13 06:34:11', 1, 2, 6),
('2026-04-28 23:12:06', 3, 1, 6),
('2026-04-30 08:00:03', 6, 3, 6),
('2026-05-01 00:45:39', 5, 2, 6),
('2026-05-26 21:05:04', 1, 4, 6),
('2026-05-28 23:12:07', 7, 1, 6),
('2026-05-30 16:09:37', 5, 2, 6),
('2026-06-04 18:09:00', 4, 2, 3);


-- INSERT AT LEAST 1 ORDERED ITEM FOR EACH ORDER
INSERT INTO book_store.Ordered_Item(order_id, product_id, quantity)
VALUES (1, 2, 1), (1, 1, 1),
	   (2, 4, 1), (3, 7, 2),
	   (4, 5, 1), (5, 1, 1),
       (6, 3, 1), (7, 4, 2),
       (8, 3, 1), (9, 1, 2),
       (9, 2, 1), (10, 2, 1);

-- INSERT 5 COMPLAINT TYPES
INSERT INTO book_store.Complaint_Type(complaint_name, description_text)
VALUES
('delivery_issue', 'Complaint type related to any delivery issue faced by customers'),
('product_issue', 'Complaint type related to any product issue faced by customers'),
('staff_issue', 'Complaint type related to any issue faced by customers from staff'),
('refund_issue', 'Complaint type related to any refund issue faced by customers'),
('other_issue', 'Complaint type related to any other issues faced by customers');

INSERT INTO book_store.Complaint_Status(status_name, description_text)
VALUES
('unanswered', 'Complaint status type for unanswered complaints'),
('open', 'Complaint status type for complaints which are open to discussion'),
('solved', 'Complaint status type for complaints whose problem got solved');

INSERT INTO book_store.Complaint(complaint_type_id, user_id, complaint_title, complaint_message, status_id)
VALUES
(1, 2, 'Book didn''t arrive', 'Hello, the title says it all. If it won''t come, I will just cancel the order. Thank you!', 3),
(2, 3, 'Damaged book received', 'The book arrived with several torn pages and a damaged cover. I would like a replacement, please.', 3),
(3, 4, 'Rude staff behavior', 'One of the staff members was very unhelpful and spoke to me disrespectfully when I asked for assistance.', 3),
(4, 5, 'Refund not processed','I returned my order two weeks ago, but I have not received the refund yet. Could you check the status?', 2),
(5, 6, 'Website payment error','I experienced an error during checkout and the payment was charged twice. Please investigate this issue.', 2);

-- QUERIES
-- BASIC SELECT ALL QUERIES
SELECT * FROM book_store.Store_User;
SELECT * FROM book_store.Store_Order;
SELECT * FROM book_store.Ordered_Item;
SELECT * FROM book_store.Order_Payment;
SELECT * FROM book_store.Order_Status;
SELECT * FROM book_store.User_Role;
SELECT * FROM book_store.Permission;
SELECT * FROM book_store.Role_Permission;
SELECT * FROM book_store.Catalogue;
SELECT * FROM book_store.Book_Details;
SELECT * FROM book_store.Book_Genre;
SELECT * FROM book_store.Audio_Details;
SELECT * FROM book_store.Audio_Genre;
SELECT * FROM book_store.Store_User;
SELECT * FROM book_store.Complaint;
SELECT * FROM book_store.Complaint_Type;
SELECT * FROM book_store.Complaint_Status;

-- OTHER BASIC QUERIES
-- SEE THE USER ID, FULL NAME, ORDER ID, AND COMPLAINT ID FROM PEOPLE WHO CANCELED THEIR ORDER AND COMPLAINED (COMPLAINS CAN HAVE VARIOUS
--                                                                                                             REASONS BESIDE THAT SPECIFIC 
--                                                                                                             ORDER)
SELECT book_store.Store_User.user_id, CONCAT(book_store.Store_User.first_name, ' ', book_store.Store_User.last_Name) AS full_name,
	   book_store.Store_Order.order_id, book_store.Complaint.complaint_id
FROM book_store.Store_User
JOIN book_store.Complaint
ON book_store.Store_User.user_id = book_store.Complaint.user_id
JOIN book_store.Store_Order
ON book_store.Store_User.user_id = book_store.Store_Order.user_id
WHERE book_store.Store_Order.status_id = 5;

-- SELECT ALL ORDERS WHICH HAVE MORE THAN ONE PRODUCT ORDERED AND SHOW THE USER ID, FULL NAME, ORDER_ID, AND NUMBER OF PRODUCTS ORDERED
SELECT DISTINCT book_store.Store_User.user_id, CONCAT(book_store.Store_User.first_name, ' ', book_store.Store_User.last_name) AS full_name,
	            book_store.Store_Order.order_id, SUM(book_store.Ordered_Item.quantity) AS ordered_quantity
FROM book_store.Store_User
JOIN book_store.Store_Order
ON book_store.Store_User.user_id = book_store.Store_Order.user_id
JOIN book_store.Ordered_Item
ON book_store.Store_Order.order_id = book_store.Ordered_Item.order_id
WHERE book_store.Ordered_Item.quantity > 1
GROUP BY book_store.Store_Order.order_id;

-- SHOW ALL PRODUCTS BY THEIR TOTAL SOLD UNITS FROM HIGHEST ON TOP TO LOWEST ON THE BOTTOM
SELECT DISTINCT book_store.Catalogue.product_id, book_store.Catalogue.product_name, book_store.Product_Category.category_name,
			    SUM(book_store.Ordered_Item.quantity) AS units_sold
FROM book_store.Catalogue
JOIN book_store.Product_Category
ON book_store.Catalogue.category_id = book_store.Product_Category.category_id
JOIN book_store.Ordered_Item
ON book_store.Catalogue.product_id = book_store.Ordered_Item.product_id
GROUP BY book_store.Catalogue.product_id
ORDER BY units_sold DESC;

-- SHOW HOW MANY UNITS EVERY CATEGORY SOLD IN DESCENDENT ORDER

SELECT book_store.Product_Category.category_id, book_store.Product_Category.category_name,
       SUM(book_store.Ordered_Item.quantity) AS units_sold
FROM book_store.Product_Category
JOIN book_store.Catalogue
ON book_store.Product_Category.category_id = book_store.Catalogue.category_id
JOIN book_store.Ordered_Item
ON book_store.Catalogue.product_id = book_store.Ordered_Item.product_id
GROUP BY book_store.Product_Category.category_id
ORDER BY units_sold DESC;
