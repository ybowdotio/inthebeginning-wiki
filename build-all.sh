#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Clean up the old build output and create a fresh dist folder
rm -rf dist
mkdir dist

# Create a main landing page for all the lessons
# (We'll create the index.html for this in the public folder)
cp -r public/* dist/

# Find every file that starts with 'lesson-' and ends with '.md'
for lessonfile in lesson-*.md; do
  # Get the base name of the file (e.g., "lesson-01")
  name=$(basename -s .md "$lessonfile")
  
  # Build the slide deck and put it in a subfolder (e.g., dist/lesson-01)
  echo "Building $lessonfile -> $name"
  npx slidev build "$lessonfile" --out "dist/$name" --base "/$name/"
done

echo "All lessons built successfully!"
