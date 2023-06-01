{
  description = "The Hive - The secretly open NixOS-Society";

  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";

  inputs.hive.url = "github:divnix/hive";
  inputs.hive.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs.url = "github:numtide/nixpkgs-unfree/nixos-unstable";
  inputs.nixpkgs.inputs.nixpkgs.follows = "nixpkgs-unstable";

  inputs.std-data-collection.url = "github:divnix/std-data-collection";
  inputs.std-data-collection.inputs.std.follows = "std";
  inputs.std-data-collection.inputs.nixpkgs.follows = "nixpkgs";

  # tools
  inputs = {
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.inputs.flake-utils.follows = "std/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators.url = "github:blaggacao/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixlib.follows = "nixpkgs";
    # colmena.url = "github:zhaofengli/colmena";
    colmena.url = "github:blaggacao/colmena/fix-1000-nixpkgs";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    colmena.inputs.stable.follows = "std/blank";
    colmena.inputs.flake-utils.follows = "std/flake-utils";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    qnr.url = "github:divnix/quick-nix-registry";
  };
  inputs.hive.inputs = {
    nixos-generators.follows = "nixos-generators";
    colmena.follows = "colmena";
    disko.follows = "disko";
  };

  # nixpkgs & home-manager
  inputs = {
    nixos.follows = "nixos-22-11";
    home.follows = "home-22-11";

    nixos-22-05.url = "github:nixos/nixpkgs/release-22.05";
    home-22-05.url = "github:blaggacao/home-manager/release-22.05"; # some temp fixes

    nixos-22-11.url = "github:nixos/nixpkgs/release-22.11";
    home-22-11.url = "github:nix-community/home-manager/release-22.11"; # fixes incorporated
  };

  outputs = {
    std,
    hive,
    self,
    ...
  } @ inputs:
    hive.growOn {
      inherit inputs;
      cellsFrom = ./comb;
      cellBlocks =
        # use blocktypes from both frameworkd
        with std.blockTypes;
        with hive.blockTypes; [
          # modules implement
          (functions "nixosModules")
          (functions "homeModules")
          (functions "devshellModules")

          # profiles activate
          (functions "hardwareProfiles")
          (functions "nixosProfiles")
          (functions "homeProfiles")
          (functions "devshellProfiles")

          # suites aggregate profiles
          (functions "nixosSuites")
          (functions "homeSuites")

          # configurations can be deployed
          nixosConfigurations
          colmenaConfigurations
          homeConfigurations
          diskoConfigurations

          # devshells can be entered
          (devshells "shells")

          # jobs can be run
          (runnables "jobs")

          # library holds shared knowledge made code
          (functions "library")
        ];
    }
    # soil
    {
      packages.x86_64-linux = {inherit (inputs.disko.packages.x86_64-linux) disko;};
      devShells = std.harvest self ["repo" "shells"];
    }
    {
      colmenaHive = hive.collect self "colmenaConfigurations";
      nixosConfigurations = hive.collect self "nixosConfigurations";
      homeConfigurations = hive.collect self "homeConfigurations";
      diskoConfigurations = hive.collect self "diskoConfigurations";
    };

  # --- Flake Local Nix Configuration ----------------------------
  nixConfig = {
    extra-substituters = [
      "https://numtide.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  # --------------------------------------------------------------
}
