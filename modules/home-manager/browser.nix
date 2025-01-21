# browser.nix
{ inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.arjun = {
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        vimium
        darkreader
      ];
    };
  };
}
