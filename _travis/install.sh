#!/bin/bash

set -e
set -x

if [[ "$(uname -s)" == 'Darwin' ]]; then
    sw_vers
    brew update || brew update

    # Uninstall oclint if it's installed. This is
    # conditional because of build caching.
    if brew ls --versions oclint >> /dev/null; then
        brew cask uninstall oclint
    fi

    if [[ -n "$PYENV_VERSION" ]]; then
        wget https://github.com/praekeltfoundation/travis-pyenv/releases/download/0.4.0/setup-pyenv.sh
        source setup-pyenv.sh
    fi

    pip install -U setuptools
    pip install --user virtualenv
else
    pip install virtualenv
fi

pip install tox

if [[ "${TOXENV}" == "gae" ]]; then
    pip install gcp-devrel-py-tools
    gcp-devrel-py-tools download-appengine-sdk "$(dirname ${GAE_SDK_PATH})"
fi
