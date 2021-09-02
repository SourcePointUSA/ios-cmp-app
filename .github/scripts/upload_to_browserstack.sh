#!/bin/bash

set -eo pipefail

curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_KEY" -X POST "https://api-cloud.browserstack.com/app-live/upload" -F "file=@/Users/runner/work/ios-cmp-app/ios-cmp-app/Example/build/Unified-MetaApp.ipa"
