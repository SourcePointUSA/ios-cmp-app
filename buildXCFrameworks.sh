#!/bin/bash

assert_success() {
    local status=$?
    local process_name="$1"
    if [ "$status" -ne 0 ]; then
        echo "$process_name failed. Check ./build/build.log for more info."
        exit status
    fi
}

archive() {
    local project="$1"
    local scheme="$2"
    local destination="$3"
    local archivePath="$4"
    local linkerFlags="$5"
    printf "Archiving $project / $destination..."
    printf """
        xcodebuild archive \
        -quiet \
        -project "$project" \
        -scheme "$scheme" \
        -destination "$destination" \
        -archivePath "$archivePath" \
        -parallelizeTargets \
        -jobs 8 \
        OTHER_LDFLAGS="$linkerFlags" \
        OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES > ./build/build.log 2>&1
        """
    xcodebuild archive \
        -quiet \
        -project "$project" \
        -scheme "$scheme" \
        -destination "$destination" \
        -archivePath "$archivePath" \
        -parallelizeTargets \
        -jobs 8 \
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

archive "_Pods.xcodeproj" "ConsentViewController-tvOS" "generic/platform=tvOS" "./build/ConsentViewController-tvOS.framework-tvOS.xcarchive"

rm -r ./XCFramework/ConsentViewController.xcframework &> ./build/build.log 2>&1
rm -r ./XCFramework/ConsentViewController.xcframework.zip &> ./build/build.log 2>&1

echo "Archiving succeeded."
printf "Creating XCFrameworks"

xcodebuild -create-xcframework \
    -framework './build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-iOS.framework-iOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -framework './build/ConsentViewController-tvOS.framework-tvOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
    -output './XCFramework/ConsentViewController.xcframework' &> ./build/build.log 2>&1

echo "✅"
printf "Zipping XCFramework"

zip -r ./XCFramework/ConsentViewController.xcframework.zip ./XCFramework/ConsentViewController.xcframework &> ./build/build.log 2>&1

echo "✅"
echo "XCFrameworks created on: ./XCFramework/ConsentViewController.xcframework.zip"


# # ########### Creates the binaries which are distributed via SPM.
# echo "Generating XCFrameworks for SPM"
# archive "ConsentViewController.xcodeproj" "SPMConsentViewController-iOS" "generic/platform=iOS" "./build/SPM/ConsentViewController-iOS"

# archive "ConsentViewController.xcodeproj" "SPMConsentViewController-iOS" "generic/platform=iOS Simulator" "./build/SPM/ConsentViewController-iOS-simulator"

# archive "ConsentViewController.xcodeproj" "SPMConsentViewController-tvOS" "generic/platform=tvOS" "./build/SPM/ConsentViewController-tvOS"

# archive "ConsentViewController.xcodeproj" "SPMConsentViewController-tvOS" "generic/platform=tvOS Simulator" "./build/SPM/ConsentViewController-tvOS-simulator"

# echo "Archiving succeeded."
# printf "Creating XCFrameworks"

# rm -r ./XCFramework/SPM/ConsentViewController.xcframework &> ./build/build.log 2>&1
# rm -r ./XCFramework/SPM/ConsentViewController.xcframework.zip &> ./build/build.log 2>&1

# xcodebuild -create-xcframework \
#     -framework './build/SPM/ConsentViewController-iOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
#     -framework './build/SPM/ConsentViewController-iOS-simulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
#     -framework './build/SPM/ConsentViewController-tvOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
#     -framework './build/SPM/ConsentViewController-tvOS-simulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
#     -output './XCFramework/SPM/ConsentViewController.xcframework' &> ./build/build.log 2>&1

# echo "✅"
# printf "Zipping XCFramework"

# zip -r ./XCFramework/SPM/ConsentViewController.xcframework.zip ./XCFramework/SPM/ConsentViewController.xcframework &> ./build/build.log 2>&1

# echo "✅"
# echo "SPM XCFrameworks created on: ./XCFramework/SPM/ConsentViewController.xcframework.zip"
