#!/bin/bash

podspecFileName="ConsentViewController.podspec"
spConsentManagerFileName="ConsentViewController/Classes/SPConsentManager.swift"
readmeFileName="README.md"
xcframeworkZipPath="./build/SPMConsentViewController.xcframework.zip"
packageSwiftFile="Package.swift"

############ BEGIN CLI

# Function to check if an array contains a value
containsElement () {
    local e match="$1"
    shift
    for e; do
        [[ "$e" == "$match" ]] && return 0 #true
    done
    return 1 #false
}

firstArgWithPrefix() {
    local prefix="$1"
    local args=$2

    for element in $args; do
        if [[ $element == $prefix* ]]; then
            # The syntax ${variable#pattern} removes the pattern from the start of $variable.
            echo "${element#${prefix}}"
        fi
    done
    echo ""
}

getVersionFromBranch() {
    local currentBranch=$(git rev-parse --abbrev-ref HEAD)
    local branchPrefix="pre-"
    echo "${currentBranch#${branchPrefix}}"
}

getVersionArg() {
    local prefix="-v="
    local args=$1
    local versionFromArgs=$(firstArgWithPrefix $prefix $args)
    if [ -z $versionFromArgs ]; then
        echo $(getVersionFromBranch)
    else
        echo $versionFromArgs
    fi
}

assertStatus() {
    local status=$?
    local command="$1"
    if [ "$status" -ne 0 ]; then
        echo "command $command failed with status $status"
        exit $status
    fi
}

updatePodspec() {
    echo "Updating podspec"
    local version=$1
    sed -i '' "s/\(s.version = '\)\(.*\)\('\)/\1${version}\3/" "$podspecFileName"
}

updateVersionOnSPConsentManager() {
    echo "Updating SPConsentManager"
    local version=$1
    sed -i '' "s/\(let VERSION = \"\)\(.*\)\(\"\)/\1${version}\3/" "$spConsentManagerFileName"
}

updateReadme() {
    echo "Updating README"
    local version=$1
    sed -i '' "s/\(pod 'ConsentViewController', '\)\(.*\)\('\)/\1${version}\3/" "$readmeFileName"
    sed -i '' "s/\(.upToNextMinor(from: \"\)\(.*\)\(\")\)/\1${version}\3/" "$readmeFileName"
}

updatePackageSwift() {
    echo "Updating Package.swift"
    local version=$1

    if [ ! -f "$xcframeworkZipPath" ]; then
        echo "Error: XCFramework zip not found at $xcframeworkZipPath"
        exit 1
    fi

    echo "Calculating checksum for $xcframeworkZipPath"
    local checksum=$(swift package compute-checksum "$xcframeworkZipPath")
    echo "Checksum: $checksum"

    # Update the version in the URL
    sed -i '' "s|\(https://github.com/SourcePointUSA/ios-cmp-app/releases/download/\)[^/]\{1,\}\(/SPMConsentViewController.xcframework.zip\)|\1${version}\2|" "$packageSwiftFile"

    # Update the checksum
    sed -i '' "s/\(checksum: \"\)[^\"]*\(\"\)/\1${checksum}\2/" "$packageSwiftFile"

    echo "Package.swift updated successfully"
}

createGitHubRelease() {
    echo "Creating GitHub Release"
    local version=$1
    local spmZip="./build/SPMConsentViewController.xcframework.zip"
    local standaloneZip="./build/ConsentViewController.xcframework.zip"

    # Check if zip files exist
    if [ ! -f "$spmZip" ]; then
        echo "Error: SPM XCFramework zip not found at $spmZip"
        ls -la .
        ls -la build/
        exit 1
    fi

    if [ ! -f "$standaloneZip" ]; then
        echo "Error: Standalone XCFramework zip not found at $standaloneZip"
        ls -la .
        ls -la build/
        exit 1
    fi

    # Detect if pre-release
    local prerelease_flag=""
    if [[ "$version" =~ (beta|alpha|rc) ]]; then
        prerelease_flag="--prerelease"
        echo "Detected pre-release version"
    fi

    # Create release with gh CLI
    local release_notes="Release version ${version}

See [CHANGELOG.md](https://github.com/SourcePointUSA/ios-cmp-app/blob/master/CHANGELOG.md) for details."

    gh release create "$version" \
        "$spmZip" \
        "$standaloneZip" \
        --title "$version" \
        --notes "$release_notes" \
        $prerelease_flag

    assertStatus "gh release create"
    echo "GitHub Release created successfully"
}

podInstall() {
    cd Example
    pod install
    assertStatus "pod install"
    cd ..
}

deleteBranch() {
    local branchName=$1

    echo "Deleting branch $branchName"
    git branch -D $branchName
    git push origin :$branchName
}

generateFrameworks() {
    local version=$2

    bash ./buildXCFrameworks.sh
    assertStatus "buildXCFrameworks.sh"

    git add .
    git commit -m "'update Package.swift for $version'"
}

release () {
    local version=$1
    local skipFrameworks=$2
    local currentBranch=$(git rev-parse --abbrev-ref HEAD)

    echo "Releasing SDK version $version"
    updatePodspec $version
    updateVersionOnSPConsentManager $version
    updateReadme $version
    git add .
    git commit -m "'update version to $version'"
    podInstall
    git add .
    git commit -am "'run pod install with $version'"
    generateFrameworks $skipFrameworks $version
    updatePackageSwift $version
    git push -u origin $currentBranch
    createGitHubRelease $version
    pod trunk push ConsentViewController.podspec --verbose
}

# Function to check if a string matches the SemVer pattern
isSemVer() {
    local semver_regex="^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$"
    [[ $1 =~ $semver_regex ]]
}

printUsage() {
    printf "Usage:\n"
    printf "\t./release x.y.z\n"
}

printHelp() {
    printf "Script used to release iOS/tvOS SDK.\n"
    printf "1. Make sure to be on a branch called pre-VERSION where VERSION follows SemVer spec\n"
    printf "2. Update CHANGELOG.md and commit.\n"
    printf "3. Run this script passing -v=VERSION as argument"
    printf "Options:\n"
    printf "\t -h prints this message\n"
    printUsage
}

helpArg="-h"

if containsElement $helpArg $@; then
    printHelp
    exit 0
fi

versionToRelease=$(getVersionArg $@)

if [ -z $versionToRelease ]; then
    printf "Did you forget to pass the version as argument?\n"
    printUsage
    exit 1
fi

if isSemVer $versionToRelease; then
    release $versionToRelease
    exit 0
else
    printf "$versionToRelease is not a valid SemVer.\n"
    exit 1
fi
