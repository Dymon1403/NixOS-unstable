{ config, pkgs, ... }:

{
  # ============================================
  # ЗАГРУЗЧИК
  # ============================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================
  # ДИСКИ (2 раздела: sda1 - EFI, sda2 - BTRFS)
  # ============================================
  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  # ============================================
  # СЕТЬ
  # ============================================
  networking.hostName = "Thinkpad"; # поменяй на своё
  networking.networkmanager.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================
  # ПОЛЬЗОВАТЕЛЬ
  # ============================================
  users.users.dmitrj = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "input" ];
    shell = pkgs.bash;
    # Пароль задашь при первом входе командой passwd
  };

  # sudo без пароля
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  # ============================================
  # ЛОГИН МЕНЕДЖЕР
  # ============================================
  services.displayManager.ly.enable = true;

  # ============================================
  # HYPRELAND
  # ============================================
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Переменные для Wayland
  environment.variables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
  };

  # ============================================
  # ГРАФИКА
  # ============================================
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  hardware.enableRedistributableFirmware = true;

  # ============================================
  # ЗВУК (PipeWire)
  # ============================================
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # ============================================
  # ПАКЕТЫ
  # ============================================
  environment.systemPackages = with pkgs; [
    # Системные
    git
    neovim
    wget
    curl
    htop
    fastfetch
    pulsemixer
    unzip

    # Hyprland окружение
    hyprland
    waybar
    rofi-wayland
    dunst
    firefox
    alacritty

    # Звук
    pavucontrol
    pamixer
  ];

  # ============================================
  # МОИ КОНФИГИ (копируются из /etc/nixos/dotfiles/)
  # ============================================
  environment.etc."xdg/wayland/hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;
  environment.etc."xdg/wayland/waybar/config".source = ./dotfiles/waybar/config;
  environment.etc."xdg/wayland/waybar/style.css".source = ./dotfiles/waybar/style.css;

  # ============================================
  # NIX НАСТРОЙКИ
  # ============================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;

  # ============================================
  # ВРЕМЯ
  # ============================================
  time.timeZone = "Europe/Moscow";
  services.timesyncd.enable = true;


  # ============================================
  # ВЕРСИЯ
  # ============================================
  system.stateVersion = "24.11";
}
