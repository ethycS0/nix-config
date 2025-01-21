{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./browser.nix
    # ./hypr.nix
    ./neovim/neovim.nix
    ./lf/lf.nix
  ];

  home.username = "arjun";
  home.homeDirectory = "/home/arjun";
  home.stateVersion = "24.11";
  home.packages = [
  ];
  home.file = {
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

}
