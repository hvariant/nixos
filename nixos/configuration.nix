{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      ./network.nix
      ./packages.nix
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

  # https://www.reddit.com/r/NixOS/comments/atqlf0/how_to_get_mlocate_working_a_guide_for_the_future/
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
        i3status
      ];
    };
  };

  users.users.spss = {
    isNormalUser = true;
    extraGroups = [ "wheel" "mlocate" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  system.stateVersion = "19.09";
}

