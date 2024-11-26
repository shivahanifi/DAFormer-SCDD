#!/bin/bash

# Docker image name to be used
IMAGE_NAME="daformer-scdd"

# Get the container ID for the specific image
CONTAINER_ID=$(docker ps -q --filter "ancestor=$IMAGE_NAME")
echo "Container id is: $CONTAINER_ID"

# Check if a container with the given image is running
if [ -z "$CONTAINER_ID" ]; then
  echo "No container found running the image '$IMAGE_NAME'."
  exit 1
fi

# PRETRAINED_MODELS
# Copy pretrained_models to pretrained directory downloaded from https://connecthkuhk-my.sharepoint.com/personal/xieenze_connect_hku_hk/_layouts/15/onedrive.aspx?id=%2Fpersonal%2Fxieenze%5Fconnect%5Fhku%5Fhk%2FDocuments%2Fsegformer%2Fpretrained%5Fmodels&ga=1
# Get a list of files to copy (you can use * or specify a list)
if ! test -d /home/shiva/Desktop/pretrained_models; then
    echo "pretrained_models are not downloaded. Exiting..."
    exit 1
fi

FILES=$(ls /home/shiva/Desktop/pretrained_models)

# Loop through each file and check if it already exists in the container
for FILE in $FILES; do
  # Full path of the source file
  SOURCE_FILE="/home/shiva/Desktop/pretrained_models/$FILE"
  
  # Full path of the destination file inside the container
  DEST_FILE="/DAFormer-SCDD/pretrained/$FILE"
  
  # Check if the file already exists inside the container
  if docker exec "$CONTAINER_ID" test -f "$DEST_FILE"; then
    echo "File '$FILE' already exists inside the container. Skipping..."
  else
    # If the file doesn't exist, copy it
    echo "Copying '$FILE' to the container..."
    docker cp "$SOURCE_FILE" "$CONTAINER_ID:$DEST_FILE"
  fi
done
echo "Pretrained models copied to $CONTAINER_ID:/DAFormer-SCDD/pretrained"

## Navigate to work_dirs download and extract files
#docker exec -it "$CONTAINER_ID" bash -c "
#    cd /DAFormer-SCDD/work_dirs && \
#    echo 'Downloading file from Google Drive...' && \
#    wget --no-check-certificate https://drive.google.com/uc?export=download&id=1pG3kDClZDGwp1vSTEXmTchkGHmnLQNdP
# -O downloaded_file.zip || \
#    curl -L https://drive.google.com/uc?export=download&id=1pG3kDClZDGwp1vSTEXmTchkGHmnLQNdP
# -o downloaded_file.zip
#    "
#

# WORK_DIRS
# Copy tar.gz fiel to work_dirs directory downloaded from https://drive.google.com/file/d/1pG3kDClZDGwp1vSTEXmTchkGHmnLQNdP/view
if ! test -f /home/shiva/Desktop/211108_1622_gta2cs_daformer_s0_7f24c.tar.gz; then
    echo "211108_1622_gta2cs_daformer_s0_7f24c.tar.gz is not downloaded. Exiting..."
    exit 1
fi

# Check if the file already exists inside the container
if docker exec "$CONTAINER_ID" test -f "/DAFormer-SCDD/work_dirs/211108_1622_gta2cs_daformer_s0_7f24c.tar.gz"; then
    echo "File 211108_1622_gta2cs_daformer_s0_7f24c.tar.gz already exists inside the container. Skipping..."
else
    docker cp /home/shiva/Desktop/211108_1622_gta2cs_daformer_s0_7f24c.tar.gz "$CONTAINER_ID:/DAFormer-SCDD/work_dirs"
fi

echo "The .tar.gz file copied into the work_dirs directory"

# unzip and remove the zip file
docker exec -it "$CONTAINER_ID" bash -c "
    cd /DAFormer-SCDD/work_dirs && \
    tar -xzvf 211108_1622_gta2cs_daformer_s0_7f24c.tar.gz &&\
    rm 211108_1622_gta2cs_daformer_s0_7f24c.tar.gz
    "
echo "work_dirs files unzipped and original file deleted"

# CITYSCAPES DATASET
# GTA DATASET
