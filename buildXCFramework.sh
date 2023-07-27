#!/bin/bash

xcodebuild archive \
    -scheme ConsentViewController-iOS \
    -destination 'generic/platform=iOS Simulator' \
    -archivePath './build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES &&
xcodebuild archive \
    -scheme ConsentViewController-tvOS \
    -destination 'generic/platform=tvOS Simulator' \
    -archivePath './build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES &&
xcodebuild -create-xcframework \
    -framework './build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-iOS.framework-iphoneos.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -output './XCFramework/ConsentViewController.xcframework'