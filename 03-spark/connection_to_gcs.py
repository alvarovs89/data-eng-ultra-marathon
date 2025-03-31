#!/usr/bin/env python
# coding: utf-8

# Import necessary PySpark modules
import pyspark
from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark.context import SparkContext
from pyspark.sql.functions import (
    avg, round, count, regexp_extract, when, col, floor, lit, concat, create_map
)

# Define the location of Google Cloud credentials and JAR files for connectors
# credentials_location = '../.google/credentials/my-creds.json'
# jar_connector = 'gs://ultra-marathon-bucket/jars/gcs-connector-hadoop3-2.2.5.jar'
# # jar_connector = 'gs://ultra-marathon-bucket/jars/gcs-connector-hadoop3-latest.jar'
# bigquery_connector = 'gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.24.0.jar'

# Configure Spark with necessary settings
conf = SparkConf() \
    .setAppName('test') \
    .set('spark.hadoop.google.cloud.auth.service.account.enable', 'true')
        # .set('spark.jars', f'{jar_connector},{bigquery_connector}') \


# Initialize SparkContext
sc = SparkContext(conf=conf)

# Access Hadoop configuration for SparkContext
hadoop_conf = sc._jsc.hadoopConfiguration()\


# Create a SparkSession
spark = SparkSession.builder \
    .config(conf=sc.getConf()) \
    .getOrCreate()
    

    
print("Spark session created successfully.")
print("Starting the transformation process.")
# Load the input Parquet file from Google Cloud Storage
df_ultra = spark.read.parquet('gs://ultra-marathon-bucket/TWO_CENTURIES_OF_UM_RACES.parquet')

# Step 1: Extract country code from event name using regex
df_ultra = df_ultra.withColumn("event_country_code", regexp_extract("event_name", r"\((\w{3})\)", 1))

# Step 2: Create a new column to classify the event type based on distance or time
df_ultra = df_ultra.withColumn(
    "event_type",
    when(col("event_distance_length").like("%km"), "distance")
    .when(col("event_distance_length").like("%mi"), "distance")
    .when(col("event_distance_length").like("%h"), "time")
    .otherwise("unknown")
)

# Step 3: Create a new column to bucket events into decades
df_ultra = df_ultra.withColumn(
    "event_decade",
    concat((floor(col("year_of_event") / 10) * 10).cast("string"), lit("s"))
)

# Step 4: Calculate gender counts per event and pivot the data
gender_counts = df_ultra.groupBy(
    "year_of_event", 
    "event_dates", 
    "event_name", 
    "event_distance_length", 
    "athlete_gender"
).count().groupBy(
    "year_of_event", 
    "event_dates", 
    "event_name", 
    "event_distance_length"
).pivot("athlete_gender").sum("count")

# Step 5: Perform final aggregation to calculate average speed and athlete count
events_avg_speed_df = df_ultra.groupBy(
    "year_of_event", 
    "event_dates", 
    "event_name", 
    "event_distance_length",
    "event_country_code",
    "event_type",
    "event_decade"
).agg(
    round(avg("athlete_average_speed"), 3).alias("average_event_speed"),
    count("*").alias("num_athletes")
)

# Step 6: Join gender count to final result
events_avg_speed_df = events_avg_speed_df.join(
    gender_counts,
    on=["year_of_event", "event_dates", "event_name", "event_distance_length"],
    how="left"
)


print("Transformation process completed successfully.")

# Step 7: Write the transformed DataFrame to BigQuery
print("Writing to BigQuery...")


project_id = 'de-zoomcamp-ultra-marathon'
dataset_id = 'ultra_marathon_dataset'
distinct_events = 'distinct_events' 

spark.conf.set("temporaryGcsBucket", "dataproc-temp-au-southeast1-168155596421-dcob3bve")
spark.conf.set("viewsEnabled", "true")
spark.conf.set("materializationDataset", dataset_id)

events_avg_speed_df.write \
    .format('bigquery') \
    .option('table', f'{project_id}.{dataset_id}.{distinct_events}') \
    .mode("overwrite") \
    .save()
        # .option('temporaryGcsBucket', 'ultra-marathon-bucket') \

    
spark.stop()