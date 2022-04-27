#!/usr/bin/bash
#
# Copyright (C) 2022 ArianK16a
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICES="davinci"
PROJECTS="lineage-19.1"
VARIANTS="vanilla gms"
WORKING_DIR="~/old_hdd"

if [[ ! -d ${WORKING_DIR} ]]; then
    mkdir -p ${WORKING_DIR}
fi

for project in ${PROJECTS}; do
    # Ensure the project exists
    if [[ ! -d ${WORKING_DIR}/${project} ]]; then
        mkdir -p ${WORKING_DIR}/${project}
    fi
    cd ${WORKING_DIR}/${project}

    # Initialize repo, sync later after adding device specific manifest
    repo init -u https://github.com/LineageOS/android.git -b lineage-19.1

    # Setup build script
    git clone git@github.com:ArianK16a/android_tools_buildscript.git tools/buildscript -b main
    ### TEMPORARY ####
    export DEBUG_BUILD=1
    #### TEMPORARY END ###
    source ./tools/buildscript/build.sh

    for device in ${DEVICES}; do
        if [[ -d .repo/local_manifests ]]; then
            rm -rf .repo/local_manifests
        fi
        mkdir .repo/local_manifests
        wget https://raw.githubusercontent.com/arian-ota/build-config/main/manifests/${project}/${device}/roomservice.xml
        repo sync --detach --no-clone-bundle --fail-fast --current-branch --force-sync --force-remove-dirty
        for variant in ${VARIANTS}; do
            build ${device} ${variant}
        done
    done
done