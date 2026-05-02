#!/usr/bin/env bash
set -euo pipefail

LABEL="manual"
DEVICE_NAME="${SARAK_SCREENSHOT_DEVICE:-iPhone 17}"
SCHEME="SARAK"
CONFIGURATION="Debug"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --label)
      LABEL="${2:?Missing value for --label}"
      shift 2
      ;;
    --device)
      DEVICE_NAME="${2:?Missing value for --device}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DERIVED_DATA="$PROJECT_ROOT/.harness/derived-data"
SCREENSHOT_DIR="$PROJECT_ROOT/.harness/screenshots/home"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
OUTPUT_PATH="$SCREENSHOT_DIR/${LABEL}-${TIMESTAMP}.png"
APP_PATH="$DERIVED_DATA/Build/Products/${CONFIGURATION}-iphonesimulator/SARAK.app"

mkdir -p "$SCREENSHOT_DIR" "$DERIVED_DATA"

xcodebuild \
  -project "$PROJECT_ROOT/SARAK.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "platform=iOS Simulator,name=$DEVICE_NAME" \
  -derivedDataPath "$DERIVED_DATA" \
  build

DEVICE_ID="$(
  xcrun simctl list devices available |
    awk -v device_name="$DEVICE_NAME" '
      $0 ~ "^[[:space:]]*" device_name " \\(" {
        if (match($0, /\(([0-9A-Fa-f-]+)\)/)) {
          print substr($0, RSTART + 1, RLENGTH - 2)
          exit
        }
      }
    '
)"

if [[ -z "$DEVICE_ID" ]]; then
  echo "Could not find an available simulator named '$DEVICE_NAME'." >&2
  exit 1
fi

BUNDLE_ID="$(/usr/libexec/PlistBuddy -c Print:CFBundleIdentifier "$APP_PATH/Info.plist")"

xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true
xcrun simctl bootstatus "$DEVICE_ID" -b
xcrun simctl install "$DEVICE_ID" "$APP_PATH"
SIMCTL_CHILD_SARAK_SCREENSHOT_AUTHENTICATED=1 \
  xcrun simctl launch --terminate-running-process "$DEVICE_ID" "$BUNDLE_ID"
sleep 2
xcrun simctl io "$DEVICE_ID" screenshot "$OUTPUT_PATH"

echo "$OUTPUT_PATH"
