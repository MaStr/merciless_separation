#!/bin/bash
# Script to update Merciless intervention server

set -e 
set -o pipefail

export GIT_PAGER=cat

MAXWAIT_STEPS=62
SLEEP_TIME=2

env_runmode="unset"
rundate=$( date +"%Y-%m-%d" )
debug=0
ignore_wait_timeout_error=0
run_monit=1

git_url="https://github.com/MaStr/merciless_separation.git"
git_path="/opt/merciless_separation"

#task_list="openvpn squid3 perl-proxy"
task_list="openvpn privoxy perl-proxy lighttpd"

work_tag=""

privoxy_user="privoxy"

debug(){
   if [ "$debug" -eq "1" ] ; then
        echo "DEBUG: " $@
   fi
}

usage_help(){
    echo "$0: usage

    -h : print this information
    -D : enable DEBUG mode
    -i : ingore Wait-Timeouts
    -I : Disable Waits

    -d : set rundate, if ommit current date is used
    -g : git repository_path
    -u : git repository url

    -e : environment 'lab|live...'

    -G : Run only actions again git (useful for initial setup)


    Exits with following codes:
    
         0 :  Update processed, everything ok
         1 :  nothing to do
         2 :  Help message printed
        10 :  Monit issues with tasks 
        11 :  Monit Task Timeout

    "
    exit 2
}

# Asks Monit for a status
#  returns
#    0   = Running
#    1   = Initializing
#    >10 = other
#    99  = error
monit_status=0
check_status(){
    local task="$1"

    local str_status=$( monit summary | grep $task | grep Process | awk '{print $3$4}')

    case $str_status in
        "") monit_status=99 && return 0
            ;;
        "Running" ) monit_status=0 && return 0
                    ;;
    "Initializing") monit_status=1 && return 0
                    ;;
    esac
    monit_status=11
    return 0
}

# Is stopping and return when issued
stop_vote(){
    local task="$1"

    check_status "$task"
    if [ $monit_status -le 1 ] ; then
       echo "Issue Monit stop for $task"
       monit stop "$task"
    elif [ $monit_status -eq 99 ] ; then
        echo "ERROR: it seems there is an issue with the task configuration of : $task"
        exit 10
    fi
    return 0
} 

stop_vote_wait(){
    local task="$1"

    stop_vote "$task"

    test  $MAXWAIT_STEPS -eq 0  && return 0

    waits=$MAXWAIT_STEPS
    check_status "$task"
    while [ $monit_status -le 1 ]; do
        if [ $waits -gt 0 ]; then
            ((waits--))
        else
           echo "ERROR: Max wait time reached"
           exit 10
        fi
        debug "$task: Process still active, waiting"
        sleep $SLEEP_TIME

        check_status "$task"
    done
    return 0
}

start_vote(){
    local task="$1"

    check_status "$task"
    if [ $monit_status -ge 11 ] && [ $monit_status -lt 99 ]  ; then
       echo "Issue Monit start for $task"
       if ! monit start "$task" ; then
            sleep 10
            monit start "$task"
       fi
    elif [ $monit_status -eq 99 ] ; then
        echo "ERROR: it seems there is an issue with the task configuration of : $task"
        exit 10
    fi
    return 0
} 

start_vote_wait(){
    local task="$1"

    start_vote "$task"
    test  $MAXWAIT_STEPS -eq 0  && return 0

    waits=$MAXWAIT_STEPS
    check_status "$task"
    while [ $monit_status -ne 0 ]; do
        if [ $waits -gt 0 ]; then
            ((waits--))
        else
           echo "ERROR: Max wait time reached"
           echo ""
           echo "ERROR: STARTING TASK $task FAILED !!!"
           test  $ignore_wait_timeout_error -eq 0  && exit 11
           echo "Timeout ignored."
           return 0
        fi
        debug "$task: Process starting, waiting"
        sleep $SLEEP_TIME

        check_status "$task"
    done
    return 0
}

fs_sync(){

    echo "Fixing monit permissions"
    chmod -R 0700 "${git_path}/monit"

    echo "Fixing privoxy user permissions"
    chown -R privoxy "${git_path}/privoxy"
}


while getopts ":hiIGDd:g:u:e:b:" opt; do
    case $opt in
        h)  usage_help
            ;;
        D)  debug=1 
            ;;
        i)  ignore_wait_timeout_error=1
            echo "Ignoring Wait Timouts"
            ;;
        I)  MAXWAIT_STEPS=0
            echo "Disabling Waits"
            ;;
        d)  rundate=$OPTARG
            ;;
        g)  git_path="$OPTARG"
            ;;
        u)  git_url="$OPTARG"
            ;;
        b)  branch="$OPTARG"
            ;;
        e)   env_runmode="$OPTARG"
            ;;
        G)  run_monit=0
            ;;
        \?)  usage_help
     esac
done

if [ "$env_runmode" = "unset" ]; then
    echo "ERROR: You need to set at leat an environment"
    usage_help
fi

work_tag="${env_runmode}-${rundate}"
debug "Work tag is: $work_tag"

if test ! -z "$branch" ; then
   debug "Overwrite by branch opt"
   work_tag="$branch"
fi

cd "$git_path"
debug $( git fetch --all )

if git tag | grep -q -e "${work_tag}" ; then
    echo "${work_tag} found in repository"

else
    debug "Nothing to do for today"
    exit 1
fi

if [ $run_monit -eq 1 ] ; then
    for task in $task_list ; do
        stop_vote_wait $task
    done
fi

git checkout -f ${env_runmode} 2>&1 
git pull 2>&1
git checkout "${work_tag}" 2>&1

fs_sync


if [ $MAXWAIT_STEPS -eq 0 ] ; then
    echo "Waiting 2 seconds to prevent overlapping monit actions"
    sleep 2
fi

if [ $run_monit -eq 1 ] ; then
    #for task in "perl_proxy squid3 openvpn"; do
    reverse_list=$( echo $task_list | sed 's/ /\n/g' | tac | sed ':a;$!{N;ba};s/\n/ /g')
    for task in  $reverse_list  ; do 
        start_vote_wait "$task"
    done
fi

echo "Done"
