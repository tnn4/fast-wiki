#!/bin/bash

# generates markdwon picture elements from a  list of images in content/ directory 

target_file=README.md

for file in $(find ${content}); do
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    printf "## %s\n\n" $filename >> $target_file
    printf "![Mon]($file)\n\n" >> $target_file
done