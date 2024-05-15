-- 1 -- Retrieve all columns for all records in the dataset
		
		select * from Pharma

-- 2 -- How many unique countries are represented in the dataset?

		select count(distinct p.Country)
		from Pharma p

-- 3 -- Select the names of all the customers on the 'Retail' channel.

		select p.[Customer Name] as Names
		from Pharma p
		where p.[Sub-channel] = 'Retail'

-- 4 --  Find the total quantity sold for the ' Antibiotics' product class

		select sum(p.Quantity)
		from Pharma p
		where p.[Product Class] = 'Antibiotics' and p.Sales > 0

-- 5 -- List all the distinct months present in the dataset
		
		select distinct p.Month
		from Pharma p
		order by p.Month desc

-- 6 -- Calculate the total sales for each year

		select p.Year , sum(p.Sales)
		from Pharma p 
		group by p.Year

-- 7 -- Find the customer with the highest sales value.

		select top 1 p.[Customer Name] Customer_Name  , sum(p.Sales)
		from Pharma p
		group by p.[Customer Name]
		order by sum(p.Sales) desc

-- 8 -- Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'.

		select p.[Name of Sales Rep] Name_employees
		from Pharma p
		where p.Manager = 'James Goodwill'

-- 9 --  Retrieve the top 5 cities with the highest sales.
		
		select top 5 p.City  , sum(p.Sales)
		from Pharma p
		group by p.City
		order by sum(p.Sales) desc

-- 10 -- Calculate the average price of products in each sub-channel.

		select p.[Sub-channel] as Sub_channel , avg(p.Price) Average_Price
		from Pharma p
		group by p.[Sub-channel]

-- 11 -- Join the 'Employees' table with the 'Sales' table to get the name of the Sales Rep and the
      -- corresponding sales records


-- 12 -- Retrieve all sales made by employees from ' Rendsburg ' in the year 2018.

		select *
		from Pharma p 
		where p.City = 'Rendsburg' and p.Year = '2018' and p.Sales > 0

-- 13 -- Calculate the total sales for each product class, for each month, and order the results by
     -- year, month, and product class.

	 select p.[Product Class] Product_Class , p.Month , sum(p.Sales) total_sales
	 from Pharma p
	 group by p.[Product Class] , p.Month , p.Year

-- 14 -- Find the top 3 sales reps with the highest sales in 2019

		select top 3 p.[Name of Sales Rep] sales_reps , sum(p.Sales) highest_sales
		from Pharma p
		where p.Year = '2019'
		group by p.[Name of Sales Rep]
		order by sum(p.Sales) desc

-- 15 -- Calculate the monthly total sales for each sub-channel, and then calculate the average
     -- monthly sales for each sub-channel over the years.

	 select Sub_channel , Month , avg(monthly_total_sales) average_total_sales
	 from(
	 select p.[Sub-channel] Sub_channel , p.Month , sum(p.Sales) monthly_total_sales 
	 from Pharma p
	 group by p.[Sub-channel] , p.Month ) Monthly
	 group by Sub_channel , Month


-- 16 -- Create a summary report that includes the total sales, average price, and total quantity
     --  sold for each product class.

	 select p.[Product Class] Product_Class , sum(Sales) total_sales
	 , avg(p.Price) average_price , sum(p.Quantity) total_quantity
	 from Pharma p  
	 where p.Sales > 0
	 group by p.[Product Class] ;

-- Find the top 5 customers with the highest sales for each year.
	with cte as(
		select p.[Customer Name] Customer_Name, p.Year , p.Sales  ,
		ROW_NUMBER()over(partition by year order by p.Sales desc) RN
		from Pharma p
		)
		select Customer_Name , Year , sales 
		from cte 
		where RN <= 5 
		order by year , RN

-- 18 -- Calculate the year-over-year growth in sales for each country.

	select 
	t1.Country , t1.year as Current_year , t1.Total_Sales as Current_year_sales,
	t2.year as pervious_year , t2.Total_Sales as pervious_year_sales , 
	((t1.Total_Sales - t2.Total_Sales) / t2.Total_Sales * 100 ) as Sales_Growth_percentage
	from (
		select p.Country , p.Year , sum(p.Sales) as Total_Sales 
		from Pharma p
		group by p.Country , p.Year
	) t1

	join 

	(
		select p.Country , p.Year , sum(p.Sales) as Total_Sales
		from Pharma p
		group by p.Country , p.Year
	) t2 
on t1.Country = t2.Country
and t1.Year = t2.Year + 1
order by t1.Year

-- 19 --  List the months with the lowest sales for each year

	WITH MonthlySalesRanked AS (
    SELECT
        Month,
        Year,
        SUM(Sales) AS Total_Sales,
        RANK() OVER (PARTITION BY Year ORDER BY SUM(Sales)) AS SalesRank
    FROM
        Pharma
    GROUP BY
        Year,
        Month
)
SELECT
    Month,
    Year,
    Total_Sales
FROM
    MonthlySalesRanked
WHERE
    SalesRank = 1;

-- 20 -- Calculate the total sales for each sub-channel in each country,
	-- and then find the country with the highest total sales for each sub-channel.
	with cte as(
		 select p.Country , p.[Sub-channel] , sum(p.Sales) total_sales , 
		 rank()over(partition by p.[Sub-channel] order by sum(p.Sales) desc) as RN
		 from Pharma p
		 group by p.Country , p.[Sub-channel]
		 )
		select Country , [Sub-channel] as Sub_channel , total_sales
		from cte
		where RN = 1

 
    