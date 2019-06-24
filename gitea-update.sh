#!/bin/sh
#Keep Gitea up to date automatically.

#First check the version previously installed and most recent github version
if [ -e installed-ver.txt ]
then	installed_ver="$(cat installed-ver.txt)"
else	installed_ver=""
fi

last_ver="$(curl -s https://api.github.com/repos/go-gitea/gitea/releases/latest\
| grep created_at | head -1 |cut -d '"' -f 4)"

# Install new gitea if version do not match
echo "Installed version: '$installed_ver' ; Last github release: '$last_ver'"
if [ "$installed_ver" != "$last_ver" ]
then 	
	echo "Launching install..."
else 	
	echo "Gitea already up to date."
fi

# All went well, store the last installed version
echo "$last_ver" > installed-ver.txt