# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# Main
{
  # Imports
  imports = [
        ./hardware-configuration.nix
        ];

  ## Boot Configurations
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ## 32Bit Support
  # Add support for 32Bit - opengl, pulseaudio
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Vulkan Support - 32Bit, OpenCL
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # For 32 bit applications
  # Only available on unstable
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  ## Locale/Region
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  ## Networking
  # Hostname
    networking.hostName = "Gwyn"; # Define your hostname.

  # Enable networking
    networking.networkmanager.enable = true;

  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ## Firewall
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  ## Desktop Environment/Window Management/Graphics
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # HIP libraries
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  ## Packages
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
        "openssl-1.1.1u"
        "python-2.7.18.6"
        "electron-12.2.3"
        ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed>
        lutris
        (lutris.override {
                extraPkgs = pkgs: [
                        wineWowPackages.stable
                        winetricks
                        ];
                })
        wget
        firefox
        clinfo
        neofetch
        file
        neovim
        git
        fontconfig
        freetype
        flatpak
        openssl
        fnm
        ripgrep
        tldr
        unzip
        btop
        htop
        bat
        gparted
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
        wine
        python3Full
        python.pkgs.pip
        qemu
        virt-manager
        jetbrains.pycharm-community
        discord
        telegram-desktop
        teams-for-linux
        ncspot
        wezterm
        spotify
        krita
        kdeconnect
        kate
        thunderbird
        conda
  ];

  # Enable ZSH
  programs.zsh.enable = true;
## Audio
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  ## Services
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kennethp";

  # Virtualization Services (libvirtd // virt-viewer)
  virtualisation.libvirtd.enable = true;
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  ## User Configurations
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kennethp = {
    isNormalUser = true;
    description = "Kenneth Perry";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
  };

  # Set Default Shell to ZSH
  users.defaultUserShell = pkgs.zsh;

  # Add zsh to /etc/shells
  environment.shells = with pkgs; [ zsh ];

  # Fonts
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      nerdfonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
              monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
              serif = [ "Noto Serif" "Source Han Serif" ];
              sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  ## Gaming
  # Steam Firewall Configurations
  programs.steam = {
                enable = true;
                remotePlay.openFirewall = true; # open ports in firewall for Remote Play
                dedicatedServer.openFirewall = true; # open ports in firewall for Dedicated Server
        };

  ## Default Settings for Stateful Data pulled from...
  system.stateVersion = "23.05";

  ## Backups & Upgrades
  # Backup system config
  system.copySystemConfiguration = true;

  # System Upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  ## Garbage Collection
  # Automatic Garbage Collection
  nix.gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 3d";
          };

  # Adding requirements for steam.
  # Add Steam
  nixpkgs.config.allowUnfreePredicate = true;
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
                };

}

