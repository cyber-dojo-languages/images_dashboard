#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
${MY_DIR}/sh/image_build.sh
${MY_DIR}/sh/up.sh
${MY_DIR}/sh/test.sh
