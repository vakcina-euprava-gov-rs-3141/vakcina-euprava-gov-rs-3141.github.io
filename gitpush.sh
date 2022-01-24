#!/bin/bash

# github_user=$1
# github_url="https://github.com/vakcina-euprava-gov-rs-3136/vakcina-euprava-gov-rs-3136.github.io"
# echo 'Please start tor service and enable terminal tor proxying with the following command: '
# echo "sudo service tor restart && . torsocks on"
# read -p "Is tor enabled on this terminal?"
# sudo rm -r .git

# git commit --amend --reset-author


dirname=${PWD##*/}
github_user=$( echo $dirname | cut -d "." -f1 )
github_url="https://github.com/"$github_user"/"$github_user".github.io"
publicip=$( curl -s icanhazip.com )
read -p "Press any key to restart tor service"
echo '--- Restarting tor service ---'
sudo service tor restart && sleep 3
echo '--- Activating torsocks for current terminal session ---'
. torsocks on
torpublicip=$( curl -s icanhazip.com )
echo "--- WAN public IP/Onion public IP: $publicip/$torpublicip"
echo "--- Username: $github_user"
echo "--- Repository URL: $github_url"
echo "--- Please input personal token: ---"
read personal_token

git init
git config user.name $github_user
git config user.password $personal_token
git config credential.helper store
git remote add origin $github_url
git add -A
git branch -M main
git commit -m 'Test'
git push -f -u origin main
sleep 2
echo '--- Dectivating torsocks for current terminal session ---'
. torsocks off
echo "Deleting .git folder"
sudo rm -r .git