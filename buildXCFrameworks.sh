#!/bin/bash

assert_success() {
    local status=$?
    local process_name="$1"
    if [ "$status" -ne 0 ]; then
        echo "$process_name failed. Check ./build/build.log for more info."
        exit $status
    fi
}

archive() {
    local project="$1"
    local scheme="$2"
    local destination="$3"
    local archivePath="$4"
    printf "Archiving $project / $destination..."
    xcodebuild archive \
        -quiet \
        -project "$project" \
        -scheme "$scheme" \
        -destination "$destination" \
        -archivePath "$archivePath" \
        -parallelizeTargets \
        -jobs 8 \
        SWIFT_VERSION=5 \
        OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES > ./build/build.log 2>&1
    assert_success "Archiving $destination"
    echo "✅"
}


########### Creates the binaries which are distributed standalone
echo "Generating Standalone XCFrameworks"
archive "_Pods.xcodeproj" "ConsentViewController-iOS" "generic/platform=iOS" "./build/ConsentViewController-iOS.framework-iOS.xcarchive"

archive "_Pods.xcodeproj" "ConsentViewController-iOS" "generic/platform=iOS Simulator" "./build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive"

archive "_Pods.xcodeproj" "ConsentViewController-tvOS" "generic/platform=tvOS Simulator" "./build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive"

archive "_Pods.xcodeproj" "ConsentViewController-tvOS" "generic/platform=tvOS" "./build/ConsentViewController-tvOS.framework.xcarchive"

rm -r ./build/ConsentViewController.xcframework &> ./build/build.log 2>&1
rm -r ./build/ConsentViewController.xcframework.zip &> ./build/build.log 2>&1

echo "Archiving succeeded."
printf "Creating XCFrameworks"

xcodebuild -create-xcframework \
    -framework './build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-iOS.framework-iOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-tvOS.framework-tvOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -output './build/ConsentViewController.xcframework' &> ./build/build.log 2>&1

echo "✅"
printf "Zipping XCFramework"

zip -r ./build/ConsentViewController.xcframework.zip ./build/ConsentViewController.xcframework &> ./build/build.log 2>&1

echo "✅"
echo "XCFrameworks created on: ./build/ConsentViewController.xcframework.zip"

# ########### Creates the binaries which are distributed via SPM.
echo "Generating XCFrameworks for SPM"
archive "ConsentViewController.xcodeproj" "SPMConsentViewController-iOS" "generic/platform=iOS" "./build/SPM/ConsentViewController-iOS"

archive "ConsentViewController.xcodeproj" "SPMConsentViewController-iOS" "generic/platform=iOS Simulator" "./build/SPM/ConsentViewController-iOS-simulator"

archive "ConsentViewController.xcodeproj" "SPMConsentViewController-tvOS" "generic/platform=tvOS" "./build/SPM/ConsentViewController-tvOS"

archive "ConsentViewController.xcodeproj" "SPMConsentViewController-tvOS" "generic/platform=tvOS Simulator" "./build/SPM/ConsentViewController-tvOS-simulator"

echo "Archiving succeeded."
printf "Creating XCFrameworks"

rm -r ./build/SPMConsentViewController.xcframework.zip &> ./build/build.log 2>&1
rm -r ./build/SPMConsentViewController.xcframework &> ./build/build.log 2>&1

xcodebuild -create-xcframework \
    -framework './build/SPM/ConsentViewController-iOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/SPM/ConsentViewController-iOS-simulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/SPM/ConsentViewController-tvOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/SPM/ConsentViewController-tvOS-simulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -output './build/SPMConsentViewController.xcframework' &> ./build/build.log 2>&1

echo "✅"
printf "Zipping XCFramework"

zip -r ./build/SPMConsentViewController.xcframework.zip ./build/SPMConsentViewController.xcframework &> ./build/build.log 2>&1
echo "✅"
echo "XCFrameworks created on: ./build/SPMConsentViewController.xcframework.zip"
