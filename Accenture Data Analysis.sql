-- The following query retrieves all columns from the joined tables Reactions, Content, and ReactionTypes.
-- It joins these tables based on Content ID and Sentiment_Type to analyze sentiment reactions for content.

SELECT *
FROM [Accenture Data Analysis].[dbo].[Reactions] AS t1
JOIN [Accenture Data Analysis].[dbo].[Content] AS t2 ON t1.[Content ID] = t2.[Content ID]
JOIN [Accenture Data Analysis].[dbo].[ReactionTypes] AS t3 ON t1.Sentiment_Type = t3.Sentiment_Type


-- The query below creates a common table expression (CTE) named RankedCategories.
-- It calculates the aggregate score and ranks categories based on sentiment scores.

WITH RankedCategories AS (
    SELECT
        t2.Category,
        SUM(t3.Score) AS AggregateScore,
        RANK() OVER (ORDER BY SUM(t3.Score) DESC) AS CategoryRank
    FROM
        [Accenture Data Analysis].[dbo].[Reactions] AS t1
    JOIN
        [Accenture Data Analysis].[dbo].[Content] AS t2 ON t1.[Content ID] = t2.[Content ID]
    JOIN
        [Accenture Data Analysis].[dbo].[ReactionTypes] AS t3 ON t1.Sentiment_Type = t3.Sentiment_Type
    GROUP BY
        t2.Category
)
-- The final query selects the top 5 categories with their aggregate scores from the CTE RankedCategories.

SELECT
    Category,
    AggregateScore
FROM
    RankedCategories
WHERE
    CategoryRank <= 5;

-- An alternative approach to achieve the same result, with additional calculations:

-- The following query retrieves the top 5 categories based on the total and average sentiment scores.

SELECT
    TOP 5
    c.Category,
    SUM(rt.Score) AS total_score,
    AVG(rt.Score) AS average_score
FROM [Accenture Data Analysis].[dbo].[Reactions] AS r
INNER JOIN [Accenture Data Analysis].[dbo].[Content] AS c ON r.[Content ID] = c.[Content ID]
INNER JOIN [Accenture Data Analysis].[dbo].[ReactionTypes] AS rt ON r.Sentiment_Type = rt.Sentiment_Type
GROUP BY c.Category
ORDER BY total_score DESC;

-- This SQL query counts the number of occurrences of the 'animals' category in the dataset.

-- SELECT statement to count occurrences
SELECT 
    COUNT(t2.Category) AS CountOfCategory

-- FROM clause to specify the tables involved
FROM [Accenture Data Analysis].[dbo].[Reactions] AS t1
JOIN [Accenture Data Analysis].[dbo].[Content] AS t2 ON t1.[Content ID] = t2.[Content ID]
JOIN [Accenture Data Analysis].[dbo].[ReactionTypes] AS t3 ON t1.Sentiment_Type = t3.Sentiment_Type

-- WHERE clause to filter rows where the category is 'animals'
WHERE t2.Category LIKE 'animals'

-- GROUP BY clause to group the results by the 'Category' column
GROUP BY t2.Category;


-- Common Table Expression (CTE) to extract the month from the Datetime column
WITH PostMonth AS (
    SELECT
        MONTH(t1.Datetime) AS PostMonth,
        COUNT(*) AS PostCount
    FROM
        [Accenture Data Analysis].[dbo].[Reactions] AS t1
    JOIN
        [Accenture Data Analysis].[dbo].[Content] AS t2 ON t1.[Content ID] = t2.[Content ID]
    JOIN
        [Accenture Data Analysis].[dbo].[ReactionTypes] AS t3 ON t1.Sentiment_Type = t3.Sentiment_Type
    GROUP BY
        MONTH(t1.Datetime)
)

-- Main query to find the month with the most posts
SELECT TOP 1
    PostMonth,
    PostCount
FROM
    PostMonth
ORDER BY
    PostCount DESC;
