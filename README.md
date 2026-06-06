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

####<ins>*Entities[17] :*</ins>

**User-Related AND Role-Related:**
  -     _User_Role_       - **Entity which represents a platform role**
  -     _Store_User_      - **Entity which represents a platform user**
  -     _Permission_      - **Entity which represents a permission**
  -     _Role_Permission_ - **Entity which links roles and permissions**

Their necessity is linked to the need of being able to *save users, roles, and have a permission-based access system across the platform*.

**Product-Related:**
  -     _Product_Category_ - **Entity which represents a product category**
  -     _Catalogue_        - **Entity which represents a catalogue of products**
  -     _Book_Genre_       - **Entity which represents a book literary genre**
  -     _Book_Details_     - **Entity which represents book-related details of a product**
  -     _Audio_Genre_      - **Entity which represents an audio genre**
  -     _Audio_Details_    - **Entity which represents audio-related details of a product**

Their necessity is linked to the need of being able to *store specific products, their corresponding categories, and different details about them based on categories*.

**Order-Related:**
-       _Order_Payment_    - **Entity which represents the available payment methods for paying orders**
-       _Order_Status_     - **Entity which represents the various statuses which orders have while they go through the process of order**
-       _Store_Order_      - **Entity which represents an order placed by a customer**
-       _Ordered_Item_     - **Entity which links items with orders and adds more details

Their necessity is linked to the need of being able to *add payment methods, order statuses, orders placed by users, and items included in specific orders*.

**Complaint-Related:**
-       _Complaint_Type_   - **Entity which represents types of complains tailored for user problems**
-       _Complaint_Status_ - **Entity which represents types of statuses that complaints go through before or after being answered**
-       _Complaint_        - **Entity which represents a complaint made by a user**

>>>>>>>>>>>TO EDIT>>>>>>>>>>>>>>>>>>> Their necessity... **TO BE CONTINUED**

<ins>*Attributes[26] :*</ins>

**User-Related AND Role-Related:**
-            _Store_User[8]_    : user_id[PRIMARY], address(country, state, zip_code, city, street, apt), email;
-             _User_Role[3]_    : role_id[PRIMARY], role_name, description_text;
-            _Permission[3]_    : permission_id[PRIMARY], permission_name, description_text;
-       _Role_Permission[2]_    : role_id [PRIMARY], permission_id[PRIMARY];

**Product-Related:**
-      _Product_Category[2]_    : category_id[PRIMARY}, category_name;
-             _Catalogue[6]_    : product_id[PRIMARY], product_name, category_id, available_stock, unit_price, weight;
-            _Book_Genre[2]_    : book_genre_id[PRIMARY], book_genre_name;
-          _Book_Details[5]_    : product_id[PRIMARY], author, publication_year, book_genre_id, description_text;
-           _Audio_Genre[2]_    : audio_genre_id[PRIMARY], audio_genre_name;
-         _Audio_Details[7]_    : product_id[PRIMARY], artist, audio_genre_id, audio_year, minutes, seconds, tempo;

>>>>>>>>>>>>>>>>>>>>>>>TO EDIT
**Order-Related:**
-       _Order_Payment_         : **Entity which represents the available payment methods for paying orders**
-       _Order_Status_          : **Entity which represents the various statuses which orders have while they go through the process of order**
-       _Store_Order_           : **Entity which represents an order placed by a customer**
-       _Ordered_Item_          : **Entity which links items with orders and adds more details

**Complaint-Related:**
-       _Complaint_Type_   - **Entity which represents types of complains tailored for user problems**
-       _Complaint_Status_ - **Entity which represents types of statuses that complaints go through before or after being ansewered**
-       _Complaint_        - **Entity which represents a complaint made by a user**
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
