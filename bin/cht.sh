#!/usr/bin/env bash

languages="cpp c lua python bash javascript html css"
core_utils="find xargs sed awk grep nmap tcpdump curl tar tmux"

selected=$(echo -e "${languages// /\\n}\n${core_utils// /\\n}" | fzf --prompt="Cheat.sh > " --layout=reverse --border)

[[ -z $selected ]] && exit 0

read -p "Query ($selected): " query
query=$(echo "$query" | tr ' ' '+')

if echo "$languages" | grep -qw "$selected"; then
    lang="$selected"
    [[ -n "$query" ]] && url="cht.sh/$selected/$query?T" || url="cht.sh/$selected?T"
else
    lang="bash"
    [[ -n "$query" ]] && url="cht.sh/$selected~$query?T" || url="cht.sh/$selected?T"
fi

curl -s "$url" | bat --language="$lang" --style=plain --paging=always
