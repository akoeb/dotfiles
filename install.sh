#!/bin/bash
# install the dotfiles, make backup of old ones
# ATTENTION: not tested yet

# check HOME env var
if [ -z "$HOME" ]
then
    echo "Cannot proceed without HOME environment variable"
    exit 1
fi

# check existence of basename command
if [ -z "$(which basename)" ]
then
    echo "Basename command is missing, cannot proceed"
    exit 1
fi

# check existance of sha1sum
if [ -z "$(which sha1sum)" ]
then
    echo "sha1sum checksum command is missing, cannot proceed"
fi


# function to copy is checksum is not changed. makes also backup
function copy() {
    local from=$1
    local to=$2

    # compare checksums:
    if [ "$(sha1sum $from | awk '{print $1}' )" == "$(sha1sum $to | awk '{print $1}')" ] 
    then
        # files are identical
        echo "Files $from and $to are identical, skipping."
        return
    fi

    backup_file=$(dirname $to)/${to#$(dirname $to)/.}.$( date +%Y%m%d%H%M )
    echo "Overwriting file $to, original is backed up to $backup_file (consider updating the dotfile repo)"
    cp $to $backup_file
    cp $from $to
}

# cd into the base directory of the repository
cd $(dirname ${PWD}/$0)

# copy rcfiles
for file in rcfiles/*
do
    copy $file $HOME/.$(basename $file)
done

