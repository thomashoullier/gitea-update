#!/bin/sh
#Keep Gitea up to date automatically.

#Set the working directory to that of the script.
cd "${0%/*}" || exit

#First check the version previously installed and most recent github version
if [ -e installed-ver.txt ]
then	installed_ver="$(cat installed-ver.txt)"
else	installed_ver=""
fi

last_ver="$(curl -s https://api.github.com/repos/go-gitea/gitea/releases/latest\
| grep created_at | head -1 |cut -d '"' -f 4)"

# Exit if versions match
echo "Installed version: '$installed_ver' ; Last github release: '$last_ver'"
if [ "$installed_ver" = "$last_ver" ]
then 	echo "Gitea already up to date."
	exit 0
fi

# Download and check the latest assets.
if ! ./download-assets.sh
then 	echo "Aborting installation."
	exit 1
fi

# Switch the binaries
./switch-binary.sh

# All went well, store the last installed version
echo "$last_ver" > installed-ver.txt
