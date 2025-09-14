-- Data Cleaning


-- 1) Remove Duplicates
-- 2) Standardise the Data
-- 3) Null Values or Blank Values
-- 4) Remove Any Unnecessary Columns or Rows


-- Inspect raw data
SELECT *
FROM layoffs;


-- Create a staging table (working on a copy of the data)
CREATE TABLE layoffs_staging
LIKE layoffs;


INSERT layoffs_staging
SELECT *
FROM layoffs;


-- 1) REMOVING DUPLICATES
-- Use ROW_NUMBER() to identify duplicate rows based on key fields

WITH duplicate_cte as(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
	FROM layoffs_staging
) 
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;


-- Create a second staging table with row numbers
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

-- Delete duplicate rows where row_num > 1
SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;


SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- 2) STANDARDISING DATA
-- Trim extra spaces, fix inconsistent labels, and standardise formats


-- Trim spaces from company names
UPDATE layoffs_staging2
SET company = trim(company);


-- Standardise 'Crypto' industry labels
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Fix inconsistent country names (remove trailing periods)
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- Convert 'date' from text to proper DATE format
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3) HANDLE NULL OR BLANK VALUES
-- Replace empty strings with NULLs
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


-- Fill missing industry values using other rows for the same company/location
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- 4) REMOVE UNNECESSARY ROWS OR COLUMNS
-- Delete rows where both 'total_laid_off' and 'percentage_laid_off' are NULL
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- Drop the helper 'row_num' column (not needed)
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- Final cleaned dataset
SELECT *
FROM layoffs_staging2;