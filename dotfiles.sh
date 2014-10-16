#!/bin/bash
# install the dotfiles, make backup of old ones

set -xe

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
    exit 1
fi

# which diff command to run?
if [ -n "$( which colordiff)" ]
then
    DIFFCMD="$(which colordiff)"
elif  [ -n "$( which diff)" ]
then
     DIFFCMD="$(which diff)"
else
     echo "No compatible diff command found, cannot proceed"
     exit 1
fi



# cd into the base directory of the repository
cd $(dirname ${PWD}/$0)

# copy one file to a target if they are not equal. makes backup of the overwritten file.
function copy_file() {
    local from=$1
    local to=$2

    # compare checksums:
    if is_equal $from  $to   
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

# copies all files
function copy_all() {
    # copy rcfiles
    for file in rcfiles/*
    do
        copy_file $file $HOME/.$(basename $file)
    done
}

# invokes DIFFCMD on all files 
function diff_all() {
    # copy rcfiles
    for file in rcfiles/*
    do
        if  is_equal $file $HOME/.$(basename $file) 
        then
            echo "File $file is already up-to-date"
        else
            echo "Showing diff for rcfile $(basename $file)"
            diff_file $file $HOME/.$(basename $file)
        fi
    done
}

# invokes DIFFCMD on two given files
function diff_file() {
    $DIFFCMD $1 $2
}


# returns 0 if two given files are equal
function is_equal() {
    if [ "$(sha1sum $1 | awk '{print $1}' )" == "$(sha1sum $2 | awk '{print $1}')" ]
    then
        return 0
    else
        return 1
    fi
}


case $1 in 
    install)
        # install all files
        copy_all
        ;;
    install_file)
        file=$2
        if [ -e rcfiles/$file ]
        then
            copy_file rcfiles/$file "$HOME/.$(basename $file)"
        else
            echo file $file does not exist!
            exit 1
        fi
        ;;
    diff)
        diff_all
        ;;
    list_files)
        for file in rcfiles/*
        do
            echo $(basename $file)
        done
        ;;
    *)
        echo "usage: $0 [installl | install_file | diff | list_files ]"
        exit 1
        ;;
esac
