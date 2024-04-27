#import "/usr/share/ublue-os/justfile"

# User specific recipes list
default:
	just --list

# Fast data sharing pastebin
paste-rs:
	#!/bin/bash

	echo -e '\n Setting up the paste function\n'
	sudo sh -c 'echo -e "\n# paste.rs\nfunction paste() {\n    local file=${1:-/dev/stdin}\n    curl --data-binary @${file} https://paste.rs\n}" >> .bashrc'
	echo -e '\n paste function added to to .bashrc\n'

# User specific Bash aliases
aliases-setup:
	echo -e '\n Setting up the Bash Aliases file\n'
	echo -e "\n# Bash aliases\nif [ -f ~/.bash_aliases ]; then\n. ~/.bash_aliases\nfi" >> .bashrc
	echo -e '\n Bash Aliases setup finished\n'
