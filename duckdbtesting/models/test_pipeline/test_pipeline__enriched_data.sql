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

enriched_data AS (

  SELECT 
    order_id,
    category,
    region,
    amount,
    order_date,
    CASE
      WHEN amount >= 500
        THEN 'High'
      WHEN amount >= 100
        THEN 'Medium'
      ELSE 'Low'
    END AS order_tier,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY amount DESC) AS rank_in_category,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS rank_in_region
  
  FROM sample_data AS source_data

)

SELECT *

FROM enriched_data
