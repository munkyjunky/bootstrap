#!/bin/bash

# Install Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! [ -x "$(command -v brew)" ]; then
    CI=1 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

if [[ "$OSTYPE" == "msys" ]]; then
  curl --output python-3.8.exe https://www.python.org/ftp/python/3.8.0/python-3.8.0-amd64-webinstall.exe
  msiexec python-3.8.0.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
fi

# Add python install location to PATH for duration of this script
export PATH=$PATH:~/Library/Python/2.7/bin # TODO: use `which python` for path?

# Install Pip
if ! [ -x "$(command -v pip)" ]; then
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python get-pip.py --user
  rm get-pip.py
fi

# Install Ansible
if ! [ -x "$(command -v ansible)" ]; then
  pip install --user ansible
fi

# Gather some default variables (in-case they're already set)
[ ! -z "$(git config user.name)" ] && export GIT_USERNAME="$(git config user.name)" || export GIT_USERNAME=""
[ ! -z "$(git config user.email)" ] && export GIT_EMAIL="$(git config user.email)" || export GIT_EMAIL=""

# Run the playbook - prompt for password for anything that needs become: true
ansible-playbook "$(dirname $0)/playbook.yml" --ask-become-pass
