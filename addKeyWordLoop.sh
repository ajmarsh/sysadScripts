#!/bin/bash

# addKeyWordLoop.sh
# adds keywords to hosts in OpsView
# ajmarsh 03-19-2014

# Usage:
#       For auditing/review, ./addKeyWordLoop.sh | less
#       for execution,  ./addKeyWordLoop.sh | bash

datafile=/home/amarsh/opsView/list1.txt
cmd="/usr/local/bin/opsview -p default --op add-keyword"

die(){
        echo $@ 1>&2
        exit 1
}

if ! [[ -f $datafile ]]; then
        die "'${datafile}' missing, giving up"
fi

cat $datafile | \
        awk -v cmd="${cmd}" '
        /^#/ { next; }
        /^$/ { next; }
        (NF != 2) {
                print "#ERROR, wrong number of fields line " NR ": " $0;
                next; };
        {
                if ( kword[$1] ) {
                        print "#WARNING, collision line " NR " on host: " $1;
                }

                kword[$1] = $2;
        }
        END {
                for ( h in kword ) {
                        printf("%s -n %s -c %s\n",cmd,h,kword[h]);
                }
        }'
