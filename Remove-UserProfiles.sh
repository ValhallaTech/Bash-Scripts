#!/bin/bash

# Variables for accounts to be excluded from the removal process
acctsExcluded=("ramadmin")

# Function to check if a value is in an array
contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [[ "${!i}" == "${value}" ]]; then
            return 0
        fi
    }
    return 1
}

# Get all user accounts
useraccounts=$(dscl . -list /Users | grep -vE '(^_|daemon|nobody)')

# Iterate through each user account
for username in $useraccounts; do
    # Check if the username is in the excluded accounts array
    if contains "${acctsExcluded[@]}" "$username"; then
        echo "Skipping excluded account: $username"
    else
        userdir="/Users/$username"

        # Delete the user directory
        if [ -d "$userdir" ]; then
            echo "Deleting user directory: $userdir"
            sudo rm -rf "$userdir"
        fi

        # Delete the user account from the Directory Service
        echo "Deleting user account: $username"
        sudo dscl . -delete "/Users/$username"
    fi
done
