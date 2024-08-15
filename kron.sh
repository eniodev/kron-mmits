#!/bin/bash

# Initialize kron

# Basic usage
function help() {
   cat << Kron-mmits
   :: Kron is a basic git cli wrapper for modifying git history ::
   Rearrange your commit history as you desire and your GitHub graph too :>
   
   Usage: kron [--action] [--args]

   Actions & arguments:
     [-h | --help]                                       show this help message and exit
     [-l | --list]                                       list all unpushed commits
     [-md | --modify-date] [YY-MM-DD HH:MM:SS]           modify the date of the latest unpushed commit
     [-p | --populate] [YY-MM-DD | MM | YY | (YY-MM)]    populate your git history with fake commits

Kron-mmits
}  

# Count the number of commits
commits=$(git rev-list --count HEAD) 

# List all unpushed commits
function list() {
    curr_branch=$(git name-rev --name-only HEAD)
    if [ $commits ]; then 
        logs=$(git log origin/$curr_branch..HEAD --pretty="%H%n%an%n%ai%n___%n%n%n") # TODO: list commits as an desc ordered list
        echo -n "$logs" > log.txt
    else
        echo "No unpushed commits to see here..."
    fi
}

# Modify the date of the latest unpushed commit 
function modify_date() { #TODO: Add validation to parameters
    if [ $commits ]; then
        #TODO: Check whether its linux or bsd and validate accordingly (-d insted of -j -f)
        if [[ "$(date -j -f "%Y-%m-%d %H:%M:%S" "$1" +%s 2>/dev/null)" ]]; then
            export GIT_COMMITTER_DATE="$1"
            git commit --amend --no-edit --date="$1"
        else
            echo "[Invalid date format] : You may follow the pattern YY-MM-DD HH:MM:SS"
        fi
    fi
}

# Verify if the current dir is a git repo
if [ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]; then
  while [[ $# -gt 0 ]]; do
    case "$1" in 
        -h | --help ) help; exit; ;;
        -l | --list ) list; exit; ;;
        -md | --modify-date ) modify_date "$2"; exit; ;;
        * ) echo "[Invalid argument] : use -h or --help for help"; break ;; 
    esac
  done
else
  echo "[Invalid directory] : Kron is designed to work inside git repositories only :)"
fi