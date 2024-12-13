#!/bin/bash

# Remote host details
REMOTE_HOST="shanifi@pc-ubix.uni.lux"  
REMOTE_PATH="/home/shanifi/code/DAFormer-SCDD" 
IMAGE_NAME="daformer-scdd"

# Get the container ID for the specific image on the remote host
CONTAINER_ID=$(ssh "$REMOTE_HOST" "docker ps -q --filter \"ancestor=$IMAGE_NAME\"")
echo "Container id is: $CONTAINER_ID"

# Check if a container with the given image is running
if [ -z "$CONTAINER_ID" ]; then
  echo "No container found running the image '$IMAGE_NAME'."
  exit 1
fi

# PRETRAINED_MODELS
# Check if the pretrained_models are available locally
if ! test -d /home/shiva/Desktop/pretrained_models; then
    echo "pretrained_models are not downloaded. Exiting..."
    exit 1
fi

# Copy pretrained models to the remote machine
FILES=$(ls /home/shiva/Desktop/pretrained_models)
for FILE in $FILES; do
  SOURCE_FILE="/home/shiva/Desktop/pretrained_models/$FILE"
  DEST_FILE="$REMOTE_PATH/pretrained/$FILE"

  # Check if the file already exists inside the container
  if ssh "$REMOTE_HOST" "docker exec $CONTAINER_ID test -f $DEST_FILE"; then
    echo "File '$FILE' already exists inside the container. Skipping..."
  else
    # If the file doesn't exist, copy it
    echo "Copying '$FILE' to the remote container..."
    rsync -avz "$SOURCE_FILE" "$REMOTE_HOST:$DEST_FILE"
    ssh "$REMOTE_HOST" "docker cp $DEST_FILE $CONTAINER_ID:/DAFormer-SCDD/pretrained"
  fi
done
echo "Pretrained models copied to $CONTAINER_ID:/DAFormer-SCDD/pretrained"

# WORK_DIRS
# Copy tar.gz file to work_dirs directory
if ! test -f /home/shiva/Desktop/211108_1622_gta2cs_daformer_s0_7f24c.tar.gz; then
    echo "211108_1622_gta2cs_daformer_s0_7f24c.tar.gz is not downloaded. Exiting..."
    exit 1
fi

# Copy tar.gz file to remote machine
TAR_FILE="/home/shiva/Desktop/211108_1622_gta2cs_daformer_s0_7f24c.tar.gz"
DEST_TAR_FILE="$REMOTE_PATH/work_dirs/211108_1622_gta2cs_daformer_s0_7f24c.tar.gz"

if ssh "$REMOTE_HOST" "docker exec $CONTAINER_ID test -f $DEST_TAR_FILE"; then
    echo "Tar file already exists inside the container. Skipping..."
else
    rsync -avz "$TAR_FILE" "$REMOTE_HOST:$DEST_TAR_FILE"
    ssh "$REMOTE_HOST" "docker cp $DEST_TAR_FILE $CONTAINER_ID:/DAFormer-SCDD/work_dirs"
    # unzip and remove the tar file
    ssh "$REMOTE_HOST" "docker exec -it $CONTAINER_ID bash -c '
    cd /DAFormer-SCDD/work_dirs && \
    tar -xzvf 211108_1622_gta2cs_daformer_s0_7f24c.tar.gz &&\
    rm 211108_1622_gta2cs_daformer_s0_7f24c.tar.gz '"
    echo "work_dirs files unzipped and original file deleted"
fi

# CITYSCAPES DATASET
if [[ ! -f /home/shiva/Desktop/leftImg8bit_trainvaltest.zip && ! -f /home/shiva/Desktop/gtFine_trainvaltest.zip ]]; then 
    echo "Cityscapes dataset is not downloaded. Exiting..."
    exit 1
fi

if ssh "$REMOTE_HOST" "docker exec $CONTAINER_ID test -d '/DAFormer-SCDD/data/cityscapes/gtFine'"; then
    echo "Cityscapes data exists, skipping..."
else
    ssh "$REMOTE_HOST" "docker exec -it $CONTAINER_ID bash -c 'mkdir -p /DAFormer-SCDD/data/cityscapes'"
    ssh "$REMOTE_HOST" "docker cp /home/shiva/Desktop/leftImg8bit_trainvaltest.zip $CONTAINER_ID:/DAFormer-SCDD/data/cityscapes/"

    ssh "$REMOTE_HOST" "docker cp /home/shiva/Desktop/gtFine_trainvaltest.zip "$CONTAINER_ID:/DAFormer-SCDD/data/cityscapes"
    
    ssh "$REMOTE_HOST" "docker exec -it $CONTAINER_ID bash -c '
    cd /DAFormer-SCDD/data/cityscapes && \
    unzip leftImg8bit_trainvaltest.zip && \
    unzip gtFine_trainvaltest.zip && \
    rm leftImg8bit_trainvaltest.zip gtFine_trainvaltest.zip
    '"
    echo "Cityscapes dataset copied, unzipped, and original files deleted"
fi

ssh "$REMOTE_HOST" "docker exec -it $CONTAINER_ID bash -c 'python tools/convert_datasets/cityscapes.py data/cityscapes --nproc 8'"

## GTA DATASET
#if [[ ! -f /home/shiva/Desktop/10_images.zip && ! -f /home/shiva/Desktop/10_labels.zip ]]; then 
#    echo "GTA dataset is not downloaded. Exiting..."
#    exit 1
#fi
#
#if ssh "$REMOTE_HOST" "docker exec $CONTAINER_ID test -d '/DAFormer-SCDD/data/gta/images'"; then
#    echo "GTA data exists, skipping..."
#else
#    ssh "$REMOTE_HOST" "docker exec -it $CONTAINER_ID bas -c 'mkdir -p /DAFormer-SCDD/data/gta'"
#    for f in /home/shiva/Desktop/*_images.zip; do
#        scp "$f" "$REMOTE_HOST:/DAFormer-SCDD/data/gta"
#    done
#    echo "GTA image zip files copied"
#    
#    for f in /home/shiva/Desktop/*_labels.zip; do
#        scp "$f" "$REMOTE_HOST:/DAFormer-SCDD/data/gta"
#    done
#    echo "GTA label zip files copied"
#
#    # unzip and remove the zip files
#    ssh "$REMOTE_HOST" "docker exec -it $CONTAINER_ID bash -c '
#    cd /DAFormer-SCDD/data/gta && \
#    unzip \"*.zip\" && \
#    rm *.zip
#    '"
#    echo "GTA dataset copied, unzipped, and original files deleted"
#fi
#
#ssh "$REMOTE_HOST" "docker exec -it $CONTAINER_ID bash -c 'python tools/convert_datasets/gta.py data/gta --nproc 8'"

