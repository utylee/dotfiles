#!/bin/bash

# Delay to allow network to initialize

# Mount points and credentials (replace 'user' and 'password' accordingly)
# mkdir -p /Users/utylee/Volumes/4001
mount_smbfs //utylee:sksmsqnwk11@192.168.1.202/4001 /Users/utylee/Volumes/4001

# mkdir -p /Users/utylee/Volumes/8001
mount_smbfs //utylee:sksmsqnwk11@192.168.1.202/8001 /Users/utylee/Volumes/8001

# mkdir -p /Users/utylee/Volumes/4003
# mount_smbfs //utylee:sksmsqnwk11@192.168.100.204/4003 /Users/utylee/Volumes/4003
mount_smbfs //utylee:sksmsqnwk11@192.168.1.204/4003 /Users/utylee/Volumes/4003

# mkdir -p /Users/utylee/Volumes/5003
# mount_smbfs //utylee:sksmsqnwk11@192.168.100.204/5003 /Users/utylee/Volumes/5003
mount_smbfs //utylee:sksmsqnwk11@192.168.1.204/5003 /Users/utylee/Volumes/5003
