#!/bin/sh

############################
# 1 create version.json commit info file
############################

echo *************BEGIN CROUD VERSION INFO*************

export git_ref=`git symbolic-ref -q --short HEAD || git describe --tags --exact-match`
export git_ref_hash=`git rev-parse HEAD`

echo "writing commit details"
echo "git_ref:$git_ref"
echo "git_ref_hash:$git_ref_hash"

mkdir -p protected-files/
mkdir -p public && mkdir -p public/protected-files/

printf '{"version": "%s","commit": "%s"}\n' $git_ref $git_ref_hash > version.json
printf '{"version": "%s","commit": "%s"}\n' $git_ref $git_ref_hash > public/version.json

echo "writing log history"
git --no-pager log > protected-files/commit-log.txt
git --no-pager log > public/protected-files/commit-log.txt

echo *************END CROUD VERSION INFO*************

############################
# 2 create docker image tag
############################

# RULES: 

# COMMIT MESSAGE BASED IMAGE TAGGING 
# git commit message contains [integration] or [staging]
# [integration]  -> integration
# [staging]      -> staging-BRANCHNAME
# TAG BASED IMAGE TAGGING
# git tag/branch -> docker image tag
# rc-*           -> TBC
# release-*      -> TBC

echo *************BEGIN CROUD IMAGE TAGGER*************

# set vars
docker_image_tagging_strategy="$DRONE_BUILD_EVENT"
#docker_image_tag="TODO"

# clean-up
if [ -f ".tags" ] ; then echo "removing .tags file"; rm ".tags"; fi
# tag or message
if [[ "$docker_image_tagging_strategy" == "push" ]];
then
    echo "build trigger is push event, examining commit message..."
    staging_feature_name=$(echo "staging-${DRONE_COMMIT_BRANCH#*/}" | tr '[:upper:]' '[:lower:]')
    case $DRONE_COMMIT_MESSAGE in *"[staging]"* ) docker_image_tag=$staging_feature_name ;; *"[integration]"* ) docker_image_tag=integration ;; *) echo "NO MATCHING COMMITS FOUND, HALTING CD BUILD"; exit 1;; esac
    echo "image tag (from commit message) for build is $docker_image_tag"
    echo $docker_image_tag > .tags
else if [[ "$docker_image_tagging_strategy" == "tag" ]];
then
    # echo "image tag (from tag) for build is $docker_image_tag"
    echo "image tag (from tag) for build is TODO"
    # echo $docker_image_tag > .tags
fi



echo *************END CROUD IMAGE TAGGER*************