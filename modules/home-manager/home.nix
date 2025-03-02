{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./lf/lf.nix
  ];

  home = {
    username = "arjun";
    homeDirectory = "/home/arjun";
    stateVersion = "24.11";
    packages = [
    ];
    file = {
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
  programs.firefox.enable = true;

}
