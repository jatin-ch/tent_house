1. Open Terminal and go to tent_house dir

2. Install SQLite3

3. Create a DB with name 'tent_house.db' form sqlite terminal 
   ~/tent_house $ sqlite3 tent_house.db # will create a database with name 'tent_house'


4. Open another tab terminal & Run the ruby file
   ~/tent_house $ ruby index.rb
   this command will setup db connection & create required tables.

5. Insert into table Items from sqlite3 terminal
    sqlite> INSERT INTO Items VALUES(null,'Plastic Chairs',10000, 0)
    sqlite> INSERT INTO Items VALUES(null,'Tiffany Chairs',5000, 0)
    sqlite> INSERT INTO Items VALUES(null,'Bridal Chair',10, 0)
    sqlite> INSERT INTO Items VALUES(null,'Plastic Round Tables',100, 0)
    sqlite> INSERT INTO Items VALUES(null,'Plastic Rectangular Table',900, 0)
    sqlite> INSERT INTO Items VALUES(null,'Steel Folding Table',80, 0)
    sqlite> INSERT INTO Items VALUES(null,'Gas Stoves',25, 0)
    sqlite> INSERT INTO Items VALUES(null,'Chair Covers',6000, 0)
    sqlite> INSERT INTO Items VALUES(null,'Table Cloths',500, 0)

5. Run the ruby file again
   ~/mindfire $ ruby index.rb
   Congrats!! 'Tent Hose Rental' ready to use.
   Welcome to 'Tent Hose Rental'
   choose your option:
   > 5