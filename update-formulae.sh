#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "Getting latest version (pass an argument to override)..."

LATEST_VERSION=${1:-$(curl -sSL "https://www.pulumi.com/latest-version")}
DIST_URL="https://get.pulumi.com/releases/sdk/pulumi-v${LATEST_VERSION}-darwin-x64.tar.gz"

echo "Computing SHA256 hash of release (this may take a moment)..."

SHA256_SUM=$(curl -sSL ${DIST_URL} | sha256sum | cut -d' ' -f1)

echo "Updating formulae..."

sed -i -e "s|^  version \".*\"$|  version \""${LATEST_VERSION}"\"|g" ./pulumi.rb
sed -i -e "s|^  url \".*\"$|  url \""${DIST_URL}"\"|g" ./pulumi.rb
sed -i -e "s|^  sha256 \".*\"$|  sha256 \""${SHA256_SUM}"\"|g" ./pulumi.rb

echo "Done!"
