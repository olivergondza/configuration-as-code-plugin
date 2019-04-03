#!/usr/bin/env bash

set -e

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
MVN_SETTINGS="${SCRIPT_PATH}/settings.xml"

if [[ "$1" == "install" ]]; then
  mvn clean install --settings ${MVN_SETTINGS} -DskipTests=true -Dmaven.javadoc.skip=true -B -V -Djava.level=${JAVA_LEVEL} ${MVN_FLAG}
  exit 0
fi

if [[ "${TRAVIS_BRANCH}" == "release" ]]; then
  if [[ "${TRAVIS_COMMIT_MESSAGE}" == *"[maven-release-plugin]"* ]]; then
    echo "Do not release commits created by maven release plugin"
  else
    echo "Building release"

    # travis checkout the commit as detached head (which is normally what we
    # want) but maven release plugin does not like working in detached head
    # mode. This might be a problem if other commits have already been pushed
    # to the release branch, but in that case we will have problem anyway.
    git checkout release

    # we should always be at the same level as master and only use fast forward
    git merge master --ff-only

    mvn release:prepare release:perform --settings ${MVN_SETTINGS} -B -Darguments="--settings ${MVN_SETTINGS} -DdryRun" -DdryRun
  fi
else
  mvn clean install --settings ${MVN_SETTINGS} -B -Djava.level=${JAVA_LEVEL} ${MVN_FLAG}
fi
