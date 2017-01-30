#!/usr/bin/env bash
#
# Travis specific post-test script to run the test suite provided
# in the latest release of https://github.com/belgattitude/soluble-japha client.
#
# Very hacky
#
# usage:
#   > ./test_build_against_soluble_japha.sh
#
# requirements:
#   - php >= 5.6, php 7+
#   - git
#   - composer
#   - java
#   - linux
#
# @author Vanvelthem Sébastien
#

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/.."
JAPHA_DIR="$SCRIPT_DIR/soluble-japha"

install_soluble_japha_master() {

    echo "[*] Installing master branch of soluble-japha";

    # 1. Clone the soluble-japha project (if not already exists)
    if [ ! -d $JAPHA_DIR ]; then
        git clone https://github.com/belgattitude/soluble-japha.git $JAPHA_DIR
    fi

    # 2. Clone the soluble-japha project
    cd $JAPHA_DIR

    # 3. Checkout latest release
    #git fetch --tags
    #latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    #git checkout ${latestTag}

    git checkout master

    # 4. Run composer install
    composer install

    # 5. Restore path
    cd $PROJECT_DIR
}


runPHPUnit()  {
    cd $JAPHA_DIR
    echo "[*] Running phpunit"
    cp ../phpunit.travis.xml .
    ./vendor/bin/phpunit -c ./phpunit.travis.xml -v --debug
}


# Here's the steps
install_soluble_japha_master;
runPHPUnit;

