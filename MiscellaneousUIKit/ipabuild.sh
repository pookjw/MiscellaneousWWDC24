#!/bin/bash
# https://github.com/Avangelista/CarTube/blob/main/ipabuild.sh

set -e

cd "$(dirname "$0")"

WORKING_LOCATION="$(pwd)"
XCODEPROJ_NAME="MiscellaneousUIKit"
APPLICATION_NAME="MiscellaneousUIKit Private"
CONFIGURATION=Debug

if [ ! -d "build" ]; then
mkdir build
fi
cd build
if [ -e "$APPLICATION_NAME.ipa" ]; then
rm $APPLICATION_NAME.ipa
fi

# Build .app
xcodebuild -project "$WORKING_LOCATION/$XCODEPROJ_NAME.xcodeproj" \
    -scheme "$APPLICATION_NAME" \
    -configuration Debug \
    -derivedDataPath "$WORKING_LOCATION/build/DerivedData" \
    -destination 'generic/platform=iOS' \
    ONLY_ACTIVE_ARCH="NO" \
    CODE_SIGNING_ALLOWED="NO" \

DD_APP_PATH="$WORKING_LOCATION/build/DerivedData/Build/Products/$CONFIGURATION-iphoneos/$APPLICATION_NAME.app"
TARGET_APP="$WORKING_LOCATION/build/$APPLICATION_NAME.app"
cp -r "$DD_APP_PATH" "$TARGET_APP"

# Remove signature
codesign --remove "$TARGET_APP"
if [ -e "$TARGET_APP/_CodeSignature" ]; then
    rm -rf "$TARGET_APP/_CodeSignature"
fi
if [ -e "$TARGET_APP/embedded.mobileprovision" ]; then
    rm -rf "$TARGET_APP/embedded.mobileprovision"
fi

# Add entitlements
echo "$TARGET_APP/$APPLICATION_NAME"
echo "Adding entitlements"
ldid -S"$WORKING_LOCATION/$XCODEPROJ_NAME/MiscellaneousUIKit-Private.entitlements" "$TARGET_APP/$APPLICATION_NAME"

# Package .ipa
rm -rf Payload
mkdir Payload
cp -r "$APPLICATION_NAME.app" "Payload/$APPLICATION_NAME.app"
zip -vr "$APPLICATION_NAME.tipa" Payload
rm -rf "$APPLICATION_NAME.app"
rm -rf Payload
