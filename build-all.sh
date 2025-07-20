#!/bin/bash

# Exit immediately if a command fails
set -e

# Make sure all dependencies are installed
npm install

# Clean up old builds and create the main output folder
rm -rf dist
mkdir dist

# If a 'public' folder with a landing page exists, copy it over
if [ -d "public" ]; then
  echo "Found public directory, copying contents..."
  cp -r public/* dist/
fi

# Find and build every 'lesson-*.md' file
for lessonfile in lesson-*.md; do
  # Get the name, like "lesson-01"
  name=$(basename -s .md "$lessonfile")
  
  echo "Building $lessonfile -> $name"

  # This is the correct build command. It creates a folder for the lesson
  # and sets the base path so it can find its own CSS and JS files.
  npx slidev build "$lessonfile" --out "dist/$name" --base "/$name/"
done

echo "All lessons built successfully!"
