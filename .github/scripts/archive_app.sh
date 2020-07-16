#!/bin/bash

set -eo pipefail
cd /Users/runner/work/ios-cmp-app/ios-cmp-app/Example/
xcodebuild -workspace "ConsentViewController.xcworkspace" \
            -scheme "SourcePointMetaApp" \
            -sdk "iphoneos" \
            -configuration "AppStoreDistribution" \
            -archivePath "$PWD/build/SourcePointMetaApp.xcarchive" \
            clean archive | xcpretty
