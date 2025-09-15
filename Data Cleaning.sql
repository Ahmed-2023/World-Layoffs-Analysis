## Take Copy from Original Table 
Create Table layoffs_copy
like layoffs;

insert into layoffs_copy
select*
from layoffs;

SELECT *
FROM copy2;

##Remov Duplicates
##Create column_uique
SELECT *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as Row_num
FROM copy2;

## Filter
with identifer_duplictes as
(
SELECT *,
row_number() over(partition by
 company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as Row_num
FROM copy2
)
select* 
 from identifer_duplictes
 where Row_num > 1;

##Delete Dublicates 
 CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `Row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_copy2
SELECT *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as Row_num
FROM layoffs_copy;

Delete
from layoffs_copy2
where Row_num>1;

select*
from layoffs_copy2;

##### Standardizing Data
#coding to exmine the column
select  company ,trim(company)
FROM layoffs_copy2;
#Fixsed Space Issue in column company
update layoffs_copy2
set company=trim(company);

##Fixed Incorrect Value in Columns Industry "crypto currency" to "crypto"
#coding to exmine the column
select distinct (industry)
FROM layoffs_copy2
order by 1;

#doing Correct Industry "crypto currency" to "crypto" (3 Values)
update layoffs_copy2
set industry="Crypto" 
where industry like "Crypto%";

#coding to exmine the column
select distinct country
FROM layoffs_copy2
order by 1;

##doing Correct country "United States." to "United States" (1 Values)
update layoffs_copy2
#set country=trim(tearlang '.' from country)
set country="United States"
where country like "United States%";

##change Datatype of Date column
#changing Fromtting
 update layoffs_copy2
 set `date`=str_to_date(`date`,'%m/%d/%Y');
 
 #changing Dataype of Column
 Alter Table layoffs_copy2
 modify column `date` date;
 
####Dealing with nulls and blanks cels
#exmine null and blank values
select*
from layoffs_copy2
where industry is null or industry="";

#performs a self-join on the copy2 table to retrieve missing industry values for rows that share the same company but have a valid industry recorded in another row. 
select p1.industry,p2.industry
from layoffs_copy2 as p1
join layoffs_copy2 as p2
	on p1.company=p2.company
	#and p1.location=p1.location
where (p1.industry is null or p1.industry="") 
and p2.industry is not null;

#repalce blank values by null values
update layoffs_copy2
set industry=null
where industry="";

#updates missing industry values in the copy2 table by using a self-join to copy the industry from rows of the same company where it is available
update layoffs_copy2 as p1
join layoffs_copy2 as p2
	on p1.company=p2.company
set p1.industry=p2.industry 
where p1.industry is null 
and p2.industry is not null; 

#cheak
select *
from layoffs_copy2
where company="Airbnb";

####Rmove any column  or Rows Don't use it
#exmine values not use it 
select *
from layoffs_copy2
where total_laid_off is null and percentage_laid_off is null;

#delete values not use it
delete
from layoffs_copy2
where total_laid_off is null and percentage_laid_off is null;
 
 
 ###Drop the Row_num 
 Alter Table layoffs_copy2
 Drop  column Row_num;
 
 select*
 from layoffs_copy2