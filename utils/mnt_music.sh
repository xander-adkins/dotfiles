#!/bin/bash
# Mounts the Music Network Drive ("music_library") sourcing the password from the MacOS Keychain

USERNAME="tc"
PASSWORD=`security find-internet-password -s "music_library" -w`

open "smb://$USERNAME:$PASSWORD@music_library"
