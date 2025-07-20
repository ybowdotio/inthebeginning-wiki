#!/bin/bash

set -e

rm -rf dist
mkdir dist

# NEW: Only try to copy files if the 'public' directory actually exists.
if [ -d "public" ]; then
  echo "Found public directory, copying contents..."
  cp -r public/* dist/
fi

for lessonfile in lesson-*.md; do
  name=$(basename -s .md "$lessonfile")
  
  echo "Building $lessonfile -> $name"
  npx slidev build "$lessonfile" --out "dist/$name" --base "/$name/"
done

echo "All lessons built successfully!"
