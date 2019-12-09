#! /bin/bash

set -eo pipefail

source ./common.sh  

curl -fsSL https://raw.githubusercontent.com/windmilleng/tilt/master/scripts/install.sh | bash

tilt up