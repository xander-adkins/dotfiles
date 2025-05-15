#!/bin/bash

set -e

# Function to list available drives
list_drives() {
  echo "Available external drives:"
  diskutil list | grep "(external, physical)"
}

# Prompt user to select a drive
select_drive() {
  list_drives
  echo
  read -p "Device name of the drive to format: " DRIVE
  echo "You have selected: /dev/$DRIVE"
}

# Confirm with the user
confirm_action() {
  read -p "This will erase all data on /dev/$DRIVE. Are you sure? (y/n): " CONFIRM
  if [[ "$CONFIRM" != "y" ]]; then
    echo "Aborting."
    exit 1
  fi
}

# Format the drive
format_drive() {
  read -p "Enter a label for the drive: " LABEL
  echo "Erasing and formatting /dev/$DRIVE as APFS..."

  # Unmount the drive if mounted
  umount "/dev/${DRIVE}"* 2>/dev/null || true

  # Wipe the drive
  wipefs -a "/dev/$DRIVE"

  # Create a new partition table and single partition
  parted -s "/dev/$DRIVE" mklabel gpt mkpart primary apfs 0% 100%

  # Format the partition with APFS
  mkfs.apfs -L "$LABEL" "/dev/${DRIVE}1"
  echo "Drive formatted successfully as APFS with label '$LABEL'."
}

# Main script
select_drive
confirm_action
format_drive

echo "Drive setup is complete."
