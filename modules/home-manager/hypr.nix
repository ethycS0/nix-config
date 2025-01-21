# hypr.nix

{ pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {

      monitor = [
        "HDMI-A-1, 1920x1080@165, 0x0, 1"
        "eDP-1, 1920x1080@144, -1920x0, 1.20"
      ];

      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun -show-icons";
      "$browser" = "firefox";

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        # Could Use nix-colors
        col.active_border = "rgba(ffffffff)";
        col.inactive_border = "rgba(595959 aa)";
      };
    };
  };
}
