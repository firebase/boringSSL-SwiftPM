#!/bin/bash
set -e

# Usage: ./scripts/sync-upstream.sh [commit-hash]
COMMIT_HASH=${1:-upstream/main}
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# 1. Define the files/folders you want to preserve
# Ensure these paths are relative to the repository root
PRESERVE=(
    "Package.swift"
    "err_data.c"
    "PrivacyInfo.xcprivacy"
    "README.md"
    "swiftpmtests/"
    "scripts/"
    "docs/"
    ".github/"
)

echo "--- Preserving local files ---"
for file in "${PRESERVE[@]}"; do
    if [ -e "$file" ]; then
        cp -r "$file" "$TEMP_DIR/"
    fi
done

# 2. Fetch and reset
echo "--- Syncing to: $COMMIT_HASH ---"
git fetch upstream
git reset --hard "$COMMIT_HASH"

# 3. Restore preserved files
echo "--- Restoring local files ---"
for file in "${PRESERVE[@]}"; do
    clean_file="${file%/}"
    target_name=$(basename "$clean_file")
    if [ -e "$TEMP_DIR/$target_name" ]; then
        if [ -d "$TEMP_DIR/$target_name" ]; then
            mkdir -p "$clean_file"
            cp -r "$TEMP_DIR/$target_name/." "$clean_file/"
        else
            cp "$TEMP_DIR/$target_name" "$clean_file"
        fi
    fi
done
rm -rf "$TEMP_DIR"

# 4. Cleanup function
cleanup() {
    echo "--- Performing comprehensive cleanup ---"
    
    # Directories
    rm -rf rust/ infra/ fuzz/ third_party/googletest/
    rm -rf third_party/wycheproof_testvectors/ pki/testdata/ gen/test_support/
    rm -rf .swiftpm/ .bcr/ .build/

    # Files and artifacts
    find . -type f \( -name "*_test.cc" -o -name "*_test.go" -o -name "*_tests.txt" -o -name "*_unittest.cc" \) -delete
    rm -f .bazelrc
    find . -name ".DS_Store" -delete
}

cleanup

echo "--- Verifying build ---"
if swift build; then
    echo "SUCCESS: Build verified."
else
    echo "ERROR: Build failed."
    exit 1
fi