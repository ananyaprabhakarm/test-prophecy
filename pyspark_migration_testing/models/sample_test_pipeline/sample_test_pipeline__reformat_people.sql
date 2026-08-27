{{
  config({    
    "materialized": "ephemeral",
    "database": "qa_team",
    "schema": "qa_orchestration"
  })
}}

WITH xlsx_source AS (

  SELECT *
  
  FROM {{ prophecy_tmp_source('sample_test_pipeline', 'xlsx_source') }}

),

{#Reformat gem: Clean and transform person data from XLSX#}
reformat_people AS (

  SELECT 
    Id AS person_id,
    `First Name` AS first_name,
    `Last Name` AS last_name,
    CONCAT(`First Name`, ' ', `Last Name`) AS full_name,
    Gender AS gender,
    Country AS country,
    CAST(Age AS INT) AS age,
    CASE
      WHEN Age < 25
        THEN 'Young Adult'
      WHEN Age >= 25 AND Age < 40
        THEN 'Adult'
      WHEN Age >= 40 AND Age < 55
        THEN 'Middle Age'
      ELSE 'Senior'
    END AS age_group,
    Date AS registration_date
  
  FROM xlsx_source

)

SELECT *

FROM reformat_people
