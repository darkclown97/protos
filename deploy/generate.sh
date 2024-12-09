#!/bin/bash

set -e  # Exit immediately if any command exits with a non-zero status
set -u  # Treat unset variables as an error

rm -rf generated

# Directories for generated code
GO_OUT_DIR="generated/go"
JS_OUT_DIR="generated/js"
TS_OUT_DIR="generated/ts"
PY_OUT_DIR="generated/python"

# Create directories if they don't exist
mkdir -p "$GO_OUT_DIR"
mkdir -p "$JS_OUT_DIR"
mkdir -p "$TS_OUT_DIR"
mkdir -p "$PY_OUT_DIR"

# Create or overwrite the README.md file with the defined content
echo "Protobuf generated golang files. Refer [darkclown/protos](https://github.com/darkclown97/protos) for source protos." > $GO_OUT_DIR/README.md
echo "Protobuf generated javascript files. Refer [darkclown/protos](https://github.com/darkclown97/protos) for source protos." > $JS_OUT_DIR/README.md
echo "Protobuf generated typescript files. Refer [darkclown/protos](https://github.com/darkclown97/protos) for source protos." > $TS_OUT_DIR/README.md
echo "Protobuf generated python files. Refer [darkclown/protos](https://github.com/darkclown97/protos) for source protos." > $PY_OUT_DIR/README.md

# Loop through all proto files in subdirectories of 'services'
PROTO_FILES=$(find common services -name "*.proto")

# Check if any .proto files exist
if [[ -z "$PROTO_FILES" ]]; then
    echo "No .proto files found in 'services/'"
    exit 1
fi

# Code generation for each proto file
for PROTO_FILE in $PROTO_FILES; do
    echo "Processing: $PROTO_FILE"

    protoc \
        --go_out="$GO_OUT_DIR" \
        --go_opt=paths=source_relative \
        --go-grpc_out="$GO_OUT_DIR" \
        --go-grpc_opt=paths=source_relative \
        --twirp_out="$GO_OUT_DIR" \
        --twirp_opt=paths=source_relative \
        --js_out=import_style=commonjs,binary:"$JS_OUT_DIR" \
        --grpc-web_out=import_style=commonjs+dts,mode=grpcwebtext:"$JS_OUT_DIR" \
        --plugin=protoc-gen-ts_proto=$(which protoc-gen-ts_proto) \
        --ts_proto_out="$TS_OUT_DIR" \
        --ts_proto_opt=esModuleInterop=true,forceLong=long,useOptionals=messages \
        "$PROTO_FILE"

    python -m grpc_tools.protoc \
        -I="./" \
        --python_out="$PY_OUT_DIR" \
        --pyi_out="$PY_OUT_DIR" \
        --grpc_python_out="$PY_OUT_DIR" \
        "$PROTO_FILE"
done

echo "Code generation complete!"