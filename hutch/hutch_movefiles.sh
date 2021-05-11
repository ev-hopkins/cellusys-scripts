#!/bin/bash

TRACE_DIR=/var/traces
for f in $TRACE_DIR/*.pcap; do
        if [ -f "$f" ] # does file exist?
        then
                dir=$(echo "$f" | awk -F "-" '{print $2 "-" $3}')
                if [ ! -d "$dir" ] # check if string found
                then
                        mkdir "$TRACE_DIR/$dir"  # create dir
                        mv "$f" "$TRACE_DIR/$dir"     # move file into new dir
                else
                        mv "$f" "$TRACE_DIR/$dir"     # move file into new dir
                fi
        else
           echo "INCORRECT FILE FORMAT: \""$f"\"" # print error if file format is unexpected
        fi
done
