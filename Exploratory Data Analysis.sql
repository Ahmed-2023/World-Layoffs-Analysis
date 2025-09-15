select *
from layoffs_copy2;


## Returns the maximum number of layoffs and the maximum layoff percentage recorded in layoffs
select max(total_laid_off), max(percentage_laid_off)
from layoffs_copy2 ;


## Returns all companies that laid off 100% of their workforce, ordered by the total number of employees laid off (from largest to smallest)
select*
from layoffs_copy2
where percentage_laid_off=1
order by total_laid_off desc;


## Return the total number of laid-off employees for each company, sorted from the highest to the lowest
select company,sum(total_laid_off) as total
from layoffs_copy2
group by company
order by total desc;


## total layoffs grouped by funding stage, ordered by the highest number of layoffs first
select stage,sum(total_laid_off) as total
from layoffs_copy2
group by Stage
order by total desc;


##identify which industry had the highest number of layoffs
select industry,sum(total_laid_off) as total
from layoffs_copy2
group by industry
order by total desc;


##The total number of layoffs by country, ordered to highlight the countries with the highest layoffs
select country,sum(total_laid_off) as total
from layoffs_copy2
group by country
order by total desc;


##calculates the total number of layoffs per year, showing which years had the highest layoffs
select year(`date`),sum(total_laid_off) as total
from layoffs_copy2
where year(`date`) is not null
group by year(`date`)
order by 2 desc;

##calculates the total number of layoffs per Month, showing which Month had the highest layoffs
select substring(`date`,1,7) as `month`,sum(total_laid_off) as total
from layoffs_copy2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc ;

##Calculate Monthly Totals and Rolling (Cumulative) Layoffs Over Time
with Rolling_Total as 
(
 select substring(`date`,1,7) as `month`,sum(total_laid_off) as total
from layoffs_copy2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc 
)
select `month`,total,sum(total) over (order by `month`) as rolling_total
from Rolling_Total;


##Total Layoffs by Company per Year (Sorted Descending)
SELECT company, year(`date`),sum(total_laid_off) as total
from layoffs_copy2
where total_laid_off is not null
group by   company,year(`date`)
order by 3 desc;

##Top 5 Companies by Layoffs per Year
With Rank_year (company,Years,Total) as
(
SELECT company, year(`date`),sum(total_laid_off) as total
from layoffs_copy2
where total_laid_off is not null
group by   company,year(`date`)
), Rank_year_top5 as 
(
select * , dense_rank() over (partition by Years order by Total desc) as Ranking
from  Rank_year
where Years is not null
)
select*
from Rank_year_top5
where Ranking<=5;


