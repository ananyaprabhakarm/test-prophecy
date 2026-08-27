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

{#Aggregate gem: Age group distribution analysis#}
age_group_analysis AS (

  SELECT 
    age_group,
    COUNT(*) AS total_people,
    ROUND(AVG(age), 1) AS avg_age,
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    COUNT(DISTINCT country) AS countries_represented,
    COUNT(DISTINCT gender) AS gender_diversity
  
  FROM reformat_people
  
  GROUP BY age_group

)

SELECT *

FROM age_group_analysis
