#!/bin/bash

echo "=================================="
echo "Start build..."

cd ./_source
hugo -D -d ./../

echo "build success"
echo "=================================="
