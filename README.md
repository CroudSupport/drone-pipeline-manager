# drone-pipeline-manager


A Drone plugin to interrogate the last commit and determine, based on either tags or commit messages what image (if any) should be published to the container registry. The Drone plugin is implemted as a bash script.

## Usage

added the following to the .drone.yaml file
```
pipeline:
  setup-image-tag:
    image: croudtech/drone-pipeline-manager:0.5.3
  next-pipeline-step
    ....
```

## Logic

In order to trigger a published image, the login below is used to write a local ".tags" file - if this file is found by the `croudtech/drone-docker` plugin, then the image will be published with the corresponding tag, if no file exists and `skip_untagged: true` for the `croudtech/drone-docker` plugin the no image will be published.

The logic used is below to ascertain if an image should be published:

1. event is push and commit message contains "[integration] => tag should be "integration"
1. event is push and commit message contains "[staging] && branch name starts with "feature/" => tag should be "staging-[lower-case-current-branch-name]"
1. event is tag and tagname  starts with rc-x.y.y => tag should be "rc-x.y.z" (not iplemented)
1. event is tag and tagname  starts with release-x.y.y => tag should be "release-x.y.z" (not iplemented)
1. if none of the conditions are true then no .tags file should be created and the plug in should exit

## Rererences
[croudtech/drone-docker](https://github.com/CroudSupport/drone-pipeline-manager) croudtech/drone-docker Source Code