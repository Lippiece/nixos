#!/usr/bin/env fish
echo
echo Building (dirs).

# Extract the path to the nix file (change this if necessary)
set nix_file "flake.nix"

# update-nix-fetchgit -v flake.nix

# Run nix build to intentionally get the hash mismatch error
set output (nix build 2>&1)

# Extract the received SHA256 from the error message
set old_hash (echo "$output" | grep -Eo "specified:.+" | awk '{print $2}' | string escape)
set new_hash (echo "$output" | grep -Eo "got:.+" | awk '{print $2}' | string escape)

# Replace the placeholder in the nix file with the new one
if echo $new_hash | grep "sha"
    sed -i "s#$old_hash#$new_hash#" $nix_file
    echo "Updated $old_hash to $new_hash in $nix_file."

    ./update.sh
else
    echo "Failed to find a new SHA256 hash,"
    echo "or the packages was successfully built."
    echo $output
end
notify-send "Brave flake concluded."
