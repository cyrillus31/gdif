#!/bin/bash

function choose_file () {
  file=$(git status | grep 'modified' | awk '{print $2}' | \
    fzf \
    --prompt "Select: " \
    --header "Pick a modified file to see the changes. Exit with <ESC> or <C-c>" \
    --border "rounded" \
    --preview "git diff {} | bat" \
    --preview-window "70%,<40(right)," \


  )
  if [[ -z $file ]]; then
    exit 1 # 0 - success; 1 - error 
  fi;
  echo $file
}

function get_files () {
  editor="less"
  tmux new \; send-keys "git diff $1; printf '\n'; read -p '---Press ENTER to exit---'; exit\;"  C-m \;  
}

function main () {
  while [[ true ]]; do
    file=$(choose_file)
    if [[ $? -eq 1 ]]; then
      break
    fi;
    get_files $file &> /dev/null
  done;
}


main


