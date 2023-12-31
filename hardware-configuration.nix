# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "nvme" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "video=DP-1:1920x1080@144"
    "video=DP-2:1920x1080@144"
    "video=DP-3:1920x1080@60"
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e623756c-d31a-4cfe-8b51-842896f5b9a0";
      fsType = "ext4";
    };

  fileSystems."/mnt/Games" =
    { device = "/dev/disk/by-uuid/304e90e3-da1c-4bc6-8ec3-3fd1c70938ce";
      fsType = "btrfs"; 
#      options = [ ];
  };

  fileSystems."/mnt/Elements" = 
    { device = "/dev/disk/by-uuid/9ff98d32-f6ef-4226-ad80-04f14e3b842f";
      fsType = "btrfs";
#      options = [ ]; 
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0225-D1BB";
      fsType = "vfat";
    };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # Reduce Swappiness
  boot.kernel.sysctl = { "vm.swappiness" = 0;};
}
