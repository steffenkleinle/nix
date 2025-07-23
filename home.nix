{ config, pkgs, pkgs-stable, lib, inputs, ... }:

rec {
  imports = [ 
    inputs.nixvim.homeManagerModules.nixvim
    inputs.mac-app-util.homeManagerModules.default
  ];

  fonts.fontconfig.enable = true;

  home.username = "st";
  home.homeDirectory = "/Users/st";
  home.stateVersion = "25.05";
  home.sessionVariables = {
    ANDROID_HOME = "/Users/st/Library/Android/sdk";
    FASTLANE_SKIP_UPDATE_CHECK = "true";
    # https://podman-desktop.io/tutorial/testcontainers-with-podman
    TESTCONTAINERS_RYUK_DISABLED = "true";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
  };
  home.sessionPath = [
    "$ANDROID_HOME/build-tools"
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/platform-tools"
  ];
  home.keyboard.options = [ "caps:swapescape" ];

  home.packages = with pkgs; [
    baobab
    borgbackup
    bundler
    cmake
    gimp
    gnupg
    go
    jdk17
    jitsi-meet-electron
    keepassxc
    maccy
    neovide
    nodejs
    podman
    podman-compose
    protobuf
    rectangle
    (lib.hiPrio ruby)
    signal-desktop-bin
    thunderbird
    yarn
  ];

  programs.kitty = {
    enable = true;
    settings = {
      shell = "/run/current-system/sw/bin/fish";
      confirm_os_window_close = 0;
      tab_bar_style = "custom";
      tab_separator = "";
      tab_title_template = " {index} {title} ";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      eval "$(/opt/homebrew/bin/brew shellenv)"
      ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null
    '';
    shellAliases = {
      libreoffice = "/Applications/LibreOffice.app/Contents/MacOS/soffice";
      rebuild = "sudo darwin-rebuild switch --flake ~/nix";
      vim = "nvim";
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  programs.firefox = 
  let
    settings = {
      "signon.rememberSignons" = false;
      "browser.aboutConfig.showWarning" = false;
      "browser.compactmode.show" = true;
    };
    search = {
      force = true;
      default = "ddg";
      order = [ "ddg" "google" ];
    };
  in {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = settings;
        search = search;
      };
      digitalfabrik = {
        id = 1;
        name = "digitalfabrik";
        settings = settings;
        search = search;
      };
      verdigado = {
        id = 2;
        name = "verdigado";
        settings = settings;
        search = search;
      };
      netzbegruenung = {
        id = 3;
        name = "netzbegruenung";
        settings = settings;
        search = search;
      };
    };
  };

  programs.nixvim = import ./nvim.nix;  
  programs.zsh.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        AddKeysToAgent yes
        UseKeychain yes
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_rsa
        IdentityFile ~/.ssh/id_ed25519_signing
    '';
  };

  services.syncthing.enable = true;

  systemd.user.services.ssh-add = {
    description = "Add ssh key";
    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${pkgs.bash}/bin/bash ssh-add --apple-use-keychain ~/.ssh/id_rsa";
    wantedBy = [ "default.target" ];
  };
}
