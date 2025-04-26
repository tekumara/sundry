#!/usr/bin/env bash

# this lets users in $group change their shell without sudo

set -euo pipefail

group="mygroup"

line1="# allow the group $group to use chsh without sudo"
line2="auth\t\tsufficient\tpam_wheel.so trust group=$group"

# insert after this line
before_pattern=$'^auth[[:space:]]*sufficient[[:space:]]*pam_rootok\.so$'

# File to be modified
pam_file="/etc/pam.d/chsh"

# Check if the line already exists in the file
if grep -Fxq "$line2" "$pam_file"; then
    echo "The line is already present in $pam_file. No changes made."
else
    # Use sed to insert the line after the matching pattern
    sudo sed -i "/$before_pattern/a $line1\n$line2" "$pam_file"
    echo "Line added to $pam_file after the matching pattern."
fi
