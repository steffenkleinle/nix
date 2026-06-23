{ config, pkgs, pkgs-stable, lib, inputs, ... }:

rec {
  imports = [ 
    inputs.nixvim.homeModules.nixvim
  ];

  fonts.fontconfig.enable = true;

  home.username = "st";
  home.homeDirectory = "/Users/st";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    ANDROID_HOME = "/Users/st/Library/Android/sdk";
    FASTLANE_SKIP_UPDATE_CHECK = "true";
    # react-native dev-tools
    BROWSER = "chromium";
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
    borgbackup
    bundler
    cmake
    colima
    devcontainer
    docker-client
    firefox
    gnupg
    go
    jdk17
    keepassxc
    libfido2
    nix-direnv
    openssh
    nodejs
    podman
    podman-compose
    protobuf
    rectangle
    (lib.hiPrio ruby)
    signal-desktop
    syncthing-macos
    thunderbird
    yubikey-manager
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
      /usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
      /usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519_signing 2>/dev/null

      set -l sock (ls -t ~/.ssh/agent/s.c7awK9uv4P.agent.* 2>/dev/null | head -n1)
      if test -n "$sock"
        set -gx HOST_SSH_AUTH_SOCK $sock
      end
    '';
    shellAliases = {
      dc = "devcontainer up --workspace-folder . --config ~/devcontainer/devcontainer.json --log-level info --log-format text";
      libreoffice = "/Applications/LibreOffice.app/Contents/MacOS/soffice";
      rebuild = "sudo darwin-rebuild switch --flake ~/nix";
      vim = "nvim";
      yarn = "corepack yarn";
      pnpm = "corepack pnpm";
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
      IgnoreUnknown UseKeychain

      Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519
        IdentityFile ~/.ssh/id_ed25519_signing
        IdentitiesOnly yes
        AddKeysToAgent yes
        UseKeychain yes
        PreferredAuthentications publickey
        IdentityAgent SSH_AUTH_SOCK

      Host opencode01.tuerantuer.org
        HostName opencode01.tuerantuer.org
        User opencode
        IdentityFile ~/.ssh/id_ed25519_sk
        IdentitiesOnly yes
        PubkeyAuthentication yes
        IdentityAgent HOST_SSH_AUTH_SOCK
    '';
  };

  services.syncthing.enable = true;

  launchd.agents.colima = {
    enable = true;
    config = {
      Label            = "io.colima.${config.home.username}";
      RunAtLoad        = true;
      KeepAlive        = true;
      ProgramArguments = [
        "${pkgs.colima}/bin/colima" "start" "--foreground"
        "--vm-type"    "vz"
        "--mount-type" "sshfs"
        "--cpu"        "4"
        "--memory"     "8"
        "--disk"       "80"
      ];
      EnvironmentVariables = {
        PATH = lib.makeBinPath [
          pkgs.colima
          pkgs.docker-client
        ] + ":/usr/bin:/bin:/usr/sbin:/sbin";
        HOME = config.home.homeDirectory;
      };
      StandardOutPath  = "${config.home.homeDirectory}/Library/Logs/colima.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/colima.err.log";
    };
  };
}
