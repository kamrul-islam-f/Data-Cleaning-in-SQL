-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Date range of the dataset

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Checking maximum of 'total_laid_off' and 'percentage_laid_off'

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Checking where the laid off percentage is 1 and funds are the highest

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; 

-- Company wise total laid off from highest to lowest

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Industry wise total laid off from highest to lowest

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Country wise total laid off from highest to lowest

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Stage wise total laid off from highest to lowest

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Year wise total laid off from earliest to oldest

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Year-Month wise total laid off from oldest to earliest

SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1;

-- Month wise Rolling Total of total laid off from 2020 to 2023

WITH Rolling_Total AS
(SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1)

SELECT `Month`, total_layoff, SUM(total_layoff) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

-- Top 5 Companies and their total laid off per year

WITH Company_Year(company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)),
Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL)

SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5;

-- Top 5 Industries and their total laid off per year

WITH Industry_Year(industry, years, total_laid_off) AS
(SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)),
Industry_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Industry_Year
WHERE years IS NOT NULL)

SELECT *
FROM Industry_Year_Rank
WHERE Ranking <=5;

-- Top 5 Countries and their total laid off per year

WITH Country_Year(country, years, total_laid_off) AS
(SELECT country, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country, YEAR(`date`)),
Country_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Country_Year
WHERE years IS NOT NULL)

SELECT *
FROM Country_Year_Rank
WHERE Ranking <=5;

-- Top 3 Companies and their funds_raised per year

WITH Funds_Year(company, years, funds_raised_millions) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)),
Funds_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY funds_raised_millions DESC) AS Ranking
FROM Funds_Year
WHERE years IS NOT NULL)

SELECT *
FROM Funds_Year_Rank
WHERE Ranking <=3;


