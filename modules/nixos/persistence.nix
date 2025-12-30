{lib, ...}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d3d44327-bd14-4e4f-93ca-3b6869f41ed0";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D373-1234";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/d3d44327-bd14-4e4f-93ca-3b6869f41ed0";
    neededForBoot = true;
    fsType = "btrfs";
    options = ["subvol=persist"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/d3d44327-bd14-4e4f-93ca-3b6869f41ed0";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    lsblk -f
    echo

    mkdir /btrfs_tmp
    mount /dev/disk/by-uuid/d3d44327-bd14-4e4f-93ca-3b6869f41ed0 /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/home/lippiece"
      "/usr"
      "/var/log"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/var/keys/secret_file";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
    ];
  };
}
