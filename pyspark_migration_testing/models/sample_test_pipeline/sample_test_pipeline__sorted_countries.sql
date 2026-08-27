{{
  config({    
    "materialized": "ephemeral",
    "database": "qa_team",
    "schema": "qa_orchestration"
  })
}}

WITH reformat_people AS (

  SELECT *
  
  FROM {{ ref('sample_test_pipeline__reformat_people')}}

),

{#Aggregate gem: Country demographics analysis#}
country_demographics AS (

  SELECT 
    country,
    COUNT(*) AS total_people,
    ROUND(AVG(age), 1) AS avg_age,
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    SUM(CASE
      WHEN gender = 'Male'
        THEN 1
      ELSE 0
    END) AS male_count,
    SUM(CASE
      WHEN gender = 'Female'
        THEN 1
      ELSE 0
    END) AS female_count,
    COUNT(DISTINCT age_group) AS age_groups_present
  
  FROM reformat_people
  
  GROUP BY country

),

{#OrderBy gem: Sort by total people descending#}
sorted_countries AS (

  SELECT * 
  
  FROM country_demographics
  
  ORDER BY total_people DESC

)

SELECT *

FROM sorted_countries
