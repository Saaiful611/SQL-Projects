select *
from layoffs
;

create table layoff_staging
like layoffs
;

select *
from layoff_staging;


insert layoff_staging
select *
from layoffs;

select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoff_staging;


with duplicate_cte as
(
select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoff_staging
)
select *
from duplicate_cte
where row_num >1;

select *
from layoff_staging
where company = 'cazoo'
;

with duplicate_cte as
(
select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoff_staging
)
delete 
from duplicate_cte
where row_num >1;

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoff_staging2;

insert into layoff_staging2
select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoff_staging;

select *
from layoff_staging2
where row_num >1;

delete 
from layoff_staging2
where row_num >1;

-- standardizing data

select distinct(country)
from layoff_staging2
order by 1
;

update layoff_staging2
set company = trim(company);

update layoff_staging2
set industry = 'Crypto'
where industry like "Crypto%";

select *
from layoff_staging2
;

update layoff_staging2
set country = trim(trailing '.' from country);

update layoff_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoff_staging2
modify column `date` date;

select *
from layoff_staging2
where industry is null 
;

update layoff_staging2
set industry = null 
where industry = '';

select *
from layoff_staging2
;

select *
from layoff_staging2 t1
join layoff_staging2 t2 
	on t1.company = t2.company 
where t1.industry is null
;

update layoff_staging2 t1
join layoff_staging2 t2 
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;


select *
from layoff_staging2
where (total_laid_off is null or '') and (percentage_laid_off is null or '')
;

delete 
from layoff_staging2
where (total_laid_off is null or '') and (percentage_laid_off is null or '')
;

alter table layoff_staging2
drop column row_num;

select*
from layoff_staging2;





