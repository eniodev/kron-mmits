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
     [-mm | --modify-message] [MESSAGE]                  modify the message of the latest unpushed commit
     [-p | --populate] [YY-MM-DD | MM | YY | (YY-MM)]    populate your git history with fake commits

Kron-mmits
}  

# Count the number of unpushed commits
curr_branch=$(git name-rev --name-only HEAD)
local_commits=$(git rev-list --right-only --count origin/$curr_branch...$curr_branch) 

# List all unpushed commits
function list() {
    if [ $local_commits != 0 ]; then 
        logs=$(git log origin/$curr_branch..HEAD --pretty="%H%n%an%n%ai%n___%n%n%n") # TODO: list commits as an desc ordered list
        echo -n "$logs" > log.txt
    else
        echo "No unpushed commits to see here..."
    fi
}

# Modify the date of the latest unpushed commit 
function modify_date() { #TODO: Add validation to parameters
    if [ $local_commits != 0 ]; then
        # TODO: Check whether its linux or bsd and validate accordingly (-d insted of -j -f)
        # Or just add an auto instal for gdate on bsd and set alias date=gdate 
        if [[ "$(date -j -f "%Y-%m-%d %H:%M:%S" "$1" +%s 2>/dev/null)" ]]; then
            export GIT_COMMITTER_DATE="$1"
            git commit --amend --no-edit --date="$1"
        else
            echo "[Invalid date format] : You may follow the pattern YY-MM-DD HH:MM:SS"
        fi
    fi
}

function modify_message() {
    if [ $local_commits != 0 ]; then
        git commit --amend -m "$1"
    else
        echo "[Error] : You don't have any commits yet"
    fi
}

# Verify if the current dir is a git repo
if [ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]; then
  while [[ $# -gt 0 ]]; do
    case "$1" in 
        -h | --help ) help; exit; ;;
        -l | --list ) list; exit; ;;
        -md | --modify-date ) modify_date "$2"; exit; ;;
        -mm | --modify-message ) modify_message "$2"; exit; ;;
        * ) echo "[Invalid argument] : use -h or --help for help"; break ;; 
    esac
  done
else
  echo "[Invalied directory] : Kron is designed to work inside repositories only :)"
fi