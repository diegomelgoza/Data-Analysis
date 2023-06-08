--------- Exploring the Starbucks Food Menu ----------

Select * from PortfolioProject..starbucksFacts;

-- Changed column name 'type' to 'foodType' --
EXEC sp_rename 'PortfolioProject..starbucksFacts.type', 'foodType', 'COLUMN'

Select * from PortfolioProject..starbucksFacts;

-- Total number of items in each type
SELECT foodType, COUNT(*) AS num_items
FROM PortfolioProject..starbucksFacts
GROUP BY foodType
ORDER BY num_items DESC;

---------- Finding the healthiest menu options ----------

--Get the average calorie count for each foodType
SELECT foodType, ROUND(AVG(CAST(calories AS FLOAT)), 2) AS avg_calories
FROM PortfolioProject..starbucksFacts
GROUP BY foodType
ORDER BY avg_calories DESC;

-- Lowest Calorie Count --
SELECT item, calories, foodType FROM PortfolioProject..starbucksFacts ORDER BY calories ASC;

-- Food with lots of Protein --
SELECT item, protein, foodType FROM PortfolioProject..starbucksFacts ORDER BY protein DESC;

-- High Carb foods --
SELECT item, carb, foodType FROM PortfolioProject..starbucksFacts ORDER BY carb DESC;

-- Low fat foods -- 
SELECT item, fat, foodType FROM PortfolioProject..starbucksFacts ORDER BY fat ASC;

---- Low Calorie, High in Protein ----

SELECT item, calories, protein, foodType FROM PortfolioProject..starbucksFacts
-- Filter down to 300 calories or less
SELECT item, calories, protein, foodType FROM PortfolioProject..starbucksFacts WHERE calories <= 300 AND protein >=10 ORDER BY protein desc;

---- Low Carb, High in Protein ----
SELECT item, carb, protein, foodType FROM PortfolioProject..starbucksFacts
-- Filter down to 30 carbs or less
SELECT item, carb, protein, foodType FROM PortfolioProject..starbucksFacts WHERE carb <= 30 AND protein >= 10  ORDER BY protein desc;
