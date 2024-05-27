#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'hello' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "hello": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default value in 
# the Feature's 'devcontainer-feature.json'.
# For the 'hello' feature, that means the default favorite greeting is 'hey'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
# 
# This test can be run with the following command:
#
#    devcontainer features test \ 
#                   --features hello   \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#                   /path/to/this/repo

set -e

# Import test library for `check` command
source dev-container-features-test-lib

# Definition specific tests
check "gzip" gzip  --version
check "fzf" fzf  --version
check "antibody" antibody  --version

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
