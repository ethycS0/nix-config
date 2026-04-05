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
        v2-settings = true;
        settings = {

          xwayland-satellite = {
            path = lib.getExe pkgs.xwayland-satellite;
          };

          spawn-at-startup = [
            (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.my-noctalia)

            [
              (lib.getExe pkgs.swaybg)
              "-c"
              "#000000"
            ]

            (lib.getExe pkgs.gromit-mpx)
          ];

          hotkey-overlay = {
            skip-at-startup = true;
          };

          outputs = {
            "eDP-2" = {
              position = _: {
                props = {
                  x = 0;
                  y = 0;
                };
              };
              scale = 1.25;
            };
            "DP-1" = {
              position = _: {
                props = {
                  x = 2048;
                  y = 0;
                };
              };
              scale = 1.0;
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
            gaps = 3;
          };

          # Keybindings
          binds = {
            "Mod+D".spawn = [
              (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.my-noctalia)
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
            "Mod+Shift+K".move-window-up-or-to-workspace-up = [ ];
            "Mod+Shift+J".move-window-down-or-to-workspace-down = [ ];

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

            # Quit
            "Mod+Shift+Escape".quit = [ ];
          };
        };
      };
    };
}
