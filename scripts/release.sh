#!/bin/bash
set -e

VERSION=${1:-"1.0.0"}
BUILD_DIR="build"
APP_NAME="musubi"
ZIP_NAME="${APP_NAME}-${VERSION}.zip"

echo "Building ${APP_NAME} v${VERSION}..."

# Clean previous build
rm -rf "$BUILD_DIR"

# Build release
xcodebuild -scheme musubi \
    -configuration Release \
    -derivedDataPath "$BUILD_DIR" \
    -quiet

APP_PATH="$BUILD_DIR/Build/Products/Release/${APP_NAME}.app"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: Build failed - ${APP_PATH} not found"
    exit 1
fi

echo "Creating zip archive..."
cd "$BUILD_DIR/Build/Products/Release"
zip -r -q "../../../../$ZIP_NAME" "${APP_NAME}.app"
cd -

# Calculate SHA256 for Homebrew
SHA256=$(shasum -a 256 "$ZIP_NAME" | awk '{print $1}')

echo ""
echo "Build complete!"
echo "  Archive: $ZIP_NAME"
echo "  SHA256:  $SHA256"
echo ""
echo "Next steps:"
echo "  1. Create a GitHub release for v${VERSION}"
echo "  2. Upload ${ZIP_NAME} to the release"
echo "  3. Update the Homebrew cask with the new SHA256"
