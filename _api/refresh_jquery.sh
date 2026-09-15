#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause

set -euo pipefail

API_DIR=${1:?Usage: refresh_jquery.sh <api-dir> <guide-static-dir>}
GUIDE_STATIC_DIR=${2:?Usage: refresh_jquery.sh <api-dir> <guide-static-dir>}
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
JQUERY_VERSION=3.7.1
JQUERY_SOURCE="$SCRIPT_DIR/jquery-${JQUERY_VERSION}.min.js"

API_JQUERY="$API_DIR/jquery.js"
GUIDE_JQUERY="$GUIDE_STATIC_DIR/jquery.js"

if [ ! -f "$API_JQUERY" ]; then
  echo "Missing generated API jQuery bundle: $API_JQUERY" >&2
  exit 1
fi

if [ ! -d "$GUIDE_STATIC_DIR" ]; then
  echo "Missing generated guide static directory: $GUIDE_STATIC_DIR" >&2
  exit 1
fi

if [ ! -f "$JQUERY_SOURCE" ]; then
  echo "Missing pinned jQuery source: $JQUERY_SOURCE" >&2
  exit 1
fi

if ! head -c 200 "$JQUERY_SOURCE" | grep -Fq "jQuery v${JQUERY_VERSION}"; then
  echo "Pinned jQuery source does not identify as version ${JQUERY_VERSION}" >&2
  exit 1
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

api_tail="$tmpdir/api-jquery-tail.js"
api_bundle="$tmpdir/api-jquery.js"

# Preserve the Doxygen-bundled plugins while replacing only the jQuery core.
awk '
  match($0, /\/\*! jQuery UI/) {
    copy = 1
    print substr($0, RSTART)
    next
  }
  copy
' "$API_JQUERY" > "$api_tail"

for marker in 'jQuery UI - v' '$.scrollTo=' 'PowerTip v' \
  'jQuery UI Touch Punch' 'SmartMenus jQuery Plugin'; do
  if ! grep -Fq "$marker" "$api_tail"; then
    echo "Generated API jQuery bundle is missing expected plugin: $marker" >&2
    exit 1
  fi
done

cat "$JQUERY_SOURCE" "$api_tail" > "$api_bundle"
mv "$api_bundle" "$API_JQUERY"
cp "$JQUERY_SOURCE" "$GUIDE_JQUERY"
rm -f "$GUIDE_STATIC_DIR/jquery-3.5.1.js"
