#!/bin/bash

set -eo pipefail
cd $META_APP_HOME
xcodebuild -archivePath "$PWD/build/SourcePointMetaApp.xcarchive" \
            -exportOptionsPlist "$PWD/SourcePointMetaApp/exportOptions.plist" \
            -exportPath "$PWD/build" \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty
