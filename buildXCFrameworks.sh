#!/bin/bash


BUILD_LOG="./build/build.log"

# Determine optimal parallel jobs for xcodebuild
XCODE_JOBS=${XCODE_JOBS:-$(sysctl -n hw.logicalcpu 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null)}
if [ -z "$XCODE_JOBS" ]; then
    XCODE_JOBS=8
fi

assert_success() {
    local status=$?
    local process_name="$1"
    if [ "$status" -ne 0 ]; then
        echo "$process_name failed. Check $BUILD_LOG for more info."
        exit $status
    fi
}

archive() {
    local project="$1"
    local scheme="$2"
    local destination="$3"
    local archivePath="$4"
    local logPath="$5"
    local derivedDataPath="$6"
    printf "Archiving $project / $destination..."
    xcodebuild archive \
        -quiet \
        -project "$project" \
        -scheme "$scheme" \
        -destination "$destination" \
        -archivePath "$archivePath" \
        -parallelizeTargets \
        -jobs "$XCODE_JOBS" \
        -derivedDataPath "$derivedDataPath" \
        SWIFT_VERSION=5 \
        OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" \
        COMPILER_INDEX_STORE_ENABLE=NO \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES > "$logPath" 2>&1
    assert_success "Archiving $destination (log: $logPath)"
    echo "✅"
}


build_standalone() {
    echo "Generating Standalone XCFrameworks"
    mkdir -p ./build
    BUILD_LOG="./build/build-standalone.log"
    # Run archives in parallel with isolated DerivedData and logs
    archive "_Pods.xcodeproj" "ConsentViewController-iOS" "generic/platform=iOS" "./build/ConsentViewController-iOS.framework-iOS.xcarchive" "./build/log-standalone-ios-device.log" "./build/DerivedData-standalone-ios" &
    pid_ios_device=$!
    archive "_Pods.xcodeproj" "ConsentViewController-iOS" "generic/platform=iOS Simulator" "./build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive" "./build/log-standalone-ios-sim.log" "./build/DerivedData-standalone-ios-sim" &
    pid_ios_sim=$!
    archive "_Pods.xcodeproj" "ConsentViewController-tvOS" "generic/platform=tvOS Simulator" "./build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive" "./build/log-standalone-tvos-sim.log" "./build/DerivedData-standalone-tvos-sim" &
    pid_tvos_sim=$!
    archive "_Pods.xcodeproj" "ConsentViewController-tvOS" "generic/platform=tvOS" "./build/ConsentViewController-tvOS.framework.xcarchive" "./build/log-standalone-tvos-device.log" "./build/DerivedData-standalone-tvos" &
    pid_tvos_device=$!
    wait $pid_ios_device
    wait $pid_ios_sim
    wait $pid_tvos_sim
    wait $pid_tvos_device
    echo "Archiving succeeded."
    printf "Creating XCFrameworks"
    xcodebuild -create-xcframework \
        -framework './build/ConsentViewController-iOS.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
        -framework './build/ConsentViewController-iOS.framework-iOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
        -framework './build/ConsentViewController-tvOS.framework-tvossimulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
        -framework './build/ConsentViewController-tvOS.framework.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
        -output './build/ConsentViewController.xcframework' &> "$BUILD_LOG" 2>&1
    echo "✅"
    printf "Zipping XCFramework"
    ditto -c -k --sequesterRsrc --keepParent ./build/ConsentViewController.xcframework ./build/ConsentViewController.xcframework.zip &> "$BUILD_LOG" 2>&1
    echo "✅"
    echo "XCFrameworks created on: ./build/ConsentViewController.xcframework.zip"
}

build_spm() {
    echo "Generating XCFrameworks for SPM"
    mkdir -p ./build/SPM
    BUILD_LOG="./build/build-spm.log"
    # Run archives in parallel with isolated DerivedData and logs
    archive "ConsentViewController.xcodeproj" "SPMConsentViewController-iOS" "generic/platform=iOS" "./build/SPM/ConsentViewController-iOS" "./build/log-spm-ios-device.log" "./build/DerivedData-spm-ios" &
    pid_ios_device=$!
    archive "ConsentViewController.xcodeproj" "SPMConsentViewController-iOS" "generic/platform=iOS Simulator" "./build/SPM/ConsentViewController-iOS-simulator" "./build/log-spm-ios-sim.log" "./build/DerivedData-spm-ios-sim" &
    pid_ios_sim=$!
    archive "ConsentViewController.xcodeproj" "SPMConsentViewController-tvOS" "generic/platform=tvOS" "./build/SPM/ConsentViewController-tvOS" "./build/log-spm-tvos-device.log" "./build/DerivedData-spm-tvos" &
    pid_tvos_device=$!
    archive "ConsentViewController.xcodeproj" "SPMConsentViewController-tvOS" "generic/platform=tvOS Simulator" "./build/SPM/ConsentViewController-tvOS-simulator" "./build/log-spm-tvos-sim.log" "./build/DerivedData-spm-tvos-sim" &
    pid_tvos_sim=$!
    wait $pid_ios_device
    wait $pid_ios_sim
    wait $pid_tvos_device
    wait $pid_tvos_sim
    echo "Archiving succeeded."
    printf "Creating XCFrameworks"
    xcodebuild -create-xcframework \
        -framework './build/SPM/ConsentViewController-iOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
        -framework './build/SPM/ConsentViewController-iOS-simulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
        -framework './build/SPM/ConsentViewController-tvOS.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
        -framework './build/SPM/ConsentViewController-tvOS-simulator.xcarchive/Products/Library/Frameworks/ConsentViewController.framework' \
        -output './build/SPMConsentViewController.xcframework' &> "$BUILD_LOG" 2>&1
    echo "✅"
    printf "Zipping XCFramework"
    ditto -c -k --sequesterRsrc --keepParent ./build/SPMConsentViewController.xcframework ./build/SPMConsentViewController.xcframework.zip &> "$BUILD_LOG" 2>&1
    echo "✅"
    echo "XCFrameworks created on: ./build/SPMConsentViewController.xcframework.zip"
}

# Run standalone and SPM builds in parallel and wait for both
build_standalone &
pid_standalone=$!
build_spm &
pid_spm=$!

wait $pid_standalone
wait $pid_spm
