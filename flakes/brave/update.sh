#!/usr/bin/env bash

# Extract the path to the nix file (change this if necessary)
nix_file="flake.nix"

# Replace the old SHA256 with a placeholder
placeholder="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
sed -i "s/archiveSha = \".*\";/archiveSha = \"$placeholder\";/" $nix_file

# Run nix build to intentionally get the hash mismatch error
output=$(nix run 2>&1)

# Extract the received SHA256 from the error message
new_hash=$(echo "$output" | grep 'got:' | awk '{print $2}')
echo $output | grep "got"

# Replace the placeholder in the nix file with the new one
if [[ -n $new_hash ]]; then
  sed -i "s/archiveSha = \".*\";/archiveSha = \"$new_hash\";/" $nix_file
  echo "Updated sha256 to $new_hash in $nix_file"
else
  echo "Failed to find a new SHA256 hash."
fi
