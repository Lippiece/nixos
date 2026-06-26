{pkgs, ...}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d3d44327-bd14-4e4f-93ca-3b6869f41ed0";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
    ];
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
    options = [
      "subvol=persist"
      "compress=zstd"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/d3d44327-bd14-4e4f-93ca-3b6869f41ed0";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  boot.initrd.systemd = {
    services.impermance-btrfs-rolling-root = {
      description = "Archiving existing BTRFS root subvolume and creating a fresh one";
      # Specify dependencies explicitly
      unitConfig.DefaultDependencies = false;
      # The script needs to run to completion before this service is done
      serviceConfig = {
        Type = "oneshot";
        # NOTE: to be able to see errors in your script do this
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };
      # This service is required for boot to succeed
      requiredBy = ["initrd.target"];
      # Should complete before any file systems are mounted
      before = ["sysroot.mount"];

      # Wait until the root device is available
      # If you're altering a different device, specify its device unit explicitly.
      # see: systemd-escape(1)
      requires = ["initrd-root-device.target"];
      after = [
        "initrd-root-device.target"
        # Allow hibernation to resume before trying to alter any data
        "local-fs-pre.target"
      ];

      # The body of the script. Make your changes to data here
      script = ''
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
    };
    extraBin = {
      # "mkfs.ext4" = "${pkgs.e2fsprogs}/bin/mkfs.ext4";
      "mkdir" = "${pkgs.coreutils}/bin/mkdir";
      "date" = "${pkgs.coreutils}/bin/date";
      "stat" = "${pkgs.coreutils}/bin/stat";
      "mv" = "${pkgs.coreutils}/bin/mv";
      "find" = "${pkgs.findutils}/bin/find";
      "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
      # mount & umount already exist
    }; # NOTE: path = [...]; doesnt work for initrd, use full paths in your script or extraBin
  };

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
