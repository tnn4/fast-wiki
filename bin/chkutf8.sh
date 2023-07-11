#!/bin/bash

target_directory=../src

for dir in $(find ${target_directory});do
    for file in $( find ${dir} ); do
        #pass
        echo $file
        iconv -f utf-8 -t utf-8 -c $file
    done
done