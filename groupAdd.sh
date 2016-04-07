#!/bin/bash

usage() {
        name=`basename $0`
        echo "$name <groupname> <gid>"
        exit 1
}

if [ $1 ] &&  [ \( $1 == "-h" \) -o \( $1 == "--help" \) ]; then
        usage
fi

if [ $# -ne 2 ]; then
        usage
fi

group=$1
gid=$2

# begin

if ! OS=`uname` ; then
        echo "uname fail" 1>&2
        exit 1
fi

case "${OS}" in
        'Linux')
                groupadd --gid $gid $group
        ;;
        'AIX')
                mkgroup id=$gid $group
        ;;
        *)
                usage
        ;;
esac

# EOF
