#!/usr/bin/env bash

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

complete -C /usr/local/bin/terraform terraform
