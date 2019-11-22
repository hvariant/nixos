{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      /etc/nixos/boot.nix
      /etc/nixos/network.nix
      /etc/nixos/packages.nix
    ];

  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Australia/Sydney";

  programs.zsh = {
    enable = true;

    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${config.services.xserver.displayManager.session.script}";
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # https://www.reddit.com/r/NixOS/comments/atqlf0/how_to_get_mlocate_working_a_guide_for_the_future/
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
  };

  services.openssh.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  users.users.vagrant = {
    isNormalUser = true;
    extraGroups = [ "wheel" "mlocate" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  system.stateVersion = "19.09";
}

