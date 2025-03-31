#!/bin/bash

# Variables
CLUSTER_NAME="ultra-marathon-cluster"
REGION="australia-southeast1"
PYSPARK_SCRIPT="gs://ultra-marathon-bucket/code/connection_to_gcs.py"

# Submit PySpark Job to Dataproc
gcloud dataproc jobs submit pyspark "$PYSPARK_SCRIPT" \
    --cluster="$CLUSTER_NAME" \
    --region="$REGION" \
    --jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar
    # --jars=gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.34.1.jar
    # --jars=gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.34.1.jar,gs://ultra-marathon-bucket/jars/gcs-connector-hadoop3-latest.jar
# gs://ultra-marathon-bucket/jars/gcs-connector-hadoop3-latest.jar,
# echo "PySpark job submitted successfully to cluster: $CLUSTER_NAME"