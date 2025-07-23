{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nix-darwin, nixpkgs, home-manager, nixvim, mac-app-util, ... }: let
    configuration = { pkgs, ... }: {
      users.knownUsers = [ "st" ];
      users.users.st = {
        name = "st";
        home = "/Users/st";
        shell = pkgs.zsh;
        uid = 501;
      };

      programs.direnv.enable = true;
      programs.fish.enable = true;
      programs.zsh.enable = true;

      homebrew = {
        enable = true;
        taps = [ "leoafarias/fvm" ];
        brews = [ "bundletool" "circleci" "cocoapods" "fvm" "gnupg" "qemu" "ruby-build" ];
        casks = [ "ferdium" "libreoffice" "mullvadvpn" "standard-notes" "stremio" ];
        onActivation = {
          autoUpdate = true;
          cleanup = "uninstall";
          upgrade = true;
        };
      };

      system = {
        primaryUser = "st";
        defaults = {
          NSGlobalDomain = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            AppleICUForce24HourTime = true;
          };
          dock = {
            autohide = true;
            launchanim = false;
            minimize-to-application = true;
            show-recents = true;
            tilesize = 48;
          };
          finder = {
            _FXShowPosixPathInTitle = true;
            _FXSortFoldersFirst = true;
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            FXDefaultSearchScope = "SCcf";
            FXEnableExtensionChangeWarning = false;
            FXPreferredViewStyle = "Nlsv";
            NewWindowTarget = "Home";
            QuitMenuItem = false;
            ShowHardDrivesOnDesktop = false;
            ShowPathbar = true;
            ShowStatusBar = true;
          };
        };
      };

# TouchId for shell
      security.pam.services.sudo_local.touchIdAuth = true;      

# DO NOT CHANGE START
# Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      nix.enable = false;

# Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

# Used for backwards compatibility, please read the changelog before changing.
# $ darwin-rebuild changelog
      system.stateVersion = 5;

# The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
# DO NOT CHANGE END
    };
  in
  {
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager {
          nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.verbose = true;
          home-manager.users.st = import ./home.nix;
        }
      ({ pkgs, ... }: {
       nixpkgs.config = {
       allowBroken = true;
       allowUnfree = true;
       allowUnfreePredicate = pkg:
       builtins.elem (pkgs.lib.getName pkg) [];
       };
       })
      ];
    }; 
  };
}
