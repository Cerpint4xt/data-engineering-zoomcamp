{{ config(materialized='view') }}
 
with tripdata as 
(
  select *,
    row_number() over(partition by pickup_datetime) as rn
  from {{ source('staging','fhv_tripdata_rc') }}
  where pickup_datetime between '2019-01-01' AND '2019-12-31' 
)
select
   -- identifiers
   {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
   {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,
   
   -- timestamps
   cast("pickup_datetime" as timestamp) as pickup_datetime,
   cast("dropOff_datetime" as timestamp) as dropoff_datetime,

   dispatching_base_num,
   "SR_Flag" as sr_flag,
   "Affiliated_base_number" as affiliated_base_number
    
from tripdata
where rn = 1

-- dbt build --select <model.sql> --vars '{'is_test_run: false}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}