#!/bin/bash

# Referecnce:
# http://wiki.bash-hackers.org/howto/getopts_tutorial

# -d <root dir to add>, defaults to current directory
# -o <output dir of cscope.files>, will use last instance of -o, defaults to current dir
# -e <extension>, by default will use *.c, *.h, *.cpp, *.hpp, *.s, and *.S
# -b <additional cscope flags besides b> build database
out_name="cscope.files";

dirs[0]=$(pwd);
exts=('c' 'h' 'cpp' 'hpp' 's' 'S');
exts_set=0;
out_dir=${dirs[0]};
out_path="$out_dir/$out_name";
dir_index=0;
build_db=0;
build_flags="";
while getopts ":d:o:e:b:" opt; do
    case $opt in
        d)
            dir=$(readlink -f $OPTARG);
            dirs[$dir_index]=$dir;
            dir_index=$((dir_index+1));
            echo "-d added $dir!";
            ;;
        o)
            out_dir=$(readlink -f $OPTARG);
            out_path="$out_dir/$out_name";
            echo "-o outputting to $out_path";
            ;;
        e)
            if [ $exts_set -eq 0 ]; then
                exts=();
                exts_set=1;
            fi
            ext=$OPTARG;
            exts+=($ext);
            echo "-e added extension *.$ext";
            ;;
        b)
            build_db=1;
            args=$OPTARG;
            ;;
        \?)
            echo "Invalid option: -$OPTARG";
            ;;
    esac
done
echo "Dirs: ${dirs[@]}";
echo "Exts: ${exts[@]}";

mkdir -p $out_dir;

if [ -f $out_path ]; then
    mv $out_path "$out_path.bak"; # backup cscope.files if they exist
fi

# generate the names to find
find_names="";
for ext in "${exts[@]}"; do
    find_names+="-name '*.$ext' -o ";
done
find_names=${find_names%" -o "};   # strip trailing -o

# generate the command to run
for dir in "${dirs[@]}"; do
    cmd="find $dir -type f \( $find_names \) -print >> $out_path";
    #echo $cmd;
    eval $cmd;
done

# if build desired
if [[ $build_db -eq 1 ]]; then
    curr_dir=$(pwd);
    cscope_flags="-b$arg";
    cd $out_dir;
    cscope $cscope_flags;
    cd $curr_dir;
    #echo "Generated cscope files via $cscope_flags"; 
fi
