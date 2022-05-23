# !/usr/bin/bash

RELEASE_TYPE=$1

if [ -z "${RELEASE_TYPE}" ]; then
    echo "Error: RELEASE_TYPE is not set"; 
    exit 1 
fi

# TODO remove sed when poetry 1.2 is out and use --short --dry-run options
VERSION=$(poetry version ${RELEASE_TYPE} | sed -e 's/.*to \(.*\)/\1/')
TAG="v${VERSION}"
echo "Bumping tag ${TAG}"
git tag ${TAG}
git push origin ${TAG}

# TODO remove this when poetry --dry-run option is added in 1.2 release
git checkout pyproject.toml
