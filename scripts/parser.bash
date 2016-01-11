#!/bin/bash

my_dir="$(dirname "$0")"

source "$my_dir/varreplace.inc"

inFile=$1
header=$(sed '/^$/q' $inFile) 
md=$(sed '1,/^$/d' $inFile)

menuPriority=999
createMenuEntry=true
title="no title"
parentNode=""
menuDefDir=$2

#do the thing everyone hates
eval "$header"

#them basename for the menu def
baseF=$(basename "$inFile")
baseF=${baseF%.*}

menuFilename="$menuDefDir/$menuPriority-$baseF.mdef"

if [ "$parentNode" != "" ]; then
    if [ -e "$menuDefDir/$parentNode.mdef" ]; then
        menuFilename="$menuDefDir/$parentNode.mdef"
        #todo: append
        tmp=$( grep "{" "$menuFilename" >/dev/null && sed -e 's/}/\;/g' "$menuFilename" || echo -e "$(cat "$menuFilename")\n{\n"
        )
        echo -e "$tmp\n$title:${baseF}.html\n}" > "$menuFilename"
    else 
        echo -e "\n{\n$title:${baseF}.html\n}" > "$menuFilename"
    fi 
else
    if [ -e "$menuFilename" ]; then
        tmp=$(cat "$menuFilename")
        echo -e "$title:${baseF}.html\n$tmp" > "$menuFileName"
    else 
        echo "$title:${baseF}.html" > "$menuFilename"
    fi 
fi


#echo "$title:${baseF%.*}.html" > $menuDefDir/$menuPriority-$baseF.mdef

#while read -r line; do eval "echo \"$line\""; done <<< "$md" | markdown
varReplace "$md" | markdown 
