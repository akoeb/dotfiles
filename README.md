dotfiles
========

My collection of dotfiles

## currently present ##
* vimrc
* bashrc

install
=======

clone the repository somewhere and execute the install script in the repository root.
The install script will create backups of the files that are overwritten, the name is 
basename of the original file (without dot), expanded with timestamp.

if files are not changed (checksum sha1), then they will not be overwritten.

expand
======

The rcfiles directory contains simple rcfiles, if you drop the script there then the 
install script will pick it up and drop it to $HOME (with  dot prepended), possible 
existing files are backed up.

possible subdirs are NOT implemented yet

TODO
=====

* possibility to have dot-directories in rcfiles
