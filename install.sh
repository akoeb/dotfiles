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
    echo "Basename command is missing, vannot proceed"
    exit 1
fi

# TODO check existance of sha1sum

# function to copy is checksum is not changed. makes also backup
function copy() {
    local from=$1
    local to=$2

    # compare checksums:
    if [ "$(sha1sum $from | awk '{print $1}' )" == "$(sha1sum $to | awk '{print $1}')" ] 
    then
        # files are identical
        return
    fi

    backup_file=${to}.$( date +%Y%m%d%H%M )
    cp $to $backup_file
    cp $from $to
}

# TODO cd into the base directory of the repository

# copy rcfiles
for file in rcfiles/*
do
    copy $file $HOME/.$(basename $file)
done

