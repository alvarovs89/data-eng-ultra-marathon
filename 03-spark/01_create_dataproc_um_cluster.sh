#!/bin/bash

# Exit on error
set -e

# Check for gcloud CLI
if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud CLI not found. Please install and initialize it before running this script."
    exit 1
fi
# Set variables
PROJECT_ID="de-zoomcamp-ultra-marathon"
CLUSTER_NAME="ultra-marathon-cluster"
REGION="australia-southeast1"
IMAGE_VERSION="2.0-debian10"
MACHINE_TYPE="n1-standard-2"
DISK_SIZE="30GB"

# Authenticate with GCP (if not already authenticated)
echo "🔐 Authenticating with GCP..."
gcloud auth application-default login

# Create the Dataproc cluster
echo "🚀 Creating Dataproc cluster '$CLUSTER_NAME'..."
gcloud dataproc clusters create "$CLUSTER_NAME" \
    --region="$REGION" \
    --master-machine-type="$MACHINE_TYPE" \
    --master-boot-disk-size="$DISK_SIZE" \
    --image-version="$IMAGE_VERSION" \
    --project="$PROJECT_ID"
    --num-workers=2 
        # --single-node \


echo "✅ Dataproc cluster '$CLUSTER_NAME' created successfully!"