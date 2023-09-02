{ config, lib, pkgs, options, ... }:

{
  nix.settings.trusted-users = [ "kennethp" ];

  # Imports
  imports = [ 
    ./hardware-configuration.nix
  ];
  
  # Allow Insecure and Unfree
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
    "python-2.7.18.6"
    "electron-12.2.3"
    "python2.7-certifi-2021.10.8"
    "python2.7-pyjwt-1.7.1"
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Boot and Hardware Configurations
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ext4" ];
  hardware.enableRedistributableFirmware = true;
  powerManagement.powertop.enable = false;

  # 32Bit Support
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # Location - Region - Locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking
  networking.hostName = "Gwyn";
  networking.networkmanager.enable = true; 

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "enp5s0" "virbr0" ];
  networking.hosts = {
    "172.16.0.21" = [ "gwyn.local" ];
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.blueman pkgs.foliate ];

  # Desktop Environment/Window Management/Graphics
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "";

  # Include the profile packages in the systemPackages and environment.systemPackages lists
  environment.systemPackages = with pkgs; [
    chromium
    bat
    coreutils
    curl
    exa 
    clinfo
    macchina
    betterdiscord-installer
    betterdiscordctl
    freetype
    fontconfig
    flatpak
    git
    ripgrep
    tcpdump
    tree
    unzip
    winetricks
    vim
    wget
    zip
    zsh
    file
    openssl
    fnm
    unzip
    btop
    htop
    partition-manager
    clamav
    ruby
    alacritty
    blueman
    discord
    ranger
    viewnior
    cava 
    steam   
    steam-run
    onlyoffice-bin
    etcher  
    flameshot
    vscodium
    mangohud
    protonup-ng
    protontricks
    wineWowPackages.unstableFull
    qemu
    zsh    
    virt-manager
    jetbrains.pycharm-community
    telegram-desktop
    teams-for-linux
    ncspot 
    wezterm 
    kdeconnect
    thunderbird
    bash
    lutris  
    (lutris.override {
        extraPkgs = pkgs: [
            wineWowPackages.stable
            winetricks
            ];
        }
    )
    ffmpeg-full
    firefox-beta-bin
    flameshot
    obs-studio
    obsidian
    inkscape
    krita
    okular
    rustup
    spotify
    tldr
    tomb
    xz
    firefox
    vlc
    man
  ];

  programs.zsh.enable = true;
  programs.adb.enable = true;

  # Audio
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Services
  services.printing.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kennethp";
  virtualisation.libvirtd.enable = true;
  services.flatpak.enable = true;
  services.openssh.enable = true;

  # User Configurations
  users.users.kennethp = {
    isNormalUser = true;
    description = "Kenneth Perry";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      corefonts
      terminus_font
      dejavu_fonts
      ubuntu_font_family
      source-code-pro
      source-sans-pro
      source-serif-pro
      roboto-mono
      roboto
      overpass
      noto-fonts
      nerdfonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      fira-code-nerdfont
      google-fonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "CaskaydiaCove Nerd Font Mono, Regular" ];
        serif = [ "CaskaydiaCove Nerd Font, Regular" ];
        sansSerif = [ "CaskaydiaCove Nerd Font Propo, Regular" ];
      };
    };
  };

  # Programs Config
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  nixpkgs.config.allowUnfreePredicate = true;
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  # Misc
  system.stateVersion = "23.05";

  # Backups & Upgrades
  system.copySystemConfiguration = false;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  # Security
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
