-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


SELECT company, SUM(total_laid_off) sum_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY sum_laid_off DESC;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


SELECT country, SUM(total_laid_off) sum_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY sum_laid_off DESC;


SELECT YEAR(`date`), SUM(total_laid_off) sum_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


SELECT stage, SUM(total_laid_off) sum_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;


SELECT SUBSTR(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;


WITH Rolling_total AS( 
SELECT SUBSTR(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_total
FROM Rolling_total;


SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC ;


SELECT company, SUBSTR(`date`,1,4) AS `YEAR`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `YEAR`
ORDER BY 1 ;


WITH Company_year(company, years, total_laid_off) AS
(SELECT company, SUBSTR(`date`,1,4) AS `YEAR`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `YEAR`
), company_year_rank AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;

