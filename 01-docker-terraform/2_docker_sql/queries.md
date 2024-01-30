## Question 3
```sql
SELECT * 
  FROM green_taxi_data 
 WHERE lpep_pickup_datetime>'2019-09-18 00:00:00' AND lpep_dropoff_datetime<'2019-09-18 23:59:59';
```
## Question 4
```sql
SELECT trip_distance, index, lpep_pickup_datetime 
  FROM green_taxi_data 
 ORDER BY trip_distance DESC;
```
## Question 5
```sql
SELECT SUM(t."total_amount") as total_sum, zpu."Borough"  FROM green_taxi_data t, zones zpu
 WHERE t."lpep_pickup_datetime">'2019-09-18 00:00:00' AND t."lpep_pickup_datetime"<'2019-09-18 23:59:59' AND
 		t."PULocationID"= zpu."LocationID"
 GROUP BY zpu."Borough"
 ORDER BY total_sum DESC;
```
## Question 6

```sql
SELECT t."PULocationID", t."DOLocationID", tip_amount FROM green_taxi_data t, zones zpu, zones zdo
WHERE t."PULocationID"=zpu."LocationID" AND
	  t."DOLocationID"=zdo."LocationID" AND
	  t."PULocationID"=7
 ORDER BY tip_amount DESC;
 ```
 AND
```sql
 SELECT "LocationID", "Zone" FROM zones WHERE "LocationID"=132;
 ```