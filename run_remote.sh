#!/usr/bin/bash
#
# Copyright (C) 2022 ArianK16a
#
# SPDX-License-Identifier: Apache-2.0
#

if [[ ! -f /home/arian/.remote_mac.txt ]]; then
    return 1
fi

wakeonlan $(cat /home/arian/.remote_mac.txt)
sleep 120
ssh arian@home.local 'bash -s' < build.sh

