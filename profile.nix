{ pkgs }:

rec {
  # Installed everywhere
  common = pkgs.buildEnv {
    name = "kennethp-env-common";
    paths = with pkgs; [
      bat
      binutils
      coreutils
      curl
      exa
      clinfo
      macchina
      freetype
      fontconfig
      flatpak
      fd
      fzf
      git
      (python3.withPackages
        (ps:
          with ps; [
            autopep8
            black
            flake8
            ipykernel
            ipython
            ipywidgets
            mypy
            numpy
            pep8
            pyls-mypy
            requests
            scipy
            setuptools
            virtualenv
          ]))
      ripgrep
      tcpdump
      tree
      unzip
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
    ];
    extraOutputsToInstall = [ "man" "doc" ];
  };

  # Installed on personal systems with a GUI
  gui = pkgs.buildEnv
    {
      name = "kennethp-env-common";
      # Include all package in `common` above
      paths = [ common ] ++ (with pkgs; [
        alacritty
        blueman
        cmatrix
        dig
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
        wine
        qemu
        virt-manager
        jetbrains.pycharm-community
        telegram-desktop
        teams-for-linux
        ncspot
        wezterm
        kdeconnect
        thunderbird
        docker
        lutris
        (lutris.override {
            extraPkgs = pkgs: [
                wineWowPackages.stable
                winetricks
                ];
            }
        )
        docker-compose
        ffmpeg-full
        firefox-beta-bin
        flameshot
        obs-studio
        obsidian
        foliat
        inkscape
        krita
        lolcat
        nix-direnv
        nixops
        okular
        rustup
        spotify
        tldr
        tomb
        firefox
        youtube-dl
        vlc
      ]);
      extraOutputsToInstall = [ "man" "doc" ];
    };
}
