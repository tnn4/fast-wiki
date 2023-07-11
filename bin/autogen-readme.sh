#!/bin/bash

shopt -s globstar

dir="../src"

path=$1

mkdreadme () {
	for file in "$dir"/**/*;do
    	if [ -d $file ]; then
    	    # create README.md in that directory
    	    
    	    if [[ $(touch $file/README.md) -eq 0 ]];then
				echo "created $file/README.md"
			fi
    	fi
	done
}

main () {
	:
}

main