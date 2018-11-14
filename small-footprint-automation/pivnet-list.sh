#!/bin/bash

set -x
set -e

http https://network.pivotal.io/api/v2/products | jq -r '.products | .[] | .slug'
