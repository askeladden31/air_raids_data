with 

source as (

    select * from {{ source('staging_final', 'air_raid_volunteer') }}

),

renamed as (

    select
        region,
        started_at,
        finished_at,
        naive

    from source

)

select * from renamed
