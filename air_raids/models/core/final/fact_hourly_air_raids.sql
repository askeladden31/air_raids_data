{{
    config(
        materialized='table'
    )
}}

  SELECT
    * 
  FROM
    {{ ref('fact_air_raids') }},
    UNNEST(
      CASE
        WHEN EXTRACT(DAY FROM started_at) = EXTRACT(DAY FROM finished_at) THEN GENERATE_ARRAY(EXTRACT(HOUR FROM started_at), EXTRACT(HOUR FROM finished_at))
        ELSE ARRAY_CONCAT(
          GENERATE_ARRAY(EXTRACT(HOUR FROM started_at), 23),
          GENERATE_ARRAY(0, EXTRACT(HOUR FROM finished_at))
        )
      END
    ) AS hours