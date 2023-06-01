let
  load = src:
    inputs.hive.load {
      inherit inputs cell src;
    };
in {
  shell = load ./homeProfiles/shell;
  gui = load ./homeProfiles/gui;
}
