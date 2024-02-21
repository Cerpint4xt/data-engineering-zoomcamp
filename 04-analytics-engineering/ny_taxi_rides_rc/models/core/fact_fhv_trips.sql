{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata_rc as (
    select *,
    'fhv' as service_type
    from {{ ref('stg_fhv_tripdata_rc') }}
    where pickup_locationid is not null and dropoff_locationid is not null 
),  
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select 
    fhv_tripdata_rc.pickup_datetime as pickup_datetime,
    fhv_tripdata_rc.dropOff_datetime as dropoff_datetime,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone  
from fhv_tripdata_rc
inner join dim_zones as pickup_zone
on fhv_tripdata_rc.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv_tripdata_rc.dropoff_locationid = dropoff_zone.locationid
