# generate Cartfile for the current branch
echo "git \"$(realpath ../../)\" \"$(git branch --show-current)\"" > ./Cartfile

carthage update --use-xcframeworks

xcodebuild -project SPCarthageTest.xcodeproj -scheme SPCarthageTest clean build

rm Cartfile*
