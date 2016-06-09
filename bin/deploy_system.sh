#!/bin/sh

GIT_URL="/opt/merciless_separation"

exchange_folder(){
    old_path="$1"
    git_path="$2"

    if ! test -h "${old_path}" ; then
        test  -d "${old_path}.old" || mv "${old_path}" "${old_path}.old"

        ln -sv "${git_path}"  "${old_path}"

    fi

}

## Script to implement the changes based upon git repository

exchange_folder "/etc/privoxy" "${GIT_URL}/privoxy"
exchange_folder "/etc/monit" "${GIT_URL}/monit"


