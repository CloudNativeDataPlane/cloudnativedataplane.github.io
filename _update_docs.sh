#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
# Copyright(c) 2022 Intel Corporation

set -euo pipefail

#
# This script builds documentation for this website from CNDP source
#

# Get repo name from command line arguments
[ "$1" ] || { echo "Usage: ${BASH_SOURCE[0]} <repo>"; exit 1; }
set -u
REPO=$1

# Directory containing this script
SCRIPT_DIR=$(realpath $(dirname ${BASH_SOURCE[0]}))

# Where the api documents are output
API_OUTDIR="$SCRIPT_DIR/api"

# Where the guide documents are output
GUIDE_OUTDIR="$SCRIPT_DIR/guide"

if [ -e $API_OUTDIR ]; then
  echo "Warning: Moving existing $API_OUTDIR to ${SCRIPT_DIR}/_api.bak"
  mv $API_OUTDIR ${SCRIPT_DIR}/_api.bak
fi

if [ -e $GUIDE_OUTDIR ]; then
  echo "Warning: Moving existing $GUIDE_OUTDIR to ${SCRIPT_DIR}/_guide.bak"
  mv $GUIDE_OUTDIR ${SCRIPT_DIR}/_guide.bak
fi

# Cleanup after ourselves
tmpdir=$(mktemp -d)
trap "{ rm -rf $tmpdir; }" EXIT

# Checkout latest tag
pushd $tmpdir
git clone $REPO cndp
CNDP_DIR="$tmpdir/cndp"
pushd $CNDP_DIR
git checkout $(git describe --abbrev=0)

# Guide requires custom template to insert link to the website
echo "templates_path = ['$SCRIPT_DIR/_guide/templates']" >> $CNDP_DIR/doc/guides/conf.py

# Build docs
make docs
popd
popd

#
# Post process api output
#

# Add custom header for the website navbar
API_DIR="$CNDP_DIR/builddir/doc/api"
echo "HTML_HEADER = ${SCRIPT_DIR}/_api/new_header.html" >> $API_DIR/doxy-api.conf

# Rebuild api reference with updated config
doxygen $API_DIR/doxy-api.conf

#
# Post process guide output
#

GUIDE_DIR="$CNDP_DIR/builddir/doc/guides/html"

# custom.css is only installed with "make install" but this script does not do that
mkdir $GUIDE_DIR/_static/css
cp -n $CNDP_DIR/doc/guides/custom.css $GUIDE_DIR/_static/css

# Replace leading underscores
mv $GUIDE_DIR/_images $GUIDE_DIR/images
mv $GUIDE_DIR/_sources $GUIDE_DIR/sources
mv $GUIDE_DIR/_static $GUIDE_DIR/static
find $GUIDE_DIR -name '*.html' -exec sed -i 's/_images/images/g' {} +
find $GUIDE_DIR -name '*.html' -exec sed -i 's/_sources/sources/g' {} +
find $GUIDE_DIR -name '*.html' -exec sed -i 's/_static/static/g' {} +

mv $GUIDE_DIR $GUIDE_OUTDIR
mv $API_DIR/api $API_OUTDIR
