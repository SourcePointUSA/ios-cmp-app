#!/bin/bash

set -eo pipefail
cd /Users/runner/work/ios-cmp-app/ios-cmp-app/Example/
xcodebuild -archivePath "$PWD/build/SourcePointMetaApp.xcarchive" \
            -exportOptionsPlist "$PWD/SourcePointMetaApp/exportOptions.plist" \
            -exportPath "$PWD/build" \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty
