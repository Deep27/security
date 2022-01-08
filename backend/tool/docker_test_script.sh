#!/bin/bash

set -e

image="$(docker build -q .)"
echo Image created: "$image"
container=$(docker run -d -p 4045:4045 --rm "$image")
echo Container started: "$container"
sleep 1
dart run test test/docker_test.dart --chain-stack-traces -t presubmit-only --run-skipped || EXIT_CODE=$?
echo Container killed "$(docker kill "$container")"
echo Image deleted "$(docker rmi "$image")"
exit ${EXIT_CODE}
