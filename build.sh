#!/bin/bash
set -e 

BUILD_VERSION=$(git describe --tags --abbrev=0)

docker build --no-cache=true \
    --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
    --build-arg BUILD_VERSION=$(git describe --tags --abbrev=0) \
    --build-arg VCS_REF=$(git rev-parse HEAD) \
    -t sigitaspl/vrising:$BUILD_VERSION \
    -t sigitaspl/vrising:latest \
    .