#!/usr/bin/env bash

set -ex

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
MVN_SETTINGS="${SCRIPT_PATH}/settings.xml"

if [[ "$1" == "install" ]]; then
  mvn clean install --settings "${MVN_SETTINGS}" -DskipTests=true -Dmaven.javadoc.skip=true -B -V -Djava.level=${JAVA_LEVEL} ${MVN_FLAG}
elif [[ "${TRAVIS_BRANCH}" == "testRelease" ]]; then
  if [[ "${TRAVIS_COMMIT_MESSAGE}" == *"[maven-release-plugin]"* ]]; then
    echo "Do not release commits created by maven release plugin"
  else
    echo "Building release"

    git checkout "${TRAVIS_BRANCH}"
    git remote set-url origin git@github.com:jenkinsci/configuration-as-code-plugin.git
    git pull origin master --ff-only

    mvn release:prepare release:perform --settings "${MVN_SETTINGS}" -B -Darguments="--settings ${MVN_SETTINGS} -DdryRun" -DdryRun
  fi
else
  mvn clean install --settings "${MVN_SETTINGS}" -B -Djava.level=${JAVA_LEVEL} ${MVN_FLAG}
fi
