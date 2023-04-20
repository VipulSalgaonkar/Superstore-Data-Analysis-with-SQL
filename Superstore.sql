

#**************************************************************************************************************************
# ----------------------------------------------------Superstore Data Analysis---------------------------------------------------------------
#**************************************************************************************************************************

#Data Preprocessing and Data Cleaning

### Transform the Space Seperated Column Name
alter table superstore rename column `Row ID` to Row_id;
alter table superstore rename column `Order ID` to Order_ID;
alter table superstore rename column `Order Date` to Order_Date;
alter table superstore rename column `Ship Date` to Ship_Date;

alter table superstore rename column `Ship Mode` to Ship_Mode;
alter table superstore rename column `Customer ID` to Customer_ID;
alter table superstore rename column `Customer Name` to Customer_Name;
alter table superstore rename column `Country/Region` to Region;
alter table superstore rename column `Postal Code` to Postal_Code;

alter table superstore rename column `Product ID` to Product_ID;	
alter table superstore rename column `Sub-Category` to Subcategory;
alter table superstore rename column `Product Name` to 	Product_Name;

alter table returns rename column `Order ID` to Order_ID;

# Drop Unwanted Field 
#alter table superstore drop `Country/Region`;  

# Description of Tables
desc superstore;

#**************************************************************************************************************************
														#Data Analysis
#**************************************************************************************************************************

-- 1)	Find how many order are Shipped by Each Ship Class?Which Class preferred Most?
		select Ship_Mode,count(Row_id) from superstore
		group by Ship_Mode
		order by count(Row_id) desc;

-- Conclusion  : Superstore has Four Ship mode and Standard Class has the Highest preferred Ship Mode by Customer


-- 2)   Give me the Records of all Customer which Choose Standard Class along with sales and product?

		select Customer_ID,Customer_Name,
		Ship_Mode,Product_ID,
		Product_Name,Sales 
		from superstore
		where Ship_Mode = "Standard Class";

-- 3)	In Which State and City Most of order has ordered?
		select State,City,count(Row_ID) as Total_Orders
		from superstore
		group by State,City
		order by Total_Orders desc;

-- 4)	Get the all product list along with category and Subcategory available in Superstore

		select Category,SubCategory,Product_Name
		from Superstore
		group by Category,SubCategory 
		order by Category;
 
 -- Conclusion: There are 3 main Category available in Superstore like Furniture,Office Supplies,Technology
--   			Category with Sub Categorys are Furniture = 4 SubCategory , Office Supplies = 9 SubCategory & technology with 3 Subcategory
						

-- 5)List of all Customer which buy furniture from superstore
		select	* from superstore
		where category = "Furniture";

-- # Conclusion: 761 Customer bought Furniture

-- 6)In which date Most of Orders had Done?
		select count(Order_Id),Order_Date
		from superstore
		group by Order_Date
		order by 1 desc;
--  Conclusion: On 5 September 2018 Most of Order had Done


-- 7)	Which Orders of Customer are Return? What is the Ship modes of that order?
		
        select returns.Order_Id,Returned,Order_Date,Customer_ID,
		Customer_Name,Ship_Mode,Product_ID,Product_Name
		from returns
		left join Superstore
		on returns.Order_ID = superstore.Order_ID;

-- There are 773 Orderd are Returned from Customer.

-- 8)	Which Customers buy most of Products from Superstore? Which Products they Purchased Most?
		create temporary table Customer as (
		select Customer_ID,Product_Name, count(Row_id)as Total_Order
		from superstore
		group by Customer_ID,Product_Name
		order by Total_Order,Customer_ID desc);

		# Total products Ordered by each Customer from Superstore
		select Customer_ID, count(Row_id)as Total_Order
		from superstore
		group by Customer_ID
		order by Total_Order desc;


		# Count of each Product along with Product name according to Customer_ID
		select Customer_ID,Product_Name,
        count(Total_Order) from Customer
		group by Product_Name
        order by count(Total_Order) desc;


-- 9)	Find out top,bottom 10 State and Cities which getting maximum & minimum Revenue and Profit?

		select State,City,sum(Sales),sum(Profit) from superstore
		group by State,City
		order by sum(Sales) asc limit 10 ;


		select State,City,sum(Sales),sum(Profit) from superstore
		group by State,City
		order by sum(Sales) desc limit 10 ;

-- conclusion :  "New York" State and City Superstore getting Maximum Revenue and Profit of 255248.969 and 61624.0582 respectively.

--  			 "State "Texas" with City "Abilene" Superstore suffereing Loss with sales of 1.392 and Profit -3.7584


-- 10)	Which Product give highest Sales along with Total Quantity Ordered by Customer?
		select Product_Name,sum(Sales) Sales_Amount ,
        sum(Quantity) Total_Quantity from superstore
		group by Product_Name
		order by 2 desc;

-- 		Conclusion: "Canon Imageclass 2200 Advance Copier" Product gives most sales to Superstore with 20 Nos.


-- 11)	Which Sales Person archive Higher sales and Profit in Superstore?

		select Person,sum(sales) Total_Sales , sum(profit) Profit  from people
		right join superstore
		on people.Region = superstore.Region
		group by Person
		order by Total_Sales desc;
        
-- 		Conclusion: Anna Andreadi has More sales of 713471.3445 with Profit of 106021.1495

-- 12)	Which Sales person order has returned most?
		select Person,count(returns.Order_ID) Total_Return_Order from
        people
        left join superstore
        on people.Region=superstore.Region
        left join returns
        on superstore.order_ID = returns.Order_ID
        group by Person
        order by Total_Return_Order desc;
        
-- 		Conclusion: Anna Andreadi has Maximum Return Orders of 474.


#****************************************************************************************************************************************