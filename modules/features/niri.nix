{ self, inputs, ... }:

{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.my-niri;
      };
    };

  perSystem =
    { pkgs, lib, ... }:

    {
      packages.my-niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {

          xwayland-satellite = {
            path = lib.getExe pkgs.xwayland-satellite;
          };

          hotkey-overlay = {
            skip-at-startup = true;
          };

          outputs = {
            "DP-3" = {
              mode = "2560x1440@179.877";
              scale = 1;
              position = _: {
                props = {
                  x = 0;
                  y = 0;
                };
              };
            };
            "eDP-2" = {
              mode = "2560x1600@120.000";
              scale = 1.25;
              position = _: {
                props = {
                  x = 0;
                  y = 1440;
                };
              };
            };
          };

          # Input
          input = {
            keyboard.xkb.options = "caps:escape";
            touchpad = {
              tap = [ ];
              dwt = [ ];
            };
          };

          layout = {
            gaps = 1;
            background-color = "transparent";
            focus-ring.width = 1;
            border.width = 1;
          };

          layer-rules = [
            {
              matches = [ { namespace = "dms:blurwallpaper"; } ];
              place-within-backdrop = true;
            }
          ];

          # Keybindings
          binds = {
            "Mod+D".spawn = [
              # (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.my-noctalia)
              "ipc"
              "call"
              "launcher"
              "toggle"
            ];

            "Mod+Shift+Slash".show-hotkey-overlay = [ ];

            # Applications
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+A".spawn = lib.getExe pkgs.firefox;
            "Mod+Backslash".spawn = lib.getExe pkgs.nautilus;
            "Mod+Shift+E".spawn = [
              (lib.getExe pkgs.gromit-mpx)
              "--toggle"
            ];
            "Mod+Shift+A".screenshot = [ ];

            # Window Management
            "Mod+W".close-window = [ ];
            "Mod+Q".toggle-window-floating = [ ];
            "Mod+F".maximize-column = [ ];
            "Mod+Shift+F".fullscreen-window = [ ];

            # Navigation
            "Mod+H".focus-column-left = [ ];
            "Mod+L".focus-column-right = [ ];
            "Mod+K".focus-window-up = [ ];
            "Mod+J".focus-window-down = [ ];

            "Mod+Shift+H".move-column-left = [ ];
            "Mod+Shift+L".move-column-right = [ ];
            "Mod+Shift+K".move-window-up = [ ];
            "Mod+Shift+J".move-window-down = [ ];

            "Mod+Alt+H".set-column-width = "-10%";
            "Mod+Alt+L".set-column-width = "+10%";
            "Mod+Alt+K".set-window-height = "-10%";
            "Mod+Alt+J".set-window-height = "+10%";

            # Workspaces
            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;

            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;

            # Monitors
            "Mod+Ctrl+K".focus-monitor-up = [ ];
            "Mod+Ctrl+J".focus-monitor-down = [ ];

            "Mod+Shift+Ctrl+K".move-window-to-monitor-up = [ ];
            "Mod+Shift+Ctrl+J".move-window-to-monitor-down = [ ];

            # Laptop Buttons
            "XF86AudioRaiseVolume".spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "5%+"
              "-l"
              "1.5"
            ];
            "XF86AudioLowerVolume".spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "5%-"
            ];
            "XF86AudioMute".spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SINK@"
              "toggle"
            ];
            "XF86AudioMicMute".spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SOURCE@"
              "toggle"
            ];

            # Quit
            "Mod+Shift+Escape".quit = [ ];
          };
        };
      };
    };
}
