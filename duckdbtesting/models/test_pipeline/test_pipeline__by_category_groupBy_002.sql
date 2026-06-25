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

by_category_from_000 AS (

  SELECT COUNT(*) AS count_sqe_000
  
  FROM sample_data AS source_data

),

by_category_from_001 AS (

  SELECT 
    category,
    amount,
    sq_000.count_sqe_000
  
  FROM sample_data AS source_data
  CROSS JOIN by_category_from_000 AS sq_000

),

by_category_groupBy_002 AS (

  SELECT 
    category,
    COUNT(*) AS order_count,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value,
    ROUND(MIN(amount), 2) AS min_order,
    ROUND(MAX(amount), 2) AS max_order,
    ROUND(100.0 * COUNT(*) / MAX(count_sqe_000), 1) AS pct_of_orders
  
  FROM by_category_from_001
  
  GROUP BY category

)

SELECT *

FROM by_category_groupBy_002
