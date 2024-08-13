#!/bin/bash

# Initialize kron

# Basic usage
function help()
{
   cat << Kron-mmits

   Usage: kron [--action] [--args]

   optional arguments:
     [-h | --help]                              show this help message and exit
     [-l | --list]                              list all unpushed commits
     [-md | --modify-date] [DATE]               modify the date of the latest unpushed commit
     [-p | --populate] [DATE | YEAR | MONTH]    populate your git history with fake commits

Kron-mmits
}  

# Count the number of commits
commits=$(git rev-list --count HEAD) 

# List all unpushed commits
function list() 
{
    if [ $commits ]; then 
        logs=$(git log --pretty="%H%n%an%n%ai%n___%n%n%n") # TODO: list commits as an desc ordered list
        echo -n "$logs" > log.txt
    else
        echo "No unpushed commits to see here..."
    fi
}

# Modify the date of the latest unpushed commit 
function modify_date() { #TODO: Add validation to parameters
    if [ $commits ]; then
        export GIT_COMMITTER_DATE="$1 $2"
        git commit --amend --no-edit --date="$1 $2"
    fi
}

# Verify if the current dir is a git repo
if [ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]; then
  while [[ $# -gt 0 ]]; do
    case "$1" in 
        -h | --help ) help; exit; ;;
        -l | --list ) list; exit; ;;
        -md | --modify-date ) modify_date $2 $3; exit; ;;
        * ) echo "[Invalid argument] : use -h or --help for help"; break ;; 
    esac
  done
else
  echo "[Invalied directory] : Kron is designed to work inside repositories only :)"
fi