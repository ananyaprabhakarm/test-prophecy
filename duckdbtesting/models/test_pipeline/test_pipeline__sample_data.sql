{{
  config({    
    "materialized": "ephemeral",
    "database": "dev_orchestration_inmemory",
    "schema": "schema"
  })
}}

WITH sample_data_union_union_000_union_000 AS (

  SELECT 
    1 AS order_id,
    'Electronics' AS category,
    'North' AS region,
    250.0 AS amount,
    '2024-01-05' AS order_date
  
  UNION ALL
  
  SELECT 
    2,
    'Clothing',
    'South',
    89.99,
    '2024-01-07'
  
  UNION ALL
  
  SELECT 
    3,
    'Electronics',
    'East',
    450.0,
    '2024-01-10'
  
  UNION ALL
  
  SELECT 
    4,
    'Home',
    'North',
    125.5,
    '2024-01-12'
  
  UNION ALL
  
  SELECT 
    5,
    'Clothing',
    'West',
    67.0,
    '2024-01-15'
  
  UNION ALL
  
  SELECT 
    6,
    'Electronics',
    'South',
    899.99,
    '2024-01-18'
  
  UNION ALL
  
  SELECT 
    7,
    'Home',
    'East',
    234.75,
    '2024-01-20'
  
  UNION ALL
  
  SELECT 
    8,
    'Clothing',
    'North',
    145.0,
    '2024-01-22'
  
  UNION ALL
  
  SELECT 
    9,
    'Electronics',
    'West',
    599.0,
    '2024-01-25'
  
  UNION ALL
  
  SELECT 
    10,
    'Home',
    'South',
    78.25,
    '2024-01-27'
  
  UNION ALL
  
  SELECT 
    11,
    'Clothing',
    'East',
    112.5,
    '2024-01-28'
  
  UNION ALL
  
  SELECT 
    12,
    'Electronics',
    'North',
    1250.0,
    '2024-02-01'
  
  UNION ALL
  
  SELECT 
    13,
    'Home',
    'West',
    345.0,
    '2024-02-03'
  
  UNION ALL
  
  SELECT 
    14,
    'Clothing',
    'South',
    95.75,
    '2024-02-05'
  
  UNION ALL
  
  SELECT 
    15,
    'Electronics',
    'East',
    725.0,
    '2024-02-08'

),

sample_data AS (

  SELECT * 
  
  FROM sample_data_union_union_000_union_000 AS sample_data_union_union_000

)

SELECT *

FROM sample_data
