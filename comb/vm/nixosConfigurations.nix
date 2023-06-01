{
  vagrant = {pkgs, ...}: {
    bee.system = "x86_64-linux";
    bee.pkgs = import inputs.nixos-22-11 {
      inherit (inputs.nixpkgs) system;
      config.allowUnfree = true;
      overlays = [];
    };
    imports = [
      inputs.qnr.nixosModules.local-registry
      cell.hardwareProfiles.vagrant
    ];

    # swapDevices = [
    #   {
    #     device = "/.swapfile";
    #     size = 8192; # ~8GB - will be autocreated
    #   }
    # ];
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    nix = {
      # buildMachines = [
      #   {
      #     hostName = "192.168.123.150";
      #     sshUser = "ttt";
      #     sshKey = "/home/ttt/.ssh/";
      #     system = "x86_64-linux";
      #     protocol = "ssh";
      #     # if the builder supports building for multiple architectures,
      #     # replace the previous line by, e.g.,
      #     # systems = ["x86_64-linux" "aarch64-linux"];
      #     maxJobs = 2;
      #     speedFactor = 2;
      #     supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      #     mandatoryFeatures = [];
      #   }
      # ];
      distributedBuilds = true;

      gc.automatic = true;
      gc.dates = "weekly";
      optimise.automatic = true;
      nixPath = [
        "nixpkgs=${pkgs.path}"
        "nixos-config=/etc/nixos/configuration.nix"
      ];
      # qick-nix-registry options
      localRegistry = {
        # Enable quick-nix-registry
        enable = true;
        # Cache the default nix registry locally, to avoid extraneous registry updates from nix cli.
        cacheGlobalRegistry = true;
        # Set an empty global registry.
        noGlobalRegistry = false;
      };
      settings = {
        builders-use-substitutes = true;
        trusted-substituters = [
          "https://numtide.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        auto-optimise-store = true;
        allowed-users = ["@wheel"];
        trusted-users = ["root" "@wheel"];
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        accept-flake-config = true;
      };
    };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
      users.root = {
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrCl14a/OKlOzpntF6lF5/DKDSP9E8QeLZt81cciO517ViUtAtOuxluMEzd2yuzR8tIMrREQ6QAIqKtTlN/EX2OQQaN4ohqqYq3FKkU+gD03XONNGCVsRCI7tmMHq2k5rqk6dqOLLp/aj/5OsKAgop3OU9Bfx2vo5WqKo5au8bCSJE+UVdy8QeSFJ7qJ8mNXVnzzv/Epnbi4Aepglwxfw1s2brFjoRXj+qnxVFlyhQMFdAX11ZwtJ2fR9jjzkezCusJ7D/kPs1Z4+e/VcMzUk7GVFR99RjFD7jpThRgMcKYoj03zhO6XDlk+EBjZbPuWUNlmwTjhFUxl5cPwwXXnAd dar@meerkat"
        ];
      };
      users.lar = {
        shell = pkgs.zsh;
        isNormalUser = true;
        initialPassword = "password123";
        extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
      };
    };

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Set your time zone.
    time.timeZone = "Europe/Lisbon";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.wlp2s0.useDHCP = true;
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online = {
      enable = false;
      serviceConfig.TimeoutSec = 15;
      wantedBy = ["network-online.target"];
    };

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
      # Configure keymap in X11
      layout = "us";
      xkbOptions = "";
    };

    services.sshd.enable = true;
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = with pkgs; [hplipWithPlugin];
    };
    # driverless printing via IPP
    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    services.system-config-printer.enable = true;

    # Enable sound.
    sound.enable = true;
    sound.mediaKeys.enable = true;
    hardware.pulseaudio.enable = true;
    # Enable scanning
    hardware.sane.enable = true;


    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      alacritty
    ];
    system.stateVersion = "22.05"; # Did you read the comment?
  };
}
