#!/bin/bash

# Use for cloning a private ARMadillo repository into the Pi's

sudo apt-get install git -qy

export  github_token=<YOUR GITHUB ACCESS TOKEN HERE>    # Follow https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line
export  github_repo=<YOUR ARMadillo REPO HERE>          # For example: github.com/your_github_username/ARMadillo.git (no need for https://)
export  dest_dir=<DESTINATION DIRECTORY HERE>           # For example: armadillo

git clone https://$github_token@$github_repo $dest_dir

rm -f /home/pi/git_clone_private.sh
