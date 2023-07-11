#!/bin/bash

this=$(basename $0)

remove_first_param() {
    first="$1"
    shift # see: https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#index-shift-121
}

help() {
    :
    echo "usage ./$this <commit message> <list of files for git add>"
}

string_split_example () {
    IN="bla@some.com;john@home.com"

    # tr = transform
    mails=$(echo $IN | tr ";" "\n")

    for addr in $mails
    do
        echo "> [$addr]"
    done
}

main() {
    # place stuff you want to run here
    
    if [[ $# -eq 0 ]]; then
        help
        exit 0
    fi

    echo "hello world!"
    head=$1
    tail=("${@:2}")
    last="${@: -1}"

    # tail_split="${tail[@]}"

    file_list=""
    for f in "${tail[@]}";do
        echo "adding $f"
        # https://stackoverflow.com/questions/4181703/how-to-concatenate-string-variables-in-bash
        file_list+=" $f"
        # git add $f
    done
    echo "head: $head"
    echo "tail: $file_list"
    echo "git add $file_list"
    echo "git commit -m $head"
    echo "git push"

    git add $file_list
    git commit -m "$head"
    git push
}

main "$@"
