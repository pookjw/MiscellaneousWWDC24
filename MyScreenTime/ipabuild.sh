#!/bin/bash
# https://github.com/Avangelista/CarTube/blob/main/ipabuild.sh

set -e

cd "$(dirname "$0")"

WORKING_LOCATION="$(pwd)"
XCODEPROJ_NAME="MyScreenTime"
APPLICATION_NAME="MyScreenTime Private"
ENTITLEMENT_PATH="MyScreenTime/MyScreenTime-Private.entitlements"
CONFIGURATION=Debug

if [ ! -d "build" ]; then
mkdir build
fi
cd build
if [ -e "$APPLICATION_NAME.tipa" ]; then
rm "$APPLICATION_NAME.tipa"
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
echo "$WORKING_LOCATION/$ENTITLEMENT_PATH"
echo "$TARGET_APP/$APPLICATION_NAME"
echo "Adding entitlements"
ldid -S"$WORKING_LOCATION/$ENTITLEMENT_PATH" "$TARGET_APP/$APPLICATION_NAME"

# Package .tipa
rm -rf Payload
mkdir Payload
cp -r "$APPLICATION_NAME.app" "Payload/$APPLICATION_NAME.app"
zip -vr "$APPLICATION_NAME.tipa" Payload
rm -rf "$APPLICATION_NAME.app"
rm -rf Payload
