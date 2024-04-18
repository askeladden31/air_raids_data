with 

source as (

    select * from {{ source('staging_final', 'air_raid_official') }}

),

renamed as (

    select
        oblast as region,
        raion as subdivision,
        hromada as locality,
        level,
        started_at,
        finished_at,
        source

    from source

)

select * from renamed
