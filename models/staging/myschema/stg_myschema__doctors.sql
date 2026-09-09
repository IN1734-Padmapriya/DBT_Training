with 

source as (

    select * from {{ source('myschema', 'doctors') }}

),

renamed as (

    select
        doctorid,
        name,
        specialization,
        department,
        yearsofexperience

    from source

)

select * from renamed