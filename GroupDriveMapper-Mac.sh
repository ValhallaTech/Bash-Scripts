#!/bin/bash
# Script to connect to network drives in OS X with error handling and log file creation
# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <your_windows_username> <your_windows_password>"
    exit 1
fi

# Variables
USERNAME=$1
PASSWORD=$2
LOG_FILE="/connect_network_drives.log"

# Network drives
H_DRIVE="smb://wssu.edu/RamFile/Users/$USERNAME"
G_DRIVE="smb://wssu.edu/RamFile/Groups"

# Function to log messages
log() {
    local message=$1
    echo "$(date): $message" >> "$LOG_FILE"
}

# Function to connect to a network drive
connect_drive() {
    local drive=$1
    local drive_name=$2

    echo "Connecting to $drive_name drive..."
    log "Connecting to $drive_name drive..."

    result=$(osascript -e "try" -e "mount volume \"$drive\" as user name \"$USERNAME\" with password \"$PASSWORD\"" -e "return 'success'" -e "on error" -e "return 'error'" -e "end try")

    if [ "$result" == "success" ]; then
        echo "Connected to $drive_name drive successfully."
        log "Connected to $drive_name drive successfully."
    else
        echo "Error: Failed to connect to $drive_name drive."
        log "Error: Failed to connect to $drive_name drive."
        exit 1
    fi
}

# Connect to H:/ drive
connect_drive "$H_DRIVE" "H:/"

# Connect to G:/ drive
connect_drive "$G_DRIVE" "G:/"

echo "Connected to all network drives successfully."
log "Connected to all network drives successfully."
