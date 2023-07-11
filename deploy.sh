#!/bin/bash

# use with crontab
# edit crontab file
# crontab -e
# run once an hour:
# * */1 * * * this/script.sh

# input folders
# preprocess files
template_dir=pre_src
src=book/.
# output folder
dst=/home/w3/public

draft=draft/README.md
homepage=src/README.md

preprocess () {
    for template_var in template_dir/*.env; do
        . $template_var
        out=$(echo "$template_var" | set "s/env/md")
        final=src/$(basename "${out}")
        envsubst < "$out" > "$final"
    done
}

main () {
    echo "Building book..."

    # bin/autogen-readme.sh

    # Ask user to confirm overwrite if book already exists
    if [[ -d $dst ]];then
        echo "Book already exists"
        read -r -p "Do you want to overwrite (y/n)?" input
        if [[ $input == 'y' || $input == 'Y' || $input == 'yes' ]];then
            rm -rf $dst
            echo "Cleaned out old book"  
        else
            exit 0
        fi 
    fi

    mv src/SUMMARY.md src/TABLE_OF_CONTENTS.md

    shopt -s nullglob #i ignore failed match

    echo "[START] Processing templates."
    # process draft templates
    for draft_env in pre_src/*.env; do
        #echo "$draft_file"
        # add env variables for envsubst
        . "$draft_env"
        draft_md=$(echo $draft_env | sed "s/env/md/")
        echo "draft_md: $draft_md"
        # replace .env with .md for destination
        final=src/$(basename "${draft_md}")
        envsubst < "${draft_md}" > "${final}"
    done
    printf "[DONE] Processing templates.\n"

    # see: https://stackoverflow.com/questions/1401482/yyyy-mm-dd-format-date-in-shell-script
    # put current date as yyyy-mm-dd HH:MM:SS in $date
    # printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1
    DATE=$(date +%Y-%m-%d" "%H:%M:%S)
    DATE="${DATE} ${TZ}"
    # generate mdbook summaries for src
    if [[ $(mdbook-auto-gen-summary gen src) -eq 0 ]]; then
        echo "Generated summaries"

        if [[ $(mdbook build) -eq 0 ]];then
            cp -r ${src} ${dst}
            printf "%s [OK] website built.\n" "$DATE" | tee build.log
        else
            printf "%s [ERROR] unable to build.\n" "$DATE" | tee build.log
        fi
    else
        printf "%s [ERROR] unable to build.\n" "$DATE" | tee build.log
        exit 1
    fi

    echo "TIP: To edit content in real-time and watch for file changes Run: mdbook serve"
}

main