#!/bin/bash

# Initialize kron

# Basic usage
function help()
{
   cat << Kron-mmits

   Usage: kron [--action] [--args]

   optional arguments:
     -h, --help           show this help message and exit
     -l, --list LIST      list all unpushed commits
     -d, --date DATE      modify the date of the latest unpushed commit
     -v, --verbose        increase the verbosity of the bash script
     -p, --populate       populate your git history with fake commits

Kron-mmits
}  

# List all unpushed commits
function list() 
{
    if [ $(git rev-list --count HEAD) ]; then 
        logs=$(git log --pretty="%H%n%an%n%ai%n___%n%n%n") # TODO: list commits an desc ordered list
        echo -n "$logs" > log.txt
    else
        echo "No unpushed commits to see here..."
    fi
}

# Verify if the current dir is a git repo
if [ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]; then
  while [[ $# -gt 0 ]]; do
    case "$1" in 
        -h | --help ) help; exit; ;;
        -l | --list ) list; exit; ;;
        * ) echo "[Invalid argument] : use -h or --help for help"; break ;; 
    esac
  done
else
  echo "[Invalied directory] : Kron is designed to work inside repositories only :)"
fi