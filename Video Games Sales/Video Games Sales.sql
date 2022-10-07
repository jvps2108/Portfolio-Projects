-- select all data related to a specific publisher and filtered, ordered by year 

select *
from vgdata
where Publisher = 'Activision' AND Year between 2000 and 2015
Order by year;


-- select data of Mario game, if any such string present in Name or not!

select *
from vgdata
where Name like '%Mario%' AND Year between 2000 and 2015
Order by year desc;


-- Selecting Global_Sales data related to Sports genre from vgdata and gloabal sales from vgsalesdata

select vgdata.Name, vgdata.Publisher, vgdata.Genre , vgsalesdata.Global_Sales, vgdata.Year
from vgdata
Inner join vgsalesdata on vgdata.Game_id = vgsalesdata.Game_id
where Genre =  'Sports' and Year > 1995 and vgsalesdata.Global_Sales  > 0
Order by vgdata.year  desc;


--   Sum of the sales of different continents and global as well

select vgdata.Name, vgdata.Year, sum(vgsalesdata.EU_Sales), sum(vgsalesdata.US_Sales), sum(vgsalesdata.Asia_Sales) , sum(vgsalesdata.Global_Sales)
from vgsalesdata
Inner join vgdata on vgdata.Game_id = vgsalesdata.Game_id
group by Year
order by Year desc;


-- Game with max sales in an year

select vgdata.Name, max(vgsalesdata.Asia_Sales),max(vgsalesdata.US_Sales), max(vgsalesdata.EU_Sales), max(vgsalesdata.Global_Sales), vgdata.Year
From vgsalesdata
left join vgdata on vgdata.Game_id = vgsalesdata.Game_id
group by vgdata.year
having sum(Global_Sales) > 0
order by year desc;

-- Sales percentages in different regions

Select  vgdata.Publisher,  vgdata.Year, (vgsalesdata.Asia_Sales/ vgsalesdata.Global_Sales) * 100 as percentage_Asia_sales, 
(vgsalesdata.EU_Sales/ vgsalesdata.Global_Sales) * 100 as percentage_EU_sales, 
(vgsalesdata.US_Sales/ vgsalesdata.Global_Sales) * 100 as percentage_US_sales
From vgsalesdata
Inner join vgdata on vgdata.Game_id = vgsalesdata.Game_id
group by vgdata.Publisher,vgdata.Year
order by year DESC;

-- Percentage sales of Games with different Genre

Select vgdata.Name, vgdata.Genre, vgdata.Publisher, vgdata.Year, (vgsalesdata.Asia_Sales/ vgsalesdata.Global_Sales) * 100 as percentage_Asia_sales, 
(vgsalesdata.EU_Sales/ vgsalesdata.Global_Sales) * 100 as percentage_EU_sales, 
(vgsalesdata.US_Sales/ vgsalesdata.Global_Sales) * 100 as percentage_US_sales,
sum(vgsalesdata.Asia_Sales) Over 
(PARTITION BY  vgdata.Genre  order by vgdata.year)as Total_Asia_sales,
sum(vgsalesdata.EU_Sales) Over 
(PARTITION BY vgdata.Genre  order by vgdata.year)as Total_EU_sales,
sum(vgsalesdata.US_Sales) Over 
(PARTITION BY vgdata.Genre order by vgdata.year)as Total_US_sales,
sum(vgsalesdata.Global_Sales) Over 
(PARTITION BY vgdata.Genre order by vgdata.year)as Total_Global_sales
From vgsalesdata
Inner join vgdata on vgdata.Game_id = vgsalesdata.Game_id
WHERE (vgsalesdata.Global_Sales > 0) and (vgsalesdata.Asia_Sales > 0) AND (vgsalesdata.EU_Sales > 0) AND (vgsalesdata.US_Sales > 0);

 


 
