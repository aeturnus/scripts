#!/bin/bash

# Referecnce:
# http://wiki.bash-hackers.org/howto/getopts_tutorial
out_name="cscope.files";

root_dir=$(pwd);
out_dir=$root_dir;
out_path="$out_dir/$out_name";

while getopts ":a" opt; do
    case $opt in
        a)
            echo "-a triggered";
            ;;
        \?)
            echo "Invalid option: -$OPTARG";
            ;;
    esac
done
find $root_dir -type f \( -name "*.[chsS]" -o -name "*.cpp" -o -name "*.hpp" \) -print >> cscope.files
