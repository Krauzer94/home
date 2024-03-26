#!/bin/bash

# Command for printout
echo -e ""
read -p "Command: " command

# Execute the user command and pipe its output to curl
output=$(eval "$command" |& curl --silent --data-binary @- https://paste.rs)

# Pastebin URL
echo "Pastebin URL: $output"
echo -e ""
