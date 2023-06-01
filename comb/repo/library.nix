let
  l = inputs.nixpkgs.lib // builtins;
in rec {
  /*
  *
  Synopsis: rakeLeaves _path_

  Recursively collect the nix files of _path_ into attrs.

  Output Format:
  An attribute set where all `.nix` files and directories with `default.nix` in them
  are mapped to keys that are either the file with .nix stripped or the folder name.
  All other directories are recursed further into nested attribute sets with the same format.

  Example file structure:
  ```
  ./core/default.nix
  ./base.nix
  ./main/dev.nix
  ./main/os/default.nix
  ```

  Example output:
  ```
  {
    core = ./core;
    base = base.nix;
    main = {
      dev = ./main/dev.nix;
      os = ./main/os;
    };
  }
  ```
  *
  */
  rakeLeaves = dirPath: let
    seive = file: type:
    # Only rake `.nix` files or directories
      (type == "regular" && l.hasSuffix ".nix" file) || (type == "directory");

    collect = file: type: {
      name = l.removeSuffix ".nix" file;
      value = let
        path = dirPath + "/${file}";
      in
        if
          (type == "regular")
          || (type == "directory" && l.pathExists (path + "/default.nix"))
        then path
        # recurse on directories that don't contain a `default.nix`
        else rakeLeaves path;
    };

    files = l.filterAttrs seive (l.readDir dirPath);
  in
    l.filterAttrs (n: v: v != {}) (l.mapAttrs' collect files);
}
