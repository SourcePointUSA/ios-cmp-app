#!/bin/bash

set -eo pipefail
cd /Users/runner/work/ios-cmp-app/ios-cmp-app/Example/
xcrun altool --upload-app -t ios -f build/SourcePointMetaApp.ipa -u "$APP_STORE_CONNECT_USERNAME" -p "$APP_STORE_CONNECT_PASSWORD" --verbose
