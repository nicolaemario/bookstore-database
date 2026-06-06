#bookstore-database-project

## CONTENTS PAGE

*_#1. What is the project about?_*
*_#2.

##*1. What is the project about?*

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

##*2. The Entity-Relationship Diagram*

<ins>*Entities[17]*</ins>
  - _Store_User_ - **Entity which represents a platform user**
  - _User_Role_  - **Entity which represents a platform role**
  - _Permission_ - **Entity which represents a permission**
  - _Role_Permission_ - **Entity which represents the link between a role and a permission**

<ins>*Attributes[14]*</ins>
-       _Store_User[8]_  : user_id[PRIMARY], address(country, state, zip_code, city, street, apt), email;
-        _User_Role[3]_  : role_id[PRIMARY], role_name, description_text;
-       _Permission[3]_  : permission_id[PRIMARY], permission_name, description_text;
-  _Role_Permission[2]_  : 



