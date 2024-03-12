# Concourse CI for linux/arm64

This repository helps you build both the web and worker `arm64` components for Concourse CI - prebuilt Docker images can be found on Docker Hub [rdclda/concourse](https://hub.docker.com/repository/docker/rdclda/concourse).

![Concourse on arm64 screenshot](./screenshot.png)

## Bundled resources

| Concourse | [git](https://github.com/concourse/git-resource) | [github-release](https://github.com/concourse/github-release-resource) | [registry-image](https://github.com/concourse/registry-image-resource) | [semver](https://github.com/concourse/semver-resource) | [time](https://github.com/concourse/time-resource) | [mock](https://github.com/concourse/mock-resource) | [s3](https://github.com/concourse/s3-resource) | [slack-alert](https://github.com/arbourd/concourse-slack-alert-resource) |
|--- |--- |--- |--- |--- |--- |--- |--- |--- |
| v7.1.0 | v1.12.0 | v1.5.2 | v1.2.0 | v1.3.0 | v1.5.0 | v0.11.1 | v1.1.1 | v0.15.0 |
| v7.2.0 | v1.12.1 | v1.5.2 | v1.2.1 | v1.3.0 | v1.6.0 | v0.11.1 | v1.1.1 | v0.15.0 |
| v7.3.2 | v1.14.0 | v1.6.1 | v1.3.0 | v1.3.1 | v1.6.0 | v0.11.2 | v1.1.1 | v0.15.0 |
| v7.4.0 | v1.14.0 | v1.6.2 | v1.4.0 | v1.3.4 | v1.6.1 | v0.12.2 | v1.1.2 | v0.15.0 |
| v7.4.1 | v1.14.0 | v1.6.4 | v1.4.0 | v1.3.4 | v1.6.1 | v0.12.2 | v1.1.2 | v0.15.0 |
| v7.4.2 | v1.14.0 | v1.6.4 | v1.4.0 | v1.3.4 | v1.6.1 | v0.12.2 | v1.1.2 | v0.15.0 |
| v7.4.3 | v1.14.0 | v1.6.4 | v1.4.0 | v1.3.4 | v1.6.1 | v0.12.2 | v1.1.2 | v0.15.0 |
| v7.4.4 | v1.14.0 | v1.6.4 | v1.4.0 | v1.3.4 | v1.6.1 | v0.12.2 | v1.1.2 | v0.15.0 |
| v7.5.0 | v1.14.4 | v1.6.4 | v1.4.1 | v1.3.4 | v1.6.2 | v0.12.3 | v1.1.3 | v0.15.0 |
| v7.6.0 | v1.14.5 | v1.6.4 | v1.4.1 | v1.3.4 | v1.6.2 | v0.12.3 | v1.1.3 | v0.15.0 |
| v7.7.0 | v1.14.5 | v1.6.4 | v1.5.0 | v1.3.4 | v1.6.3 | v0.12.3 | v1.2.0 | v0.15.0 |
| v7.7.1 | v1.14.5 | v1.6.4 | v1.5.0 | v1.3.4 | v1.6.3 | v0.12.3 | v1.2.0 | v0.15.0 |
| v7.8.0 | v1.14.5 | v1.7.1 | v1.5.1 | v1.4.0 | v1.6.3 | v0.12.4 | v1.2.1 | v0.15.0 |
| v7.8.1 | v1.14.5 | v1.7.2 | v1.5.1 | v1.4.0 | v1.6.3 | v0.12.4 | v1.2.1 | v0.15.0 |
| v7.8.2 | v1.14.5 | v1.7.2 | v1.5.1 | v1.4.0 | v1.6.3 | v0.12.4 | v1.2.1 | v0.15.0 |
| v7.8.3 | v1.14.5 | v1.7.2 | v1.5.1 | v1.4.0 | v1.6.3 | v0.12.4 | v1.2.1 | v0.15.0 |
| v7.9.0 | v1.14.6 | v1.8.0 | v1.7.0 | v1.5.0 | v1.6.3 | v0.12.4 | v1.2.1 | v0.15.0 |
| v7.9.1 | v1.14.7 | v1.8.0 | v1.7.1 | v1.5.1 | v1.6.3 | v0.12.4 | v1.2.1 | v0.15.0 |
| v7.10.0 | v1.14.7 | v1.8.0 | v1.7.1 | v1.5.1 | v1.6.3 | v0.12.4 | v1.2.1 | v0.15.0 |

## Bundled CLIs

Each Docker image includes the CLIs for Linux/Mac/Windows for the Intel platform - they can be downloaded from the Concourse web console.

## Available Concourse tasks

The following tasks have been ported to the `arm64` platform:

| Task | Image | Version | Description |
|--- |--- |--- |---|
| [dcind](https://github.com/robinhuiser/concourse-arm64/tree/main/external-tasks/dcind) | [rdclda/concourse-dcind-task](https://hub.docker.com/repository/docker/rdclda/concourse-dcind-task) | 1.0.0 | A task for running Docker Compose in Docker | 
| [oci-build](https://github.com/concourse/oci-build-task) | [rdclda/concourse-oci-build-task](https://hub.docker.com/repository/docker/rdclda/concourse-oci-build-task) | 0.9.0 | A task for building OCI images |

## Deploy

Copy the example [docker-compose.yaml](./docker-compose.yaml) to your Raspberry Pi and update the external IP address setting `CONCOURSE_EXTERNAL_URL`.

~~~bash
# On your Macbook M1/M2 machine
$ podman-compose up -d

# Login using fly - update your IP here too ;-)
$ export FLY_TARGET=my-m2
$ fly --target=$FLY_TARGET login \
    --concourse-url=http://concourse.localtest.me:8080 \
    --username=test \
    --password=test
~~~

You can now access the Concourse web console using [http://concourse.localtest.me:8080/](http://concourse.localtest.me:8080/).

## Tests

These tests are provided to verify the correct working of the bundled resource types. 

Prepare some surrounding service requirements first:

~~~bash
# create a public s3 bucket
$ export S3_BUCKET_NAME=rdclda-concourse-s3-test
$ aws s3api create-bucket --acl public-read \
   --bucket $S3_BUCKET_NAME --region us-east-1

# push test file to s3 bucket
$ echo "Looks like the s3 resource is working." | \
   aws s3 cp - s3://$S3_BUCKET_NAME/testfile.txt \
   --acl public-read

# define your Slack webhook URL
$ export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX
~~~

Now, we can deploy and run the tests:

~~~bash
# deploy & kick off the bundled resource tests
$ for resource in registry-image time git s3 mock slack-alert; do
    fly -t $FLY_TARGET set-pipeline -n -p test-${resource}-resource -c tests/$resource-resource.yaml \
      --var s3-bucket-name=$S3_BUCKET_NAME \
      --var slack-webhook-url=$SLACK_WEBHOOK_URL
    fly -t $FLY_TARGET unpause-pipeline -p test-${resource}-resource
    fly -t $FLY_TARGET trigger-job --job test-${resource}-resource/test-job
done

# deploy & kick off the external task test
$ for task in dcind oci-build; do
    fly -t $FLY_TARGET set-pipeline -n -p test-${task}-task -c external-tasks/${task}/example/pipe.yaml
    fly -t $FLY_TARGET unpause-pipeline -p test-${task}-task
    fly -t $FLY_TARGET trigger-job --job test-${task}-task/test-job
done
~~~

Use the web console to verify the status of the tests.

## BIY

Follow the steps below if you want to build the images yourself.
### Prerequisites

* Raspberry Pi 4 with 8Gb of memory (if you want to build `elm`)
* Docker daemon + Docker CLI (buildx enabled)
* 4Gb of (Docker assigned) memory
* Bash shell

### Build elm

Elm is a build dependency for the Concourse web component, but is not available for `arm64` - therefore elm `v0.19.1` has been pre-compiled on `arm64` and packaged under `./dist` within this repository.

The two main reasons to not make the elm native binary compilation part of the Concourse CI build are:

* Docker `buildx` fails (crashes) when trying to compile this on `amd64` platform
* Takes too long

In case you want to build elm yourself, follow the steps below:

~~~bash
# Based upon Ubuntu 20.04
# Raspberry Pi 4 with 8Gb memory and SSD storage attached
# Expect build to take up to 3+ hours
apt-get update && apt-get install ghc cabal-install -y
apt-get install git curl -y

git config --global user.email "info@rdc.pt" && \
git config --global user.name "Robin Daniel Consultants, Lda."

mkdir -p /tmp/build && cd /tmp/build
git clone https://github.com/dmy/elm-raspberry-pi.git ./elm-raspberry-pi
cd ./elm-raspberry-pi && git checkout tags/20200611

cd /tmp/build
git clone https://github.com/elm/compiler.git ./elm/compiler
cd ./elm/compiler && git checkout tags/0.19.1

git am -s /tmp/build/elm-raspberry-pi/patches/elm-0.19.1.patch
cabal new-update
cabal new-configure --ghc-option=-split-sections
cabal new-build
~~~

After the last step, the build will output the elm binary path.

### Build Concourse

You will find under the `./build-specs` directory the available configurations for building Concourse CI for `arm64`.

~~~bash
# Kick off the build - specify the concourse version you want to build
# Using Intel / Docker Compose:
./build.sh 7.10.0

# Using ARM64 (M1, M2) and podman:
./build_podman_arm64.sh 7.10.0
~~~

The generated Docker image will be pushed to the specified repository defined in the `.env` file.
