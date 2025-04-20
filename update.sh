#!/usr/bin/env fish
echo
echo Building (dirs).

nix flake update

# Extract the path to the nix file (change this if necessary)
set file "flake.nix"

update-nix-fetchgit -v $file

# Run nix build to intentionally get the hash mismatch error
# set output (nix build 2>&1)

# Extract the received SHA256 from the error message
# set hashes (echo "$output" | ag -o 'sha256.\K\S+')
# set old_hash (echo "$hashes" | awk '{print $1}')
# set new_hash (echo "$hashes" | awk '{print $2}')

# Replace the placeholder in the nix file with the new one
# if echo "$output" | ag "mismatch"
#     sed -i "s#$old_hash#$new_hash#" $file
#     echo "Updated $old_hash"
#     echo "to $new_hash"
#     echo "in $file."
#
#     ./update.sh
# else
#     echo "Failed to find a new SHA256 hash,"
#     echo "or the package was successfully built."
#     echo $output
# end
