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

overall_stats AS (

  SELECT 
    COUNT(*) AS total_orders,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value,
    ROUND(MIN(amount), 2) AS min_order,
    ROUND(MAX(amount), 2) AS max_order,
    ROUND(STDDEV(amount), 2) AS stddev_amount,
    COUNT(DISTINCT category) AS unique_categories,
    COUNT(DISTINCT region) AS unique_regions
  
  FROM sample_data AS source_data

)

SELECT *

FROM overall_stats
