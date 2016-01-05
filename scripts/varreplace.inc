function varReplace
{
    while read -r line; do eval "echo \"$line\""; done <<< "$1"
}
