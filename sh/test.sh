#!/bin/bash

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source ${MY_DIR}/../.env
docker exec -it ${IMAGES_DASHBOARD_CONTAINER} sh -c 'rake test'