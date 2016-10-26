#!/bin/bash

repository="$1"
branch_list="$2"
func="$3"

if test -z "$repository" || \
    test -z "$branch_list"  || \
    test -z "$func" ; then

    echo "USAGE: $0  <path to repository> <path to branch list> <call func>
        callfunc: git_checkout          - performs only a checkout
                  merciless_checkout    - performas a checkout using merciless seperation scripts"
    exit 99
fi

test -e "$branch_list" || exit 15

git_checkout(){
    git checkout $1
}

merciless_checkout(){
    /opt/merciless_separation/bin/update.sh -G -b "$1"
}

cd $repository

max_line=$( wc -l < "$branch_list" )

current_branch=$( git branch | grep -e '*' | sed -e 's|* ||' ) 

if grep -q -e "$current_branch" "$branch_list" ; then
    curr_line=$( grep -n -e "$current_branch" "$branch_list"  | cut -d ':' -f1 )
    if [[ "$curr_line" == "$max_line" ]] ; then
        num_next=1
    else
        num_next=$(( $curr_line + 1 ))
    fi
else
    # Start with first if unknown current branch
    num_next=1
fi


next_branch=$( head -n $num_next $branch_list | tail -n 1 )


$func "$next_branch"
