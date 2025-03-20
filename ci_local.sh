#!/bin/bash

set -e  # Exit if any command fails
set -o pipefail  # Exit if piped command fails

# Colors for formatted logging
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Environment variables
PROJECT_NAME="WeatherForecast"
SCHEME_NAME="WeatherForecast"
DERIVED_DATA_PATH="$HOME/DerivedData"
RESULTS_PATH="TestResults.xcresult"
COVERAGE_REPORT_DIR="coverage-report"

echo -e "${BLUE}🚀 Running CI/CD pipeline locally...${NC}"

# ✅ Step 1: Check Required Tools
echo -e "${YELLOW}🔍 Checking required tools...${NC}"
for cmd in swiftlint xcodebuild xcpretty xcrun; do
  if ! command -v $cmd &> /dev/null; then
    echo -e "${RED}❌ Error: $cmd is not installed. Install it and retry.${NC}"
    exit 1
  fi
done
echo -e "${GREEN}✅ All required tools are installed.${NC}"

# ✅ Step 2: Run SwiftLint
echo -e "${YELLOW}📏 Running SwiftLint...${NC}"
swiftlint --strict || echo -e "${YELLOW}⚠️ SwiftLint warnings detected.${NC}"

# ✅ Step 3: Ensure iOS Simulator Exists
echo -e "${YELLOW}📱 Checking available iOS simulator runtimes...${NC}"
SIMULATOR_NAME="CI Simulator"
SIMULATOR_RUNTIME=$(xcrun simctl list runtimes | grep "iOS" | grep -o "com.apple.CoreSimulator.SimRuntime.iOS-[0-9-]*" | tail -1)

if [ -z "$SIMULATOR_RUNTIME" ]; then
  echo -e "${RED}❌ Error: No available iOS simulator runtimes found!${NC}"
  exit 1
fi
echo -e "${GREEN}✅ Using runtime: $SIMULATOR_RUNTIME${NC}"

if ! xcrun simctl list devices | grep -q "$SIMULATOR_NAME"; then
  echo -e "${YELLOW}ℹ️ Creating simulator: $SIMULATOR_NAME${NC}"
  xcrun simctl delete "$SIMULATOR_NAME" || true
  xcrun simctl create "$SIMULATOR_NAME" "iPhone 14" "$SIMULATOR_RUNTIME"
fi

# ✅ Step 4: Locate Xcode Project
echo -e "${YELLOW}📂 Locating Xcode project...${NC}"
if [ -f "$PROJECT_NAME.xcodeproj/project.pbxproj" ]; then
  PROJECT_PATH="$PROJECT_NAME.xcodeproj"
elif [ -f "$PROJECT_NAME/$PROJECT_NAME.xcodeproj/project.pbxproj" ]; then
  PROJECT_PATH="$PROJECT_NAME/$PROJECT_NAME.xcodeproj"
else
  echo -e "${RED}❌ Error: Project file not found!${NC}"
  exit 1
fi
echo -e "${GREEN}✅ Project found at: $PROJECT_PATH${NC}"

# ✅ Step 5: Run Tests with Code Coverage
echo -e "${YELLOW}🧪 Running tests with code coverage...${NC}"
[ -d "$RESULTS_PATH" ] && rm -rf "$RESULTS_PATH"

xcodebuild test \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME_NAME" \
  -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=latest" \
  -enableCodeCoverage YES \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  -resultBundlePath "$RESULTS_PATH" | xcpretty
echo -e "${GREEN}✅ Tests completed successfully.${NC}"

# ✅ Step 6: Locate Coverage Data
echo -e "${YELLOW}📊 Locating code coverage data...${NC}"
PROF_DATA_PATH=$(find "$DERIVED_DATA_PATH/Build/ProfileData" -type f -name "Coverage.profdata" | head -n 1)
PRODUCT_DIR="$DERIVED_DATA_PATH/Build/Products/Debug-iphonesimulator"
EXECUTABLE_PATH=$(find "$PRODUCT_DIR" -type f -perm +111 | head -n 1)

if [ -z "$PROF_DATA_PATH" ] || [ -z "$PRODUCT_DIR" ] || [ -z "$EXECUTABLE_PATH" ]; then
  echo -e "${RED}❌ Error: Coverage data or executable not found!${NC}"
  exit 1
fi
echo -e "${GREEN}✅ Found profdata at: $PROF_DATA_PATH${NC}"
echo -e "${GREEN}✅ Found product directory at: $PRODUCT_DIR${NC}"
echo -e "${GREEN}✅ Found executable at: $EXECUTABLE_PATH${NC}"

# ✅ Step 7: Generate Code Coverage Report
echo -e "${YELLOW}📊 Generating code coverage report...${NC}"
mkdir -p "$COVERAGE_REPORT_DIR"
xcrun llvm-cov show \
  -instr-profile="$PROF_DATA_PATH" \
  --ignore-filename-regex="/usr/*" \
  --format=html \
  --output-dir="$COVERAGE_REPORT_DIR" \
  --show-regions \
  --use-color \
  "$EXECUTABLE_PATH"
echo -e "${GREEN}✅ Code coverage report generated at: $COVERAGE_REPORT_DIR${NC}"

# ✅ Step 8: Verify Test Results
if [ ! -d "$RESULTS_PATH" ]; then
  echo -e "${RED}❌ Error: Test results not found!${NC}"
  exit 1
fi
echo -e "${GREEN}✅ All steps completed successfully! 🎉${NC}"

# ✅ Step 9: Cleanup Test Results
echo -e "${YELLOW}🗑️ Cleaning up test results...${NC}"
rm -rf "$RESULTS_PATH"
echo -e "${GREEN}✅ Cleanup completed.${NC}"

# ✅ Step 10: Open Coverage Report (Optional)
read -p "Do you want to open the coverage report? (y/n): " open_report
if [[ $open_report == "y" ]]; then
  open "$COVERAGE_REPORT_DIR/index.html"
fi
