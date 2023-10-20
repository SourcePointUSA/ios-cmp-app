#!/bin/bash

########### Creates the binaries which are distributed standalone
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

########### Creates the binaries which are distributed via SPM.
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
