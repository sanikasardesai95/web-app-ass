#!/bin/bash

# Check if the cluster exists
if gcloud container clusters describe my-gke-cluster --zone us-central1-a &>/dev/null; then
  echo "Cluster already exists. Getting credentials..."
  gcloud container clusters get-credentials my-gke-cluster --zone us-central1-a
else
  echo "Cluster does not exist. Creating cluster..."
  gcloud container clusters create my-gke-cluster --zone us-central1-a --num-nodes 2 --enable-ip-alias --no-enable-basic-auth --metadata=disable-legacy-endpoints=true
fi
