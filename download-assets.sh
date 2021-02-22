#!/bin/bash
# Downloads and checks the assets for latest version of gitea on github.
# Returns 0 if everything went OK. 1 if something was wrong.

# Set working directory to that of current script.
cd "${0%/*}" || exit

# First clean the directory by removing every file with xz in name.
rm ./*xz*

# Download the latest assets and check success.
if ! curl -s https://api.github.com/repos/go-gitea/gitea/releases/latest \
| grep assets_url | cut -d '"' -f 4 | xargs curl -s | grep browser_download_url\
| grep linux-amd64.xz | while read -r line ; do echo "$line" | cut -d '"' -f 4 \
; done | xargs wget -q

then	 echo "Failed to download assets."
	 exit 1
fi

echo "Assets downloaded successfully."

# Check signature
#	First import the public key
if ! gpg --keyserver keys.openpgp.org --recv 7C9E68152594688862D62AF62D9AE806EC1592E2
then echo "Failed to import public key"
     exit 1
fi
echo "Public key successfully imported"

#	Then check the signature of archive
if ! gpg --verify ./*.asc ./*.xz
then echo "Signature check FAILED"
     exit 1
fi
echo "Signatures match"

# Uncompress
unxz ./*.xz
mv ./*amd64 gitea
chmod +x gitea

echo "Binary uncompressed."

exit 0
