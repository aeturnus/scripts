#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Expected file names sans \".h\""
fi


for name in "$@"
do
    fname=$name.h
    head="__${name^^}_H__"
    echo "#ifndef $head" >> $fname
    echo "#define $head" >> $fname
    echo "" >> $fname
    echo "#ifdef __cplusplus" >> $fname
    echo "extern \"C\" {" >> $fname
    echo "#endif" >> $fname
    echo "" >> $fname
    echo "#ifdef __cplusplus" >> $fname
    echo "}" >> $fname
    echo "#endif" >> $fname
    echo "" >> $fname
    echo "#endif//$head" >> $fname
done
