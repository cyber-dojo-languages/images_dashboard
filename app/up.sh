#!/bin/bash

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source ${MY_DIR}/env-vars
readonly PORT=${1:-${IMAGES_DASHBOARD_PORT}}

cd ${MY_DIR}
bundle exec rackup --host 0.0.0.0 -p ${PORT} config.ru
