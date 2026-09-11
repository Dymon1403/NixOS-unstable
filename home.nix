{ config, pkgs, ... }:

{

home.username = "dmitrj";
  home.homeDirectory = "/home/dmitrj";

  programs.bash = {
    enable = true;
    shellAliases = {
      bt = "bluetoothctl";
      ff = "fastfetch";
      nixup = "sudo nix flake update && sudo nixos-rebuild switch --flake .#thinkpad";
    };
  };

  # Pkgs for user
  home.packages = with pkgs; [
    alacritty
    firefox
    yazi
    tree
    rofi-wayland
    waybar
    swayimg
    grim
    hyprshot
    slurp
    mpv
    ffmpeg

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # Storage of SECRET
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  # configs for apps (in home-manager)
  programs.git = {
    enable = true;
    userName = "Dymon1403";
    userEmail = "dymaroxer1403@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  # Neovim minimal configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };


  # Home repo
  home.stateVersion = "26.05";
}
