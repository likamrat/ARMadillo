#!/bin/bash

# Use for cloning a private ARMadillo repository into the Pi's

sudo apt-get install git -qy

export  github_token=65c8bf1a0848de28aecd87083b7e57c776cf6f24   # Follow https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line
export  github_repo=github.com/azure-octo/ARMadillo.git         # For example: github.com/your_github_username/ARMadillo.git (no need for https://)
export  dest_dir=armadillo                                      # For example: armadillo

git clone https://$github_token@$github_repo $dest_dir

rm -f /home/pi/git_clone_private.sh
