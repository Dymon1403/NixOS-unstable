{ config, pkgs, ... }:

{
  # ============================================
  # BOOT
  # ============================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================
  # Filesystem
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
  # Network
  # ============================================
  networking.hostName = "Thinkpad"; # поменяй на своё
  networking.networkmanager.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================
  # User
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
  # Login_manager
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
  # Graph
  # ============================================
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  hardware.enableRedistributableFirmware = true;

  # ============================================
  # Sound (PipeWire)
  # ============================================
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # ============================================
  # Packages
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
  # NIX setings
  # ============================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;

  # ============================================
  # Time
  # ============================================
  time.timeZone = "Europe/Moscow";
  services.timesyncd.enable = true;


  # ============================================
  # Version
  # ============================================
  system.stateVersion = "24.11";
}
