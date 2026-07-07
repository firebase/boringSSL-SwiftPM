#!/bin/bash
set -e

# Move to repository root
cd "$(dirname "$0")/.."

echo "--- Generating err_data.c ---"
go run ./util/pregenerate err_data.cc
cp -f gen/crypto/err_data.cc ./err_data.c
echo "SUCCESS: err_data.c generated and copied to root folder."