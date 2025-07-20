#!/bin/bash

set -e

rm -rf dist
mkdir dist

if [ -d "public" ]; then
  echo "Found public directory, copying contents..."
  cp -r public/* dist/
fi

for lessonfile in lesson-*.md; do
  name=$(basename -s .md "$lessonfile")
  
  echo "Building $lessonfile -> $name"
  # FINAL ATTEMPT: Forcefully setting the route and public paths for assets.
  npx slidev build "$lessonfile" --out "dist/$name" --with-clicks --slidev-flags '{"routeBasePath":"/'"$name"'/", "publicPath":"/'"$name"'/"}'
done

echo "All lessons built successfully!"
