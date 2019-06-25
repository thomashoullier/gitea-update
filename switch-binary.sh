#!/bin/sh
# Switch the gitea binary with the newer one.

cd "${0%/*}" || exit

# First stop the gitea service
sudo systemctl stop gitea

# Move old backup to backup2
if [ -e gitea.backup ]
then 	
	if [ -e gitea.backup2 ]
	then	rm gitea.backup2
	fi
	mv gitea.backup gitea.backup2
fi

# Move old binary to backup.
mv /usr/local/bin/gitea gitea.backup

# Move last binary to bin location
mv gitea /usr/local/bin/gitea

# Start the new binary.
sudo systemctl start gitea
