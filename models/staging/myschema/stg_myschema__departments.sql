with 

source as (

    select * from {{ source('myschema', 'departments') }}

),

renamed as (

    select
        departmentid,
        departmentname,
        floor,
        headdoctorid

    from source

)

select * from renamed