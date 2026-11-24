{ pkgs, ... }:

{
  programs.fish.enable = true;

  home.packages = [
    pkgs.alacritty
    pkgs.librewolf
  ];
}
