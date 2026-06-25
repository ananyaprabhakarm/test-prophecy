{{
  config({    
    "materialized": "ephemeral",
    "database": "dev_orchestration_inmemory",
    "schema": "schema"
  })
}}

WITH sample_data AS (

  SELECT *
  
  FROM {{ ref('test_pipeline__sample_data')}}

),

by_region_from_000 AS (

  SELECT SUM(amount) AS sum_amount_sqe_000
  
  FROM sample_data AS source_data

),

by_region_from_001 AS (

  SELECT 
    region,
    amount,
    sq_000.sum_amount_sqe_000
  
  FROM sample_data AS source_data
  CROSS JOIN by_region_from_000 AS sq_000

),

by_region_groupBy_002 AS (

  SELECT 
    region,
    COUNT(*) AS order_count,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value,
    ROUND(100.0 * SUM(amount) / MAX(sum_amount_sqe_000), 1) AS pct_of_revenue
  
  FROM by_region_from_001
  
  GROUP BY region

)

SELECT *

FROM by_region_groupBy_002
