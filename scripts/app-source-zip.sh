#!/bin/bash

# Define the source folder
SOURCE_FOLDER="source"

# Name of the zip file
ZIP_FILE="$SOURCE_FOLDER/app.zip"

# Path to the Dockerfile
DOCKERFILE_PATH="dockerfiles/2048Game.Dockerfile"

# Check if the source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
  echo "Source folder '$SOURCE_FOLDER' does not exist. Creating it..."
  mkdir -p "$SOURCE_FOLDER"
fi

# Copy the Dockerfile to the current directory with the name "Dockerfile"
cp "$DOCKERFILE_PATH" "Dockerfile"

# Zip the Dockerfile and place it in the 'source' folder
echo "Zipping Dockerfile and placing it in $ZIP_FILE..."
zip -j "$ZIP_FILE" "Dockerfile"

# Clean up the temporary Dockerfile
rm "Dockerfile"

echo "Zip file created: $ZIP_FILE"
