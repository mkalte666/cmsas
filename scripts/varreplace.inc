function varReplace
{
    while read -r line; do eval "echo -e \"$line\""; done <<< "$1"
}
