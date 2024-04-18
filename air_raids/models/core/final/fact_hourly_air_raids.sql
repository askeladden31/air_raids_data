{{
    config(
        materialized='table'
    )
}}

  SELECT
    * 
  FROM
    {{ ref('fact_air_raids') }},
    UNNEST(GENERATE_ARRAY(EXTRACT(HOUR FROM started_at), EXTRACT(HOUR FROM finished_at))) AS hours