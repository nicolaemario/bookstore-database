# bookstore-database-project

### CONTENTS PAGE

#1. What is the project about?

#2. The Entity-Relationship Diagram

## **1. What is the project about?**

<ins>*Features*</ins>

The project features a database suited for an online book store.
It contains 3 files:
  - **Entity-Relationship DIAGRAM.png**
  - **book_store.sql**
  - **README.md**

<ins>*Every File Explained*</ins>

**The Entity-Relationship Diagram** contains the corresponding _entities_, _attributes_, and _relationships between entities_ such that it accurately resembles the created database schema.
This diagram enables us to better grasp the core architecture structure and, combined with the *README file*, understand the underlying reasons for each specific choice.

**The book_store.sql** file contains an implementation of the ER Diagram through using **MySQL** and **MySQL Workbench** technologies.
After implementing, there have been numerous entries added into the database tables.
It also features a few queries that are enough for the intention of this project.

**The README.md** file contains the documentation of this project, where every choice that has been made will be explained such that everything will make sense for the reader.

## **2. The Entity-Relationship Diagram**

<ins>*Entities[17] :*</ins>

**User-Related AND Role-Related:**
  -     User_Role       - **Entity which represents a platform role**
  -     Store_User      - **Entity which represents a platform user**
  -     Permission      - **Entity which represents a permission**
  -     Role_Permission - **Entity which links roles and permissions**

Their necessity is linked to the need of being able to *save users, roles, and have a permission-based access system across the platform*.

**Product-Related:**
  -      Product_Category  - **Entity which represents a product category**
  -      Product           - **Entity which represents a store product**
  -      Book_Genre        - **Entity which represents a book literary genre**
  -      Book_Details      - **Entity which represents book-related details of a product**
  -      Audio_Genre       - **Entity which represents an audio genre**
  -      Audio_Details     - **Entity which represents audio-related details of a product**

Their necessity is linked to the need of being able to *store specific products, their corresponding categories, and different details about them based on categories*.

**Order-Related:**
-       Order_Payment    - **Entity which represents the available payment methods for paying orders**
-       Order_Status     - **Entity which represents the various statuses which orders have while they go through the process of order**
-       Store_Order      - **Entity which represents an order placed by a customer**
-       Ordered_Item     - **Entity which links items with orders and adds more details

Their necessity is linked to the need of being able to *add payment methods, order statuses, orders placed by users, and items included in specific orders*.

**Complaint-Related:**
-       Complaint_Type    - **Entity which represents types of complains tailored for user problems**
-       Complaint_Status  - **Entity which represents types of statuses that complaints go through before or after being answered**
-       Complaint         - **Entity which represents a complaint made by a user**

Their necessity is linked to the user/customer need of writing and sending complaints regarding personal problems faced during their experience with the platform and/or the business.

<ins>*Attributes[66] :*</ins>

**<ins>User-Related AND Role-Related:</ins>**
-            Store_User[8]    : user_id[PRIMARY], address(country, state, zip_code, city, street, apt), email;
-             User_Role[3]    : role_id[PRIMARY], role_name, description_text;
-            Permission[3]    : permission_id[PRIMARY], permission_name, description_text;
-       Role_Permission[2]    : role_id [PRIMARY], permission_id[PRIMARY];

**<ins>Product-Related:</ins>**
-      Product_Category[2]    : category_id[PRIMARY}, category_name;
-               Product[6]    : product_id[PRIMARY], product_name, category_id, available_stock, unit_price, weight;
-            Book_Genre[2]    : book_genre_id[PRIMARY], book_genre_name;
-          Book_Details[5]    : product_id[PRIMARY], author, publication_year, book_genre_id, description_text;
-           Audio_Genre[2]    : audio_genre_id[PRIMARY], audio_genre_name;
-         Audio_Details[7]    : product_id[PRIMARY], artist, audio_genre_id, audio_year, minutes, seconds, tempo;

**<ins>Order-Related:</ins>**
-         Order_Payment[3]    : payment_type_id[PRIMARY], payment_type, description_text;
-          Order_Status[3]   : status_id[PRIMARY], status_name, description_text;
-           Store_Order[5]    : order_date, order_id[PRIMARY], user_id, payment_type_id, status_id;
-          Ordered_Item[3]    : order_id[PRIMARY], product_id[PRIMARY], quantity; 

**<ins>Complaint-Related:</ins>**
-        Complaint_Type[3]    : complaint_type_id[PRIMARY], complaint_name, description_text;
-      Complaint_Status[3]    : status_id[PRIMARY], status_name, description_text;
-             Complaint[6]    : complaint_id[PRIMARY], complaint_type,id, user_id, complaint_title, complaint_message, status_id;

<ins>*Relationships[] :*</ins>

**<ins>User-Related AND Role-Related:</ins>**

- ` Store_User <---> User_Role, `
- ` Cardinality  : Many-to-One (M:1),`
- ` Participation: Store_User - Total; User_Role - Partial;`

**A Store_User** _can have_ **One User_Role**,
**A User_Role** _can be had by_ **Many Users**.

- `  User_Role <---> Role_Permission, `
- ` Cardinality  :  Many-to-Many (M:N),`
- ` Participation:  User_Role - Partial; Role_Permission - Total;`

**A User_Role** _gets permissions through_ **Many Role_Permission Entities**,

**A Role_Permission Entity** _can give permissions through itself to_ **Many Roles**.

- ` Permission <---> Role_Permission, `
- ` Cardinality  :  Many-to-Many (M:N),`
- ` Participation:  Permission - Partial; Role_Permission - Total;`

**A Permission** _is given to roles through_ **Many Role_Permission Entities**,

**A Role_Permission Entity** _can give_ **Many Permissions**.


**IMPORTANT NOTE:** *Role_Permission* is an entity which connects _User_Roles_ with _Permissions_, therefore the relationship between _User Roles_ and _Permissions_ is inferred through the help of this perspective rather than from a direct relationship symbol in the diagram.

**<ins>Product-Related:</ins>**

- ` Product_Category <---> Product,`
- `       Cardinality  :  One-to-Many (1:M),`
- `       Participation:  Product_Category - Partial; Product - Total;`

**A Product_Category** _categorizes_ **Many Products**,

**A Product** _can have_ **Only One Category**.
 
- `   Product <---> Book_Details,`
- `Cardinality  :  One-to-One (M:1),`
- `Participation:  Product - Partial; Book_Details - Total;`

**A Product** _keeps book data into_ **One Entity of Book_Details**,

**A Book_Details Entity** _can be had by_ **Only One Product**.

- `Book_Details <---> Book_Genre,`
- `  Cardinality  :  Many-to-One (M:1),`
- `  Participation:  Book_Details - Total; Book_Genre - Partial;`

**A Book_Details Entity** _has_ **One Book_Genre**,

**A Book_Genre** _can be had by_ **Many Book_Details Entities**.

- `   Product <---> Audio_Details,`
- `Cardinality  :  One-to-One (1:1),`
- `Participation:  Product - Partial; Audio_Details - Total;`

**A Product** _keeps audio data into_ **One Entity of Audio_Details**,

**An Audio_Details Entity** _can be had by_ **Only One Product**.

- `Audio_Details <---> Audio_Genre,`
- `  Cardinality  :  Many-to-One (M:1),`
- `  Participation:  Audio_Details - Total; Audio_Genre - Partial;`

**An Audio_Details Entity** _has_ **One Audio_Genre**,

**An Audio_Genre** _can be had by_ **Many Audio_Details Entities**.


**<ins>Order-Related:</ins>**

- `Store_Order <---> Ordered_Item,`
- ` Cardinality  :  One-to-Many (1:M),`
- ` Participation:  Store_Order - Partial; Ordered_Item - Total;`

**A Store_Order** _has its order products in_ **Many Ordered_Item Entities**,

**An Ordered_Item Entity** _can have an order product for_ **Many Store_Orders**.

- `Store_Order <---> Order_Payment,`
- ` Cardinality  :  Many-to-One (M:1),`
- ` Participation:  Store_Order - Total; Order_Payment - Partial;`

**A Store_Order** _is getting paid through_ **One Order_Payment (Method)**,

**An Order_Payment (Method)** _can be used to pay for_ **Many Store_Orders**.

- `Store_Order <---> Order_Status,`
- ` Cardinality  :  Many-to-Many (M:N),`
- ` Participation:  Store_Order - Total; Order_Status - Partial;`

**A Store_Order** _has_ **Many Order_Statuses (not at once, but in time)**,

**One Order_Status** _can be had by_ **Many Store_Orders**.

**<ins>Complaint-Related:</ins>**

- `  Complaint <---> Complaint_Type,`
- ` Cardinality  :  Many-to-One (M:1),`
- ` Participation:  Complaint - Total; Complaint_Type - Partial;`

**A Complaint** _has_ **One Complaint_Type**,

**A Complaint_Type** _can be had by_ **Many Complaints**.

- `  Complaint <---> Complaint_Status`
- ` Cardinality  :  Many-to-Many (M:N),`
- ` Participation:  Complaint - Total; Complaint_Status - Partial;`

**A Complaint** _has_ **Many Complaint_Statuses (not at once, but in time)**,

**A Complaint_Status** _can be had by_ **Many Complaints**.

**<ins>Relationships that connect sections between themselves</ins>**

- `    Product <---> Ordered_Item`
- ` Cardinality  :  One-to-Many (Mq:N),`
- ` Participation:  Product - Partial; Ordered_Item - Total;`

**A Product** _is added into orders through_ **Many Ordered_Item Entities**,

**An Ordered_Item Entity** _adds into orders_ **One Product (at a time/in an entry)**.

- `Store_User <---> Store_Order`
- `Cardinality  :  One-to-Many (1:M),`
- `Participation:  Store_User - Partial; Store_Order - Partial;`

**A Store_User** _can place_ **Many Store_Orders**,

**A Store_Order** _can be placed by_ **Only One Store_User**.

- `Store_User <---> Complaint`
- `Cardinality  :  One-to-Many (1:M),`
- `Participation:  Store_User - Partial; Complaint - Total;`

**A Store_User** _can place_ **Many Complaints**,

**A Complaint** _can be placed by_ **Only One Store_User**.
