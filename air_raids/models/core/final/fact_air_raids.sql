{{
    config(
        materialized='table'
    )
}}

with combined as
(
SELECT 
    started_at,
    finished_at,
    NULL as level,
    region,
    NULL as subdivision,
    NULL as locality,
FROM {{ ref("stg_staging_final__air_raid_volunteer") }}
WHERE started_at < (SELECT MIN(started_at) FROM {{ ref("stg_staging_final__air_raid_official") }})

UNION ALL

SELECT 
    started_at,
    finished_at,
    level,
    region,
    subdivision,
    locality,
FROM {{ ref("stg_staging_final__air_raid_official") }}
ORDER BY started_at
)

select
    {{ dbt_utils.generate_surrogate_key(['started_at', 'finished_at', 'region']) }} as event_id,
    *
FROM combined