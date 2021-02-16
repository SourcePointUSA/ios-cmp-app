#!/bin/bash

set -euo pipefail
echo "META_APP_HOME=/Users/runner/work/ios-cmp-app/ios-cmp-app/Example/" >> $GITHUB_ENV
PodSpecFilePath=/Users/runner/work/ios-cmp-app/ios-cmp-app/ConsentViewController.podspec
ProjectFilePath=/Users/runner/work/ios-cmp-app/ios-cmp-app/Example/ConsentViewController.xcodeproj/project.pbxproj
sdk_version=`awk 'NR==3' $PodSpecFilePath`
export new_sdk_version=$(echo $sdk_version | cut -d "'" -f 2)
echo $new_sdk_version
meta_app_version=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $ProjectFilePath)
echo $meta_app_version
buildNumber=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $ProjectFilePath)
export buildNumber=$(($buildNumber + 1))
echo "BUILD_NUMBER=$new_sdk_version" >> $GITHUB_ENV
echo $buildNumber



