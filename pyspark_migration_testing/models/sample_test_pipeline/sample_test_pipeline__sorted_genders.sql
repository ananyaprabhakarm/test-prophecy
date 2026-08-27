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

{#Aggregate gem: Gender distribution analysis#}
gender_analysis AS (

  SELECT 
    gender,
    COUNT(*) AS total_people,
    ROUND(AVG(age), 1) AS avg_age,
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    COUNT(DISTINCT country) AS countries_represented,
    COUNT(DISTINCT age_group) AS age_groups_present
  
  FROM reformat_people
  
  GROUP BY gender

),

{#OrderBy gem: Sort by total people descending#}
sorted_genders AS (

  SELECT * 
  
  FROM gender_analysis
  
  ORDER BY total_people DESC

)

SELECT *

FROM sorted_genders
