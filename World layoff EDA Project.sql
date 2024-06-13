-- Exploratory data analysis 

select company,total_laid_off,percentage_laid_off
from layoff_staging2
where total_laid_off is not null and percentage_laid_off is not null
order by 3 asc;

select max(total_laid_off), max(percentage_laid_off)
from layoff_staging2;

select *
from layoff_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc; 


select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoff_staging2
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by 1 desc;

with Rolling_total as
(select substring(`date`,1,7) as `month`,
sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by 1 desc
)
select `month`,total_off, sum(total_off) over(order by `month`) as rolling_total
from Rolling_total;


select company,year(`date`), sum(total_laid_off)
from layoff_staging2
group by company,year(`date`)
order by 3 desc;

with company_cte(company,years,total_laid_off) as 
( select company,year(`date`), sum(total_laid_off)
from layoff_staging2
group by company,year(`date`)
), company_year_rank as
(select* ,dense_rank() over(partition by years order by total_laid_off desc) Ranking
from company_cte
where years is not  null 
)
select *
from company_year_rank
where Ranking <=5;





































