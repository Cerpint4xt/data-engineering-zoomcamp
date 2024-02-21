{{ config(materialized='view') }}
 
with fhvdata as 
(
  select *,
    row_number() over(partition by pickup_datetime) as rn
  from {{ source('staging','fhv_tripdata_rc') }}
  where pickup_datetime between '2019-01-01 00:00:00' AND '2019-12-31 23:59:59' 
)
select
   -- identifiers
   --{{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as fhvid,
   {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
   {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,
   
   -- timestamps
   pickup_datetime as pickup_datetime,
   dropOff_datetime as dropoff_datetime,

   cast(dispatching_base_num as string) as dispatching_base_num,
   cast("SR_Flag" as string) as sr_flag,
   cast("Affiliated_base_number" as string) as affiliated_base_number
    
from fhvdata

-- dbt build --select <model.sql> --vars '{'is_test_run: false}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}