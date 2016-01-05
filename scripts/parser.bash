#!/bin/bash

my_dir="$(dirname "$0")"

source "$my_dir/varreplace.inc"

inFile=$1
header=$(sed '/^$/q' $inFile) 
md=$(sed '1,/^$/d' $inFile)

menuPriority=999
createMenuEntry=true
title="no title"
menuDefDir=$2

#do the thing everyone hates
eval "$header"

#them basename for the menu def
baseF=$(basename "$inFile")
echo "$title:${baseF%.*}.html" > $menuDefDir/$menuPriority-$baseF.menudef

#while read -r line; do eval "echo \"$line\""; done <<< "$md" | markdown
varReplace "$md" | markdown 
