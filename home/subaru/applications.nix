{ pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty
    librewolf
    waybar
    swaylock
  ];
}
