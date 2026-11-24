{ ... }:

{
  imports = [
    ./shell.nix
    ./applications.nix
  ];

  home.username = "subaru";
  home.homeDirectory = "/home/subaru";
  home.stateVersion = "26.05";
}
