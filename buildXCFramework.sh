#!/bin/bash

xcodebuild archive \
    -project _Pods.xcodeproj \
    -scheme ConsentViewController-iOS \
    -destination 'generic/platform=iOS' \
    -archivePath './build/ConsentViewController-iOS.framework-iOS.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
xcodebuild archive \
    -project _Pods.xcodeproj \
    -scheme ConsentViewController-iOS \
    -destination 'generic/platform=iOS Simulator' \
    -archivePath './build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES &&
xcodebuild archive \
    -project _Pods.xcodeproj \
    -scheme ConsentViewController-tvOS \
    -destination 'generic/platform=tvOS Simulator' \
    -archivePath './build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES &&
xcodebuild archive \
    -project _Pods.xcodeproj \
    -scheme ConsentViewController-tvOS \
    -destination 'generic/platform=tvOS' \
    -archivePath './build/ConsentViewController-tvOS.framework-tvOS.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES &&

rm -r ./XCFramework/ConsentViewController.xcframework
rm -r ./XCFramework/ConsentViewController.xcframework.zip

xcodebuild -create-xcframework \
    -framework './build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-iOS.framework-iOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-tvOS.framework-tvOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -output './XCFramework/ConsentViewController.xcframework'

zip -r ./XCFramework/ConsentViewController.xcframework.zip ./XCFramework/ConsentViewController.xcframework