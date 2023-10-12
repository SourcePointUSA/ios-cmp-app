#!/bin/bash

# Creates the binaries which are distributed via SPM.

xcodebuild archive \
    -project ConsentViewController.xcodeproj \
    -scheme SPMConsentViewController-iOS \
    -destination 'generic/platform=iOS' \
    -archivePath './build/SPM/ConsentViewController-iOS' &&
xcodebuild archive \
    -project ConsentViewController.xcodeproj \
    -scheme SPMConsentViewController-iOS \
    -destination 'generic/platform=iOS Simulator' \
    -archivePath './build/SPM/ConsentViewController-iOS-simulator' &&
xcodebuild archive \
    -project ConsentViewController.xcodeproj \
    -scheme SPMConsentViewController-tvOS \
    -destination 'generic/platform=tvOS' \
    -archivePath './build/SPM/ConsentViewController-tvOS' &&
xcodebuild archive \
    -project ConsentViewController.xcodeproj \
    -scheme SPMConsentViewController-tvOS \
    -destination 'generic/platform=tvOS Simulator' \
    -archivePath './build/SPM/ConsentViewController-tvOS-simulator'

rm -r ./XCFramework/SPM/ConsentViewController.xcframework
rm -r ./XCFramework/SPM/ConsentViewController.xcframework.zip

xcodebuild -create-xcframework \
    -framework './build/SPM/ConsentViewController-iOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/SPM/ConsentViewController-iOS-simulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/SPM/ConsentViewController-tvOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/SPM/ConsentViewController-tvOS-simulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -output './XCFramework/SPM/ConsentViewController.xcframework'

zip -r ./XCFramework/SPM/ConsentViewController.xcframework.zip ./XCFramework/SPM/ConsentViewController.xcframework
