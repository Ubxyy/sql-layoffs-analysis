-- Exploratory Data Analysis on Global Layoffs Dataset

-- This script explores trends and insights from the cleaned dataset (layoffs_staging2).
-- Focus areas include: overall layoffs, industries, countries, years, monthly trends, and top companies.


-- Preview cleaned dataset
SELECT *
FROM layoffs_staging2
LIMIT 100;


-- 1) BASIC STATS
-- Max number of employees laid off in a single event
-- Max percentage of workforce laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off) * 100 as percentage_laid_off
FROM layoffs_staging2;


-- 2) COMPANIES WITH COMPLETE SHUTDOWNS (100% laid off)
-- Shows highly funded companies that likely collapsed ordered by highest funded in descending order
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- 3) TOTAL LAYOFFS BY COMPANY
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- 4) DATE RANGE
-- Layoffs span March 2020 --> March 2023
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


-- 5) TOTAL LAYOFFS BY INDUSTRY
-- Consumer & Retail industries were hit the hardest
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- 6) TOTAL LAYOFFS BY COUNTRY
-- United States had the largest number of layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- 7) TOTAL LAYOFFS BY YEAR
-- 2022 recorded the most layoffs, though 2023 is incomplete (only Q1 data) due to only the first 3 months being considered of 2023
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- 8) TOTAL LAYOFFS BY MONTH
SELECT SUBSTRING(`date`, 1, 7) as `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;


-- 9) ROLLING TOTAL OF LAYOFFS (CUMULATIVE BY MONTH)
WITH Rolling_Total AS 
(
	SELECT SUBSTRING(`date`, 1, 7) as `Month`, SUM(total_laid_off) as total_off
	FROM layoffs_staging2
	WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
	GROUP BY `Month`
	ORDER BY 1 ASC
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;


-- 10) TOP COMPANIES BY TOTAL LAYOFFS
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- 11) TOP COMPANIES PER YEAR (RANKED)
-- Uses window functions to rank companies by layoffs each year
WITH Company_Year (company, years, total_laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM layoffs_staging2
	GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;