#!/bin/bash

set -e

mkdir -p generated/go
mkdir -p generated/js

# Golang
for f in services/*.proto; do
    if [[ -f $f ]]; then
        protoc --go_out=generated/go/ --go_opt=paths=source_relative --go-grpc_out=generated/go/ --go-grpc_opt=paths=source_relative --js_out=import_style=commonjs,binary:generated/js/ $f
    fi
done

echo "services codegen done"