#!/bin/bash
# Description: Build and Push image
# Maintainer: Mauro Cardillo
source ./.env

BUILD_DATE=$(date +"%Y-%m-%d")

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -di=*|--docker-image=*)
        DOCKER_IMAGE="${arg#*=}"
        shift # Remove
        ;;
        -ar=*|--alpine-release=*)
        BUILDX_VERSION="${arg#*=}"
        shift # Remove
        ;;
        -r=*|--release=*)
        RELEASE="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -di=|--docker-image         -> ${DOCKER_IMAGE} (docker image name)"
        echo -e "  -bv=|--buildx-version       -> ${BUILDX_VERSION} (buildx version)"
        echo -e "  -r=|--release               -> ${RELEASE} (release of image.Values: TEST, CURRENT, LATEST)"
        exit 0
        ;;
    esac
done

echo "# Build Date                -> ${BUILD_DATE}"
echo "# Docker Image              -> ${DOCKER_IMAGE}"
echo "# Buildx Version            -> ${BUILDX_VERSION}"

ARGUMENT_ERROR=0

if [ "${DOCKER_IMAGE}" == "" ]; then
    echo "ERROR: The variable DOCKER_IMAGE is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${BUILDX_VERSION}" == "" ]; then
    echo "ERROR: The variable BUILDX_VERSION is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${DOCKER_HUB_USER}" == "" ]; then
    echo "ERROR: The environment variable DOCKER_HUB_USER is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${DOCKER_HUB_PASSWORD}" == "" ]; then
    echo "ERROR: The environment variable DOCKER_HUB_PASSWORD is not set!"
    ARGUMENT_ERROR=1
fi

if [ ${ARGUMENT_ERROR} -ne 0 ]; then
    exit 1
fi

echo "Docker Image          -> ${DOCKER_IMAGE}"
echo "Buildx Version        -> ${BUILDX_VERSION}"

TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${DOCKER_HUB_USER}'", "password": "'${DOCKER_HUB_PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)

if [ "$TOKEN" != "null" ]; then
    echo "Login to Docker Hub"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Remove image ${DOCKER_IMAGE}:aarch64"
    docker rmi -f ${DOCKER_IMAGE}:aarch64 > /dev/null 2>&1

    echo "Build and Push Image ${DOCKER_IMAGE}:aarch64"
    docker buildx build --platform "linux/arm64" --build-arg BUILD_DATE=${BUILD_DATE} --build-arg BUILDX_VERSION="${BUILDX_VERSION}" -t ${DOCKER_IMAGE}:aarch64 -f ./Dockerfile.aarch64 . --push

    echo "Remove image ${DOCKER_IMAGE}:armhf"
    docker rmi -f ${DOCKER_IMAGE}:armhf > /dev/null 2>&1

    echo "Build and Push Image ${DOCKER_IMAGE}:armhf"
    docker buildx build --platform "linux/arm/v6" --build-arg BUILD_DATE=${BUILD_DATE} --build-arg BUILDX_VERSION="${BUILDX_VERSION}" -t ${DOCKER_IMAGE}:armhf -f ./Dockerfile.armhf . --push

    echo "Remove image ${DOCKER_IMAGE}:armv7"
    docker rmi -f ${DOCKER_IMAGE}:armv7 > /dev/null 2>&1

    echo "Build and Push Image ${DOCKER_IMAGE}:armv7"
    docker buildx build --platform "linux/arm/v7" --build-arg BUILD_DATE=${BUILD_DATE} --build-arg BUILDX_VERSION="${BUILDX_VERSION}" -t ${DOCKER_IMAGE}:armv7 -f ./Dockerfile.armv7 . --push

    #echo "Remove image ${DOCKER_IMAGE}:ppc64le"
    #docker rmi -f ${DOCKER_IMAGE}:ppc64le > /dev/null 2>&1

    #echo "Build and Push Image ${DOCKER_IMAGE}:ppc64le"
    #docker buildx build --platform "linux/ppc64le" --build-arg BUILD_DATE=${BUILD_DATE} --build-arg BUILDX_VERSION="${BUILDX_VERSION}" -t ${DOCKER_IMAGE}:ppc64le -f ./Dockerfile.ppc64le . --push

    echo "Remove image ${DOCKER_IMAGE}:x86_64"
    docker rmi -f ${DOCKER_IMAGE}:x86_64 > /dev/null 2>&1

    echo "Build and Push Image ${DOCKER_IMAGE}:x86_64"
    docker buildx build --platform "linux/amd64" --build-arg BUILD_DATE=${BUILD_DATE} --build-arg BUILDX_VERSION="${BUILDX_VERSION}" -t ${DOCKER_IMAGE}:x86_64 -f ./Dockerfile.x86_64 . --push

    echo "Remove Manifest for ${DOCKER_IMAGE}"
    docker manifest rm ${DOCKER_IMAGE}

    echo "Create and Push Manifest for ${DOCKER_IMAGE}"
    docker manifest create ${DOCKER_IMAGE} \
        --amend ${DOCKER_IMAGE}:aarch64 \
        --amend ${DOCKER_IMAGE}:armhf \
        --amend ${DOCKER_IMAGE}:armv7 \
        --amend ${DOCKER_IMAGE}:x86_64

    docker manifest push ${DOCKER_IMAGE}
else 
    echo "Login to Docker Hub failed, verify account and password"
    exit 1
fi
