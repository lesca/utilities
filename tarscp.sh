#!/bin/bash
# tarscp <srcDir> <user@host:/dest/dir/>
src=$1
id=$(echo $2 | cut -d: -f1)
dest=$(echo $2 | cut -d: -f2)

helpMsg()
{
echo Usage:
echo "$0 <src> <user@remote:/dest/path>"
exit 1
}

if [ "$1" == "" ] ; then
    helpMsg
elif [ "$2" == "" ] ; then
    helpMsg
elif [ "$id" == "$dest" ] ; then
    echo Error: Missing destination path
    helpMsg
elif [ "$dest" == "" ] ; then
    echo Error: Missing destination path
    helpMsg
fi

echo Source folder: $src
echo Destination: $dest
echo Identity: $id
read -n1 -p "Press any key to continue ..."
echo
echo Start now!
tar -cvSf - $src --totals=USR1 --checkpoint=100000 --checkpoint-action=echo="#%u: %T" | ssh $id "(cd $dest ; tar -xf -)"
