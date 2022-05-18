# #!/usr/bin/env bash

# Break build on error, prevents websites going offline in case of pelican errors
set -e

echo "Starting Pelican build of $WEBSITE"
cd $WEBSITE

# Build pelican website for deployment
pelican content -s publishconf.py

# Copy files for github
cp README.md output/README.md

if [[ -e .nojekyll ]]; then
  cp .nojekyll output/.nojekyll
fi

if [[ -e netlify.toml ]]; then
  cp netlify.toml output/netlify.toml
fi

if [[ -e robots.txt ]]; then
  cp robots.txt output/robots.txt
fi

# Remove individual calendar events
# These pages are generated by Pelican but we don't want them displayed on the website
# as individual files. Only the calendar overview has to be shown.
if [[ -d output/calendar ]]; then
  (cd output/calendar && ls | grep -v index.html | xargs rm -rf)
fi

# Go back to root directory
cd ..
